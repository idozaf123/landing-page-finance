import Foundation

struct ShoppingItem: Identifiable, Codable, Equatable {
    enum Priority: String, CaseIterable, Codable, Identifiable {
        case low
        case medium
        case high

        var id: String { rawValue }

        var title: String {
            switch self {
            case .low: return "נמוכה"
            case .medium: return "בינונית"
            case .high: return "גבוהה"
            }
        }
    }

    enum Category: String, CaseIterable, Codable, Identifiable {
        case groceries = "מזון"
        case produce = "פירות וירקות"
        case bakery = "מאפים"
        case dairy = "מוצרי חלב"
        case household = "בית וניקיון"
        case health = "טיפוח ובריאות"
        case other = "אחר"

        var id: String { rawValue }

        var emoji: String {
            switch self {
            case .groceries: return "🥫"
            case .produce: return "🥬"
            case .bakery: return "🥖"
            case .dairy: return "🧀"
            case .household: return "🧽"
            case .health: return "💊"
            case .other: return "🛒"
            }
        }
    }

    var id: UUID
    var name: String
    var quantity: String
    var category: Category
    var priority: Priority
    var notes: String
    var isCompleted: Bool
    var dateAdded: Date
    var dateCompleted: Date?

    init(id: UUID = UUID(), name: String, quantity: String = "", category: Category = .groceries, priority: Priority = .medium, notes: String = "", isCompleted: Bool = false, dateAdded: Date = .now, dateCompleted: Date? = nil) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.category = category
        self.priority = priority
        self.notes = notes
        self.isCompleted = isCompleted
        self.dateAdded = dateAdded
        self.dateCompleted = dateCompleted
    }
}
