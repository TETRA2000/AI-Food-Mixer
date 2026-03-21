import Foundation

extension String {
    /// Extracts the first Markdown heading (# Title) from the string.
    var markdownTitle: String? {
        let lines = components(separatedBy: .newlines)
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("# ") {
                return String(trimmed.dropFirst(2)).trimmingCharacters(in: .whitespaces)
            }
        }
        return nil
    }

    /// Extracts a short concept description suitable for Image Playground.
    /// Combines the title with the first concept sentence.
    var imagePlaygroundConcept: String {
        let title = markdownTitle ?? "Creative food concept"
        let lines = components(separatedBy: .newlines)
        var foundConcept = false
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.lowercased().hasPrefix("## concept") {
                foundConcept = true
                continue
            }
            if foundConcept && !trimmed.isEmpty && !trimmed.hasPrefix("#") {
                let clean = trimmed
                    .replacingOccurrences(of: "**", with: "")
                    .replacingOccurrences(of: "*", with: "")
                return "\(title): \(clean)"
            }
        }
        return title
    }
}
