import Foundation
import SwiftData

// MARK: - CategoryData (Value Type)

/// A value type representing an ingredient category.
/// Used everywhere in the app — both for built-in defaults and user-created categories.
struct CategoryData: Codable, Identifiable, Hashable {
    let id: String
    var displayName: String
    var emoji: String
    var colorHex: String
    var secondaryColorHex: String
    var sortOrder: Int
    var isDefault: Bool

    init(
        id: String,
        displayName: String,
        emoji: String,
        colorHex: String,
        secondaryColorHex: String,
        sortOrder: Int,
        isDefault: Bool = true
    ) {
        self.id = id
        self.displayName = displayName
        self.emoji = emoji
        self.colorHex = colorHex
        self.secondaryColorHex = secondaryColorHex
        self.sortOrder = sortOrder
        self.isDefault = isDefault
    }

    init(from custom: CustomCategory) {
        self.id = custom.categoryId
        self.displayName = custom.displayName
        self.emoji = custom.emoji
        self.colorHex = custom.colorHex
        self.secondaryColorHex = custom.secondaryColorHex
        self.sortOrder = custom.sortOrder
        self.isDefault = false
    }
}

// MARK: - CustomCategory (SwiftData Model)

/// Persisted model for user-created ingredient categories.
@Model
final class CustomCategory {
    var categoryId: String
    var displayName: String
    var emoji: String
    var colorHex: String
    var secondaryColorHex: String
    var sortOrder: Int

    init(
        categoryId: String = UUID().uuidString,
        displayName: String,
        emoji: String,
        colorHex: String,
        secondaryColorHex: String,
        sortOrder: Int
    ) {
        self.categoryId = categoryId
        self.displayName = displayName
        self.emoji = emoji
        self.colorHex = colorHex
        self.secondaryColorHex = secondaryColorHex
        self.sortOrder = sortOrder
    }
}
