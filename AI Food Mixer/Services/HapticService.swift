#if os(iOS)
import UIKit
#endif

enum HapticService {
    #if os(iOS)
    static func selection() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    static func mixStart() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    static func mixComplete() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    static func remove() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred(intensity: 0.5)
    }
    #else
    static func selection() {}
    static func mixStart() {}
    static func mixComplete() {}
    static func error() {}
    static func remove() {}
    #endif
}
