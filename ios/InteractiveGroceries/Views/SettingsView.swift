import SwiftUI
import UIKit

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: ShoppingListViewModel
    @State private var showClearHistoryConfirmation = false

    var body: some View {
        Form {
            Section(header: Text("התאמה אישית")) {
                Picker("ערכת צבע", selection: $appState.selectedTheme) {
                    ForEach(Theme.allCases) { theme in
                        HStack {
                            Circle().fill(theme.accentColor).frame(width: 12, height: 12)
                            Text(theme.displayName)
                        }
                        .tag(theme)
                    }
                }
            }

            Section(header: Text("ניהול רשימה")) {
                Button("ייצוא נתונים") {
                    exportData()
                }
                ShareLink(item: sharePayload, preview: SharePreview("שיתוף רשימת קניות", image: Image(systemName: "cart.fill"))) {
                    Label("שתף רשימה", systemImage: "square.and.arrow.up")
                }
                Button("נקה היסטוריה") {
                    showClearHistoryConfirmation = true
                }
                .foregroundColor(.red)
            }

            Section(header: Text("אודות")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Interactive Groceries")
                        .font(.headline)
                    Text("האפליקציה החכמה לניהול קניות לבית")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("הגדרות")
        .confirmationDialog("ניקוי היסטוריה", isPresented: $showClearHistoryConfirmation) {
            Button("מחק", role: .destructive) {
                viewModel.clearHistory()
            }
            Button("בטל", role: .cancel) {}
        } message: {
            Text("האם אתם בטוחים שברצונכם למחוק את כל ההיסטוריה?")
        }
    }

    private func exportData() {
        UIPasteboard.general.string = sharePayload
    }

    private var sharePayload: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        let allItems = viewModel.items + viewModel.archivedItems
        guard let data = try? encoder.encode(allItems), let string = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        return string
    }
}
