import SwiftUI

enum Theme: String, CaseIterable, Identifiable, Codable {
    case midnight
    case ocean
    case blossom
    case sunset

    var id: String { rawValue }

    var gradient: LinearGradient {
        switch self {
        case .midnight:
            return LinearGradient(colors: [Color(red: 0.09, green: 0.09, blue: 0.2), Color(red: 0.15, green: 0.25, blue: 0.44)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .ocean:
            return LinearGradient(colors: [Color(red: 0.03, green: 0.42, blue: 0.62), Color(red: 0.02, green: 0.68, blue: 0.81)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .blossom:
            return LinearGradient(colors: [Color(red: 0.93, green: 0.52, blue: 0.76), Color(red: 0.98, green: 0.74, blue: 0.88)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .sunset:
            return LinearGradient(colors: [Color(red: 0.99, green: 0.58, blue: 0.28), Color(red: 0.93, green: 0.31, blue: 0.45)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    var displayName: String {
        switch self {
        case .midnight: return "Midnight"
        case .ocean: return "Ocean"
        case .blossom: return "Blossom"
        case .sunset: return "Sunset"
        }
    }

    var accentColor: Color {
        switch self {
        case .midnight:
            return Color(red: 0.58, green: 0.65, blue: 0.97)
        case .ocean:
            return Color(red: 0.47, green: 0.86, blue: 0.98)
        case .blossom:
            return Color(red: 0.99, green: 0.86, blue: 0.93)
        case .sunset:
            return Color(red: 1.0, green: 0.77, blue: 0.53)
        }
    }

    var backgroundColor: Color {
        switch self {
        case .midnight:
            return Color(red: 0.07, green: 0.08, blue: 0.14)
        case .ocean:
            return Color(red: 0.03, green: 0.18, blue: 0.27)
        case .blossom:
            return Color(red: 0.99, green: 0.95, blue: 0.98)
        case .sunset:
            return Color(red: 0.99, green: 0.92, blue: 0.86)
        }
    }

    var textColor: Color {
        switch self {
        case .midnight, .ocean:
            return .white
        case .blossom, .sunset:
            return .black
        }
    }
}
