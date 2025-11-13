import SwiftUI

struct OnboardingOverlay: View {
    @Binding var isPresented: Bool
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "sparkles")
                .font(.system(size: 44))
                .foregroundStyle(.yellow)
                .symbolEffect(.bounce, value: isPresented)

            VStack(spacing: 8) {
                Text("ברוכים הבאים ל-Interactive Groceries")
                    .font(.title2.bold())
                Text("הוסיפו פריטים, חלקו עם המשפחה והפכו את הקניות לנעימות יותר")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }

            Button {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isPresented = false
                }
            } label: {
                Text("קדימה, בואו נתחיל")
                    .font(.headline)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(appState.selectedTheme.accentColor))
                    .foregroundStyle(.white)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 20)
        )
        .padding()
    }
}
