import Foundation

enum ExportService {
    /// Write the concept markdown to a temporary file and return its URL.
    static func markdownFileURL(title: String, content: String) -> URL? {
        let fileName = sanitizeFileName(title) + ".md"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch {
            return nil
        }
    }

    /// Write the concept as plain text to a temporary file and return its URL.
    static func plainTextFileURL(title: String, content: String) -> URL? {
        let plainText = stripMarkdown(content)
        let fileName = sanitizeFileName(title) + ".txt"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try plainText.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch {
            return nil
        }
    }

    /// Export ingredient set as JSON.
    static func ingredientsJSON(_ ingredients: [IngredientData]) -> URL? {
        let exportData = IngredientExport(
            formatVersion: 1,
            ingredients: ingredients
        )
        let fileName = "ingredients_\(Date().timeIntervalSince1970).json"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            let data = try JSONEncoder().encode(exportData)
            try data.write(to: url)
            return url
        } catch {
            return nil
        }
    }

    // MARK: - Helpers

    private static func sanitizeFileName(_ name: String) -> String {
        let allowed = CharacterSet.alphanumerics.union(.whitespaces)
        let sanitized = name.unicodeScalars.filter { allowed.contains($0) }
        let result = String(String.UnicodeScalarView(sanitized))
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: " ", with: "_")
        return result.isEmpty ? "FoodConcept" : result
    }

    private static func stripMarkdown(_ text: String) -> String {
        var result = text
        // Remove headings
        result = result.replacingOccurrences(of: "#{1,6}\\s*", with: "", options: .regularExpression)
        // Remove bold/italic
        result = result.replacingOccurrences(of: "\\*{1,3}([^*]+)\\*{1,3}", with: "$1", options: .regularExpression)
        // Remove links
        result = result.replacingOccurrences(of: "\\[([^\\]]+)\\]\\([^)]+\\)", with: "$1", options: .regularExpression)
        // Remove code blocks
        result = result.replacingOccurrences(of: "`{1,3}[^`]*`{1,3}", with: "", options: .regularExpression)
        return result
    }
}

// MARK: - Export Format

struct IngredientExport: Codable {
    let formatVersion: Int
    let ingredients: [IngredientData]
}
