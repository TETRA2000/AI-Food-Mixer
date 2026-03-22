import SwiftUI

/// Renders markdown text as separate blocks so headings, paragraphs,
/// and lists display with proper spacing instead of collapsing into one run.
struct MarkdownBlocksView: View {
    let markdown: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(blocks.enumerated()), id: \.offset) { _, block in
                block.view
            }
        }
    }

    private var blocks: [MarkdownBlock] {
        markdown
            .components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .map { MarkdownBlock(text: $0) }
    }
}

private struct MarkdownBlock {
    let text: String

    @ViewBuilder
    var view: some View {
        if text.hasPrefix("# ") {
            Text(AttributedString(markdown: String(text.dropFirst(2))))
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else if text.hasPrefix("## ") {
            Text(AttributedString(markdown: String(text.dropFirst(3))))
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else if text.hasPrefix("### ") {
            Text(AttributedString(markdown: String(text.dropFirst(4))))
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else if text.hasPrefix("---") {
            Divider()
        } else if text.contains("\n- ") || text.hasPrefix("- ") {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(text.components(separatedBy: "\n").enumerated()), id: \.offset) { _, line in
                    let trimmed = line.trimmingCharacters(in: .whitespaces)
                    if trimmed.hasPrefix("- ") {
                        Text(AttributedString(markdown: String(trimmed.dropFirst(2))))
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 12)
                    } else if !trimmed.isEmpty {
                        Text(AttributedString(markdown: trimmed))
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        } else {
            Text(AttributedString(markdown: text))
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct MarkdownView: View {
    let markdown: String

    var body: some View {
        ScrollView {
            MarkdownBlocksView(markdown: markdown)
                .textSelection(.enabled)
                .padding()
        }
    }
}

#Preview {
    MarkdownView(markdown: """
    # Curry Lava Pizza Cake

    ## Concept

    A three-layered savory-sweet masterpiece.

    ## Structure

    - Layer 1: Pizza crust base
    - Layer 2: Curry lava filling
    - Layer 3: Savory cake crown

    ## Flavor Profile

    Bold fusion of Italian comfort and Japanese warmth.
    """)
}
