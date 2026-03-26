import SwiftUI
import UIKit

struct ShareSheetView: UIViewControllerRepresentable {
    let activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )

        // Required on iPad: configure popover presentation to avoid crash
        if let popover = controller.popoverPresentationController {
            popover.permittedArrowDirections = .any
            // Use a centered sourceRect as fallback; the presenting sheet
            // provides the context, so this just satisfies the iPad requirement.
            popover.sourceView = UIView()
            popover.sourceRect = .zero
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
