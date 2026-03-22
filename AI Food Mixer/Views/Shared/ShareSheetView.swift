import SwiftUI

#if os(iOS)
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

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#elseif os(macOS)
import AppKit

/// A hidden helper view that presents `NSSharingServicePicker` from the hosting window
/// when `isPresented` becomes true. Place this in a `.background` modifier.
struct MacShareButton: NSViewRepresentable {
    @Binding var isPresented: Bool
    let items: [Any]

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.setFrameSize(NSSize(width: 1, height: 1))
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        guard isPresented else { return }

        DispatchQueue.main.async {
            guard let window = nsView.window,
                  let contentView = window.contentView else {
                isPresented = false
                return
            }

            let picker = NSSharingServicePicker(items: items)
            // Show the picker anchored near the top-right of the window (toolbar area)
            let anchorRect = CGRect(
                x: contentView.bounds.maxX - 50,
                y: contentView.bounds.maxY - 10,
                width: 1,
                height: 1
            )
            picker.show(relativeTo: anchorRect, of: contentView, preferredEdge: .minY)
            isPresented = false
        }
    }
}
#endif
