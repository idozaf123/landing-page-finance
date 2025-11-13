import SwiftUI

struct PriorityBadge: View {
    let priority: ShoppingItem.Priority

    var body: some View {
        Text(priority.title)
            .font(.system(.caption, design: .rounded, weight: .semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(priorityColor.opacity(0.15))
            .foregroundStyle(priorityColor)
            .clipShape(Capsule())
    }

    private var priorityColor: Color {
        switch priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
}
