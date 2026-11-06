import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var state: AppState
    @State private var editingField: EditField?
    @State private var editValue: String = ""

    enum EditField: String, Identifiable {
        case name, balance, invoice, limit, loan
        var id: String { rawValue }
        var title: String {
            switch self {
            case .name: return "Nome"
            case .balance: return "Saldo"
            case .invoice: return "Fatura"
            case .limit: return "Limite"
            case .loan: return "Empréstimo"
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    balanceCard
                    actionButtons
                    creditCardSection
                    transactionsSection
                }
                .padding()
            }
            .background(Color(red: 0.06, green: 0.06, blue: 0.08).ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        .sheet(item: $editingField) { field in
            editSheet(for: field)
        }
    }

    // MARK: - Header
    var header: some View {
        HStack {
            NubankLogo()
            VStack(alignment: .leading, spacing: 2) {
                Text("Olá,")
                    .font(.caption)
                    .foregroundColor(.gray)
                Button {
                    startEditing(.name, value: state.name)
                } label: {
                    Text(state.name)
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            Spacer()
            Image(systemName: "eye")
                .foregroundColor(.gray)
        }
    }

    // MARK: - Balance
    var balanceCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Saldo disponível")
                .font(.subheadline)
                .foregroundColor(.gray)
            Button {
                startEditing(.balance, value: String(format: "%.2f", state.balance))
            } label: {
                Text(state.balance.brl)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(red: 0.10, green: 0.10, blue: 0.13))
        .cornerRadius(16)
    }

    // MARK: - Actions
    var actionButtons: some View {
        HStack(spacing: 24) {
            NavigationLink(destination: PixView()) {
                ActionButton(icon: "dollarsign.circle", title: "Pix")
            }
            ActionButton(icon: "barcode", title: "Pagar")
            ActionButton(icon: "arrow.up.right", title: "Transferir")
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Credit Card
    var creditCardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cartão de Crédito")
                .font(.headline)
                .foregroundColor(.white)

            HStack {
                Text("Fatura atual")
                    .foregroundColor(.gray)
                Spacer()
                Button {
                    startEditing(.invoice, value: String(format: "%.2f", state.invoice))
                } label: {
                    Text(state.invoice.brl).foregroundColor(.white)
                }
            }

            ProgressView(value: min(state.invoice / max(state.limit, 1), 1))
                .tint(.purple)

            HStack {
                Text("Limite disponível")
                    .foregroundColor(.gray)
                Spacer()
                Button {
                    startEditing(.limit, value: String(format: "%.2f", state.limit))
                } label: {
                    Text(state.limit.brl).foregroundColor(.white)
                }
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color(red: 0.10, green: 0.10, blue: 0.13))
        .cornerRadius(16)
    }

    // MARK: - Transactions
    var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Últimas transações")
                .font(.headline)
                .foregroundColor(.white)

            ForEach(state.transactions) { t in
                HStack {
                    Image(systemName: t.icon)
                        .foregroundColor(.purple)
                        .frame(width: 30)
                    Text(t.title).foregroundColor(.white)
                    Spacer()
                    Text(t.amount.brl)
                        .foregroundColor(t.amount >= 0 ? .green : .white)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(red: 0.10, green: 0.10, blue: 0.13))
        .cornerRadius(16)
    }

    // MARK: - Editing
    func startEditing(_ field: EditField, value: String) {
        editingField = field
        editValue = value
    }

    func editSheet(for field: EditField) -> some View {
        NavigationView {
            Form {
                Section(header: Text(field.title)) {
                    TextField("Valor", text: $editValue)
                        .keyboardType(field == .name ? .default : .decimalPad)
                }
                Button("Salvar") {
                    applyEdit(field)
                    editingField = nil
                }
            }
            .navigationTitle("Editar \(field.title)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { editingField = nil }
                }
            }
        }
    }

    func applyEdit(_ field: EditField) {
        switch field {
        case .name: state.name = editValue
        case .balance: state.balance = Double(editValue) ?? state.balance
        case .invoice: state.invoice = Double(editValue) ?? state.invoice
        case .limit: state.limit = Double(editValue) ?? state.limit
        case .loan: state.loan = Double(editValue) ?? state.loan
        }
        state.save()
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.purple)
                .frame(width: 56, height: 56)
                .background(Color.purple.opacity(0.15))
                .clipShape(Circle())
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}

extension Double {
    var brl: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "BRL"
        f.locale = Locale(identifier: "pt_BR")
        return f.string(from: NSNumber(value: self)) ?? "R$ 0,00"
    }
}
