import Foundation
import SwiftData
import SwiftUI

@Observable
final class MixViewModel {
    var selectedIngredients: [IngredientData] = []
    var isShowingGeneration = false
    var projectTitle = ""

    let generationService = FoodGenerationService()

    // MARK: - Category & Ingredient Access

    func allCategories(customCategories: [CustomCategory]) -> [CategoryData] {
        let defaults = DefaultCategories.all
        let custom = customCategories.map { CategoryData(from: $0) }
        return (defaults + custom).sorted { $0.sortOrder < $1.sortOrder }
    }

    func ingredients(for categoryId: String, customIngredients: [CustomIngredient]) -> [IngredientData] {
        let defaults = DefaultIngredients.ingredients(for: categoryId)
        let custom = customIngredients
            .filter { $0.categoryId == categoryId }
            .map { IngredientData(from: $0) }
        return defaults + custom
    }

    // MARK: - Selection

    func toggleIngredient(_ ingredient: IngredientData) {
        if let index = selectedIngredients.firstIndex(where: { $0.id == ingredient.id }) {
            selectedIngredients.remove(at: index)
            HapticService.remove()
        } else {
            selectedIngredients.append(ingredient)
            HapticService.selection()
        }
    }

    func isSelected(_ ingredient: IngredientData) -> Bool {
        selectedIngredients.contains { $0.id == ingredient.id }
    }

    var selectedCount: Int {
        selectedIngredients.count
    }

    func clearSelection() {
        selectedIngredients.removeAll()
    }

    // MARK: - Generation

    func mix(systemPrompt: String) async {
        HapticService.mixStart()
        await generationService.generate(
            ingredients: selectedIngredients,
            systemPrompt: systemPrompt
        )
        if generationService.error == nil {
            HapticService.mixComplete()
        } else {
            HapticService.error()
        }
    }

    // MARK: - Save Project

    func saveProject(modelContext: ModelContext, imageData: Data? = nil) {
        let title = projectTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalTitle = title.isEmpty ? generatedTitle : title

        let project = Project(
            title: finalTitle,
            ingredients: selectedIngredients,
            systemPromptBody: DefaultSystemPrompts.generationPromptBody,
            generatedConcept: generationService.streamedText,
            imageData: imageData
        )
        modelContext.insert(project)
        try? modelContext.save()
    }

    private var generatedTitle: String {
        let labels = selectedIngredients.prefix(3).map(\.label)
        if labels.isEmpty { return "Untitled Creation" }
        return labels.joined(separator: " + ")
    }

    // MARK: - Surprise Me

    func surpriseMe(customCategories: [CustomCategory], customIngredients: [CustomIngredient]) {
        clearSelection()
        let categories = allCategories(customCategories: customCategories)
        for category in categories {
            let available = ingredients(for: category.id, customIngredients: customIngredients)
            if let random = available.randomElement() {
                selectedIngredients.append(random)
            }
        }
        HapticService.selection()
    }

    // MARK: - Remix

    func loadIngredients(_ ingredients: [IngredientData]) {
        selectedIngredients = ingredients
    }
}
