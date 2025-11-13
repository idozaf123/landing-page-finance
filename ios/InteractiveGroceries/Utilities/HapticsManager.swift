import CoreHaptics
import UIKit

enum HapticsManager {
    static func playSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    static func playImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
