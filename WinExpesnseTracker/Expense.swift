import Foundation

enum ExpenseCategory: String, Codable, CaseIterable {
    case food = "Food"
    case transport = "Transport"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case bills = "Bills"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .food: return "🍔"
        case .transport: return "🚗"
        case .entertainment: return "🎬"
        case .shopping: return "🛍️"
        case .bills: return "💡"
        case .other: return "📦"
        }
    }
    
    var systemIconName: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .entertainment: return "film.fill"
        case .shopping: return "cart.fill"
        case .bills: return "bolt.fill"
        case .other: return "shippingbox.fill"
        }
    }
}

struct Expense: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var amount: Double
    var date: Date
    var category: ExpenseCategory
}
