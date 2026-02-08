import Foundation

class ExpenseService {
    static let shared = ExpenseService()
    private let key = "expenses_data_v1"
    
    private init() {}
    
    func saveExpense(_ expense: Expense) {
        var expenses = loadExpenses()
        expenses.insert(expense, at: 0) // Newest first
        save(expenses)
    }
    
    func loadExpenses() -> [Expense] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            let expenses = try JSONDecoder().decode([Expense].self, from: data)
            return expenses
        } catch {
            print("Failed to load expenses: \(error)")
            return []
        }
    }
    
    func deleteExpense(id: UUID) {
        var expenses = loadExpenses()
        expenses.removeAll { $0.id == id }
        save(expenses)
    }
    
    func updateExpense(_ expense: Expense) {
        var expenses = loadExpenses()
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
            save(expenses)
        }
    }
    
    private func save(_ expenses: [Expense]) {
        do {
            let data = try JSONEncoder().encode(expenses)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save expenses: \(error)")
        }
    }
    
    func getTotalSpent() -> Double {
        return loadExpenses().reduce(0) { $0 + $1.amount }
    }
}
