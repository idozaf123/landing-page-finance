import SwiftUI

struct RootView: View {
    enum Tab: Hashable {
        case list
        case insights
        case settings
    }

    @StateObject private var viewModel = ShoppingListViewModel()
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack {
                ShoppingListView(viewModel: viewModel)
            }
            .tabItem {
                Label("רשימה", systemImage: "checklist")
            }
            .tag(Tab.list)

            NavigationStack {
                InsightsView(viewModel: viewModel)
            }
            .tabItem {
                Label("תובנות", systemImage: "chart.bar.fill")
            }
            .tag(Tab.insights)

            NavigationStack {
                SettingsView(viewModel: viewModel)
            }
            .tabItem {
                Label("הגדרות", systemImage: "slider.horizontal.3")
            }
            .tag(Tab.settings)
        }
        .tint(appState.selectedTheme.accentColor)
        .overlay(alignment: .top) {
            if appState.shouldShowOnboarding {
                OnboardingOverlay(isPresented: $appState.shouldShowOnboarding)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}
