import SwiftUI

final class AppState: ObservableObject {
    @Published var selectedTheme: Theme {
        didSet { selectedThemeRawValue = selectedTheme.rawValue }
    }
    @Published var selectedTab: RootView.Tab = .list
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @AppStorage("selectedTheme") private var selectedThemeRawValue = Theme.sunset.rawValue

    init() {
        selectedTheme = Theme(rawValue: selectedThemeRawValue) ?? .sunset
    }

    var shouldShowOnboarding: Bool {
        get { isFirstLaunch }
        set { isFirstLaunch = newValue }
    }
}
