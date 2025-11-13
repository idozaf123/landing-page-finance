import SwiftUI

struct CheckmarkView: View {
    let isCompleted: Bool
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack {
            Circle()
                .fill(isCompleted ? appState.selectedTheme.accentColor : Color.gray.opacity(0.2))
                .frame(width: 32, height: 32)

            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCompleted)
    }
}
