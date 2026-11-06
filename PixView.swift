import SwiftUI

struct PixView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.dismiss) var dismiss
    @State private var recipient: String = ""
    @State private var amount: String = ""
    @State private var showConfirmation = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Transferir via Pix")
                .font(.title2).bold()
                .foregroundColor(.white)

            TextField("Chave Pix", text: $recipient)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)

            TextField("Valor (R$)", text: $amount)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)

            Button {
                showConfirmation = true
            } label: {
                Text("Continuar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(recipient.isEmpty || Double(amount) == nil)

            Spacer()
        }
        .padding()
        .background(Color(red: 0.06, green: 0.06, blue: 0.08).ignoresSafeArea())
        .navigationTitle("Pix")
        .alert("Confirmar Pix", isPresented: $showConfirmation) {
            Button("Cancelar", role: .cancel) {}
            Button("Enviar") {
                if let value = Double(amount) {
                    state.transfer(amount: value)
                }
                dismiss()
            }
        } message: {
            Text("Enviar \(Double(amount)?.brl ?? "") para \(recipient)?")
        }
    }
}
