import Foundation

extension AttributedString {
    /// Create an AttributedString from Markdown, falling back to plain text on failure.
    init(markdown: String) {
        do {
            self = try AttributedString(
                markdown: markdown,
                options: AttributedString.MarkdownParsingOptions(
                    interpretedSyntax: .inlineOnlyPreservingWhitespace
                )
            )
        } catch {
            self = AttributedString(markdown)
        }
    }

    /// Create an AttributedString with full Markdown parsing (headings, lists, etc.).
    init(fullMarkdown: String) {
        do {
            self = try AttributedString(
                markdown: fullMarkdown,
                options: AttributedString.MarkdownParsingOptions(
                    interpretedSyntax: .full
                )
            )
        } catch {
            self = AttributedString(fullMarkdown)
        }
    }
}
