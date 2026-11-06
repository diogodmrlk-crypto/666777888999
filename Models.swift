import Foundation

struct Transaction: Identifiable, Codable {
    let id: UUID
    var title: String
    var amount: Double
    var icon: String
}

class AppState: ObservableObject {
    @Published var name: String = "Usuário"
    @Published var balance: Double = 12450.00
    @Published var invoice: Double = 1230.00
    @Published var limit: Double = 10000.00
    @Published var loan: Double = 5000.00
    @Published var transactions: [Transaction] = [
        Transaction(id: UUID(), title: "Mercado", amount: -45.90, icon: "cart"),
        Transaction(id: UUID(), title: "Salário", amount: 5000.00, icon: "banknote"),
        Transaction(id: UUID(), title: "Netflix", amount: -39.90, icon: "play.tv")
    ]

    private let defaults = UserDefaults.standard

    init() { load() }

    func save() {
        defaults.set(name, forKey: "name")
        defaults.set(balance, forKey: "balance")
        defaults.set(invoice, forKey: "invoice")
        defaults.set(limit, forKey: "limit")
        defaults.set(loan, forKey: "loan")
        if let data = try? JSONEncoder().encode(transactions) {
            defaults.set(data, forKey: "transactions")
        }
    }

    func load() {
        if let n = defaults.string(forKey: "name") { name = n }
        if defaults.object(forKey: "balance") != nil { balance = defaults.double(forKey: "balance") }
        if defaults.object(forKey: "invoice") != nil { invoice = defaults.double(forKey: "invoice") }
        if defaults.object(forKey: "limit") != nil { limit = defaults.double(forKey: "limit") }
        if defaults.object(forKey: "loan") != nil { loan = defaults.double(forKey: "loan") }
        if let data = defaults.data(forKey: "transactions"),
           let t = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = t
        }
    }

    func transfer(amount: Double) {
        balance -= amount
        transactions.insert(
            Transaction(id: UUID(), title: "Pix enviado", amount: -amount, icon: "arrow.up.right"),
            at: 0
        )
        save()
    }
}
