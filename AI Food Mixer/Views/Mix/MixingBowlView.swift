import SwiftUI

struct MixingBowlView: View {
    let ingredients: [IngredientData]
    let onRemove: (IngredientData) -> Void
    let onClear: () -> Void

    @State private var isExpanded = false

    var body: some View {
        if !ingredients.isEmpty {
            VStack(spacing: 0) {
                // Toggle header
                Button {
                    withAnimation(.spring(duration: 0.4)) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack {
                        Text("🥘")
                            .font(.title2)
                        Text("Mixing Bowl")
                            .font(.headline)
                        Spacer()
                        Text("\(ingredients.count)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(Color.accentColor))
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.up")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Mixing Bowl, \(ingredients.count) ingredient\(ingredients.count == 1 ? "" : "s")")
                .accessibilityHint(isExpanded ? "Double-tap to collapse" : "Double-tap to expand")

                // Expanded content
                if isExpanded {
                    VStack(spacing: 12) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(ingredients) { ingredient in
                                    IngredientChip(ingredient: ingredient) {
                                        onRemove(ingredient)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }

                        Button("Clear All", role: .destructive) {
                            onClear()
                        }
                        .font(.caption)
                        .padding(.bottom, 8)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 10, y: -2)
            )
            .padding(.horizontal)
        }
    }
}

// MARK: - Ingredient Chip

struct IngredientChip: View {
    let ingredient: IngredientData
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(ingredient.emoji)
                .font(.caption)
            Text(ingredient.label)
                .font(.caption2)
                .fontWeight(.medium)
                .lineLimit(1)
            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .accessibilityLabel("Remove \(ingredient.label)")
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color(hex: ingredient.colorHex).opacity(0.2))
        )
        .overlay(
            Capsule()
                .stroke(Color(hex: ingredient.colorHex).opacity(0.4), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(ingredient.emoji) \(ingredient.label)")
    }
}

#Preview {
    VStack {
        Spacer()
        MixingBowlView(
            ingredients: Array(DefaultIngredients.fruits.prefix(3)),
            onRemove: { _ in },
            onClear: {}
        )
    }
}
