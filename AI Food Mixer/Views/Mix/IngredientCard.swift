import SwiftUI

struct IngredientCard: View {
    let ingredient: IngredientData
    let isSelected: Bool
    let onTap: () -> Void

    @State private var isPressed = false

    private let cardWidth: CGFloat = 100
    private let cardHeight: CGFloat = 120

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text(ingredient.emoji)
                    .font(.system(size: 36))

                Text(ingredient.label)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: cardWidth, height: cardHeight)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ingredient.cardGradient)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 3)
            )
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .background(
                            Circle()
                                .fill(Color.green)
                                .frame(width: 22, height: 22)
                        )
                        .offset(x: 6, y: -6)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .shadow(
                color: isSelected ? Color(hex: ingredient.colorHex).opacity(0.5) : Color.black.opacity(0.15),
                radius: isSelected ? 8 : 4,
                y: isSelected ? 4 : 2
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .drawingGroup()
            .animation(.spring(duration: 0.3), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(ingredient.label)")
        .accessibilityHint(isSelected ? "Selected. Double-tap to remove." : "Double-tap to add.")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    HStack(spacing: 16) {
        IngredientCard(
            ingredient: IngredientData(
                emoji: "🍕",
                label: "Pizza",
                categoryId: "preparedDishes",
                colorHex: "#FF922B"
            ),
            isSelected: false,
            onTap: {}
        )
        IngredientCard(
            ingredient: IngredientData(
                emoji: "🍓",
                label: "Strawberry",
                categoryId: "fruits",
                colorHex: "#FF6B6B"
            ),
            isSelected: true,
            onTap: {}
        )
    }
    .padding()
}
