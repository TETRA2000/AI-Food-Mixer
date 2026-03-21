import SwiftUI

extension CategoryData {
    var gradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: colorHex), Color(hex: secondaryColorHex)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension IngredientData {
    var cardGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: colorHex),
                Color(hex: colorHex).opacity(0.7),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
