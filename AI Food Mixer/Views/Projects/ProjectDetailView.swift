import SwiftUI
import SwiftData

struct ProjectDetailView: View {
    let project: Project
    var onRemix: (([IngredientData]) -> Void)?

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet = false
    @State private var showDeleteConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Ingredient summary
                ingredientSection

                // Saved image
                if let image = project.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                }

                Divider()

                // Concept content
                Text(AttributedString(fullMarkdown: project.generatedConcept))
                    .font(.body)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle(project.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    showShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .accessibilityLabel("Share")

                if let onRemix {
                    Button {
                        onRemix(project.ingredients)
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
                    .accessibilityLabel("Remix")
                }

                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
                .accessibilityLabel("Delete")
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = ExportService.markdownFileURL(
                title: project.title,
                content: project.generatedConcept
            ) {
                ShareSheetView(activityItems: [url])
            }
        }
        .alert("Delete Creation", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                modelContext.delete(project)
                try? modelContext.save()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete \"\(project.title)\"? This cannot be undone.")
        }
    }

    // MARK: - Ingredient Section

    private var ingredientSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            FlowLayout(spacing: 8) {
                ForEach(project.ingredients) { ingredient in
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
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: ProposedViewSize(result.sizes[index])
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> ArrangementResult {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var sizes: [CGSize] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            sizes.append(size)
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return ArrangementResult(
            positions: positions,
            sizes: sizes,
            size: CGSize(width: maxWidth, height: y + rowHeight)
        )
    }

    private struct ArrangementResult {
        let positions: [CGPoint]
        let sizes: [CGSize]
        let size: CGSize
    }
}
