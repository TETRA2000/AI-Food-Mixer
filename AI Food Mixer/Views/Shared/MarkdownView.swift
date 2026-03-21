import SwiftUI

struct MarkdownView: View {
    let markdown: String

    var body: some View {
        ScrollView {
            Text(AttributedString(fullMarkdown: markdown))
                .font(.body)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
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
