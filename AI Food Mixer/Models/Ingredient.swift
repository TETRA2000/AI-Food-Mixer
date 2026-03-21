import Foundation
import SwiftData

// MARK: - IngredientData (Value Type)

/// A value type representing a single ingredient card.
/// Used for both built-in defaults and within projects (stored as JSON).
struct IngredientData: Codable, Identifiable, Hashable {
    let id: String
    var emoji: String
    var label: String
    var categoryId: String
    var colorHex: String
    var isCustom: Bool

    init(
        id: String = UUID().uuidString,
        emoji: String,
        label: String,
        categoryId: String,
        colorHex: String,
        isCustom: Bool = false
    ) {
        self.id = id
        self.emoji = emoji
        self.label = label
        self.categoryId = categoryId
        self.colorHex = colorHex
        self.isCustom = isCustom
    }

    init(from custom: CustomIngredient) {
        self.id = custom.ingredientId
        self.emoji = custom.emoji
        self.label = custom.label
        self.categoryId = custom.categoryId
        self.colorHex = custom.colorHex
        self.isCustom = true
    }
}

// MARK: - CustomIngredient (SwiftData Model)

/// Persisted model for user-created ingredients.
@Model
final class CustomIngredient {
    var ingredientId: String
    var emoji: String
    var label: String
    var categoryId: String
    var colorHex: String

    init(
        ingredientId: String = UUID().uuidString,
        emoji: String,
        label: String,
        categoryId: String,
        colorHex: String
    ) {
        self.ingredientId = ingredientId
        self.emoji = emoji
        self.label = label
        self.categoryId = categoryId
        self.colorHex = colorHex
    }
}
