import SwiftUI
import UIKit

struct ShareSheetView: UIViewControllerRepresentable {
    let activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Required on iPad: the activity controller is presented in a popover,
        // which needs a source view that lives in the window hierarchy. Anchor it
        // to the controller's own (now attached) view, centered with no arrow, so
        // the popover has a defined source point instead of a detached UIView.
        guard let popover = uiViewController.popoverPresentationController else { return }
        popover.permittedArrowDirections = []
        popover.sourceView = uiViewController.view
        popover.sourceRect = CGRect(
            x: uiViewController.view.bounds.midX,
            y: uiViewController.view.bounds.midY,
            width: 0,
            height: 0
        )
    }
}
