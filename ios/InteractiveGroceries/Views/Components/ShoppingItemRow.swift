import SwiftUI

struct ShoppingItemRow: View {
    let item: ShoppingItem
    var onToggle: () -> Void
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                CheckmarkView(isCompleted: item.isCompleted)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(item.name)
                            .font(.system(.headline, design: .rounded))
                        Spacer()
                        PriorityBadge(priority: item.priority)
                    }

                    if !item.quantity.isEmpty {
                        Text(item.quantity)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)
                    }

                    if !item.notes.isEmpty {
                        Text(item.notes)
                            .font(.system(.footnote, design: .rounded))
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }

                    HStack(spacing: 12) {
                        Label(item.category.rawValue, systemImage: "tag")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)

                        Label(item.dateAdded.formatted(.dateTime.day().month().hour().minute()), systemImage: "clock")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(appState.selectedTheme.accentColor.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: appState.selectedTheme.accentColor.opacity(0.25), radius: 16, x: 0, y: 10)
            )
        }
        .buttonStyle(.plain)
    }
}
