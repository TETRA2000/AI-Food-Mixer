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

struct ShareSheetView: NSViewRepresentable {
    let activityItems: [Any]

    func makeNSView(context: Context) -> NSView {
        NSView()
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        // Present the sharing picker when the view appears
        DispatchQueue.main.async {
            guard let window = nsView.window else { return }
            let picker = NSSharingServicePicker(items: activityItems)
            picker.show(relativeTo: nsView.bounds, of: nsView, preferredEdge: .minY)
        }
    }
}
#endif
