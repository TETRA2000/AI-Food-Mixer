import Foundation
import SwiftData

@Observable
final class SettingsViewModel {

    // MARK: - System Prompt Management

    func seedDefaultPrompts(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<SystemPrompt>(
            predicate: #Predicate { $0.isDefault == true }
        )
        let existing = (try? modelContext.fetch(descriptor)) ?? []
        if existing.isEmpty {
            for purpose in PromptPurpose.allCases {
                let prompt = DefaultSystemPrompts.makeDefault(purpose: purpose)
                modelContext.insert(prompt)
            }
            try? modelContext.save()
        }
    }

    func activeGenerationPrompt(modelContext: ModelContext) -> String {
        let descriptor = FetchDescriptor<SystemPrompt>(
            predicate: #Predicate { $0.purposeRaw == "generation" }
        )
        let prompts = (try? modelContext.fetch(descriptor)) ?? []
        return prompts.first?.body ?? DefaultSystemPrompts.generationPromptBody
    }

    func deletePrompt(_ prompt: SystemPrompt, modelContext: ModelContext) {
        modelContext.delete(prompt)
        try? modelContext.save()
    }

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
