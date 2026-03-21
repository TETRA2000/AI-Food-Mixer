import SwiftUI

struct CategoryRow: View {
    let category: CategoryData
    let ingredients: [IngredientData]
    let selectedIngredients: [IngredientData]
    let onToggle: (IngredientData) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category header
            HStack(spacing: 8) {
                Text(category.emoji)
                    .font(.title2)
                Text(category.displayName)
                    .font(.headline)
                    .foregroundStyle(.primary)

                let selectedInCategory = selectedIngredients.filter { $0.categoryId == category.id }.count
                if selectedInCategory > 0 {
                    Text("\(selectedInCategory)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color(hex: category.colorHex)))
                }
            }
            .padding(.horizontal)

            // Horizontal scroll of cards
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(ingredients) { ingredient in
                        IngredientCard(
                            ingredient: ingredient,
                            isSelected: selectedIngredients.contains { $0.id == ingredient.id },
                            onTap: { onToggle(ingredient) }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    CategoryRow(
        category: DefaultCategories.all[0],
        ingredients: DefaultIngredients.fruits,
        selectedIngredients: [DefaultIngredients.fruits[0]],
        onToggle: { _ in }
    )
}
