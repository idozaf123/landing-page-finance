import SwiftUI

struct InsightsView: View {
    @ObservedObject var viewModel: ShoppingListViewModel
    @EnvironmentObject private var appState: AppState

    private var totalItems: Int {
        viewModel.items.count + viewModel.archivedItems.count
    }

    private var completionRate: Double {
        guard totalItems > 0 else { return 0 }
        return Double(viewModel.archivedItems.count) / Double(totalItems)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                overviewCard
                categoriesGrid
                historyHighlights
            }
            .padding()
        }
        .background(LinearGradient(colors: [appState.selectedTheme.backgroundColor.opacity(0.35), Color(.systemGroupedBackground)], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        .navigationTitle("תובנות")
    }

    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("סיכום מהיר")
                .font(.title2.bold())

            VStack(alignment: .leading, spacing: 12) {
                ProgressView(value: completionRate) {
                    Text("התקדמות רשימת הקניות")
                        .font(.headline)
                } currentValueLabel: {
                    Text("\(Int(completionRate * 100))%")
                        .font(.title3.bold())
                }
                .tint(.green)

                HStack {
                    InsightMetric(title: "פעילים", value: "\(viewModel.filteredItems().count)", systemImage: "cart")
                    Spacer()
                    InsightMetric(title: "הושלמו", value: "\(viewModel.archivedItems.count)", systemImage: "checkmark.circle")
                    Spacer()
                    InsightMetric(title: "סה\"כ", value: "\(totalItems)", systemImage: "list.number")
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 12)
        )
    }

    private var categoriesGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("חלוקה לפי קטגוריות")
                .font(.title3.bold())

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 16)], spacing: 16) {
                ForEach(ShoppingItem.Category.allCases) { category in
                    let activeCount = viewModel.items.filter { $0.category == category && !$0.isCompleted }.count
                    let completedCount = viewModel.archivedItems.filter { $0.category == category }.count
                    CategoryInsightCard(category: category, activeCount: activeCount, completedCount: completedCount)
                }
            }
        }
    }

    private var historyHighlights: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("היסטוריה אחרונה")
                .font(.title3.bold())

            if viewModel.archivedItems.isEmpty {
                Text("עדיין אין פריטים שסומנו כבוצעו")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.archivedItems.prefix(5)) { item in
                    HistoryRow(item: item)
                }
            }
        }
    }
}

private struct InsightMetric: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: systemImage)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.bold())
        }
    }
}

private struct CategoryInsightCard: View {
    let category: ShoppingItem.Category
    let activeCount: Int
    let completedCount: Int

    private var total: Int { activeCount + completedCount }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(category.emoji)
                Text(category.rawValue)
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("פעילים: \(activeCount)")
                Text("בוצעו: \(completedCount)")
                Text("סה\"כ: \(total)")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
}

private struct HistoryRow: View {
    let item: ShoppingItem

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
                    .font(.headline)
                if let date = item.dateCompleted {
                    Text(date.formatted(.dateTime.day().month().hour().minute()))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Text(item.category.emoji)
                .font(.title3)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.regularMaterial)
        )
    }
}
