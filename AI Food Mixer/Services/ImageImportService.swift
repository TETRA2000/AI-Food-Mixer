import UIKit

/// Loads images produced by the Image Playground sheet from the file URL it
/// hands back, converting them into a `UIImage` plus JPEG-encoded `Data` ready
/// to display and persist with a `Project`.
enum ImageImportService {
    /// Reads the image at `url` and returns it alongside JPEG-encoded data,
    /// or `nil` if the file can't be read or isn't a valid image.
    static func loadImage(from url: URL, compressionQuality: CGFloat = 0.8) -> (image: UIImage, data: Data)? {
        guard let fileData = try? Data(contentsOf: url),
              let image = UIImage(data: fileData),
              let jpeg = image.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        return (image, jpeg)
    }
}
