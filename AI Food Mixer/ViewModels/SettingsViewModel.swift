import Foundation
import SwiftData

@Observable
final class SettingsViewModel {

    // MARK: - Custom Category Management

    func addCategory(
        displayName: String,
        emoji: String,
        colorHex: String,
        secondaryColorHex: String,
        modelContext: ModelContext
    ) {
        let descriptor = FetchDescriptor<CustomCategory>()
        let existing = (try? modelContext.fetch(descriptor)) ?? []
        let maxSort = existing.map(\.sortOrder).max() ?? 9

        let category = CustomCategory(
            displayName: displayName,
            emoji: emoji,
            colorHex: colorHex,
            secondaryColorHex: secondaryColorHex,
            sortOrder: maxSort + 1
        )
        modelContext.insert(category)
        try? modelContext.save()
    }

    func deleteCategory(_ category: CustomCategory, modelContext: ModelContext) {
        // Also delete all custom ingredients in this category
        let categoryId = category.categoryId
        let descriptor = FetchDescriptor<CustomIngredient>(
            predicate: #Predicate { $0.categoryId == categoryId }
        )
        if let ingredients = try? modelContext.fetch(descriptor) {
            for ingredient in ingredients {
                modelContext.delete(ingredient)
            }
        }
        modelContext.delete(category)
        try? modelContext.save()
    }

    // MARK: - Custom Ingredient Management

    func addIngredient(
        emoji: String,
        label: String,
        categoryId: String,
        colorHex: String,
        modelContext: ModelContext
    ) {
        let ingredient = CustomIngredient(
            emoji: emoji,
            label: label,
            categoryId: categoryId,
            colorHex: colorHex
        )
        modelContext.insert(ingredient)
        try? modelContext.save()
    }

    func deleteIngredient(_ ingredient: CustomIngredient, modelContext: ModelContext) {
        modelContext.delete(ingredient)
        try? modelContext.save()
    }
}
