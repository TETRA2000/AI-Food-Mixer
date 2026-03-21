import SwiftUI

struct DiscoverDetailView: View {
    let item: DiscoverItem
    var onRemix: (([IngredientData]) -> Void)?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Ingredient breakdown
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    FlowLayout(spacing: 8) {
                        ForEach(item.ingredients) { ingredient in
                            HStack(spacing: 4) {
                                Text(ingredient.emoji)
                                    .font(.caption)
                                Text(ingredient.label)
                                    .font(.caption2)
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color(hex: ingredient.colorHex).opacity(0.15))
                            )
                        }
                    }
                }

                if let onRemix {
                    Button {
                        onRemix(item.ingredients)
                    } label: {
                        Label("Try This Mix", systemImage: "arrow.triangle.2.circlepath")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(LinearGradient(
                                        colors: [Color(hex: "#FF922B"), Color(hex: "#E03131")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                            )
                    }
                }

                Divider()

                // Concept preview
                Text(AttributedString(fullMarkdown: item.conceptPreview))
                    .font(.body)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
