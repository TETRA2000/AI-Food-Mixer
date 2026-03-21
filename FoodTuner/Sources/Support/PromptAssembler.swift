import Foundation

enum PromptAssembler {

    /// Build the user prompt from selected ingredients.
    /// Matches the logic in FoodGenerationService.generate(ingredients:systemPrompt:).
    static func buildUserPrompt(from ingredients: [IngredientData]) -> String {
        let ingredientList = ingredients
            .map { "- \($0.emoji) \($0.label) (\($0.categoryId))" }
            .joined(separator: "\n")

        return """
        Selected ingredients:
        \(ingredientList)

        Create a creative food concept that combines these ingredients into one dish.
        """
    }

    /// Return the default system prompt body for a given purpose.
    static func systemPrompt(for purpose: PromptPurpose) -> String {
        switch purpose {
        case .generation: DefaultSystemPrompts.generationPromptBody
        }
    }

    /// Resolve ingredient IDs to IngredientData, splitting into valid and invalid.
    static func resolveIngredients(
        ids: [String],
        allIngredients: [IngredientData]
    ) -> (valid: [IngredientData], invalid: [String]) {
        let lookup = Dictionary(uniqueKeysWithValues: allIngredients.map { ($0.id, $0) })
        var valid: [IngredientData] = []
        var invalid: [String] = []
        for id in ids {
            if let ingredient = lookup[id] {
                valid.append(ingredient)
            } else {
                invalid.append(id)
            }
        }
        return (valid, invalid)
    }

    /// Suggest the closest valid ID for an invalid one.
    static func suggestId(for invalid: String, from allIngredients: [IngredientData]) -> String? {
        let allIds = allIngredients.map(\.id)
        let lowered = invalid.lowercased()

        // Prefix match
        if let match = allIds.first(where: { $0.lowercased().hasPrefix(lowered) }) {
            return match
        }

        // Contains match
        if let match = allIds.first(where: { $0.lowercased().contains(lowered) }) {
            return match
        }

        // Suffix match on the part after underscore
        let parts = lowered.split(separator: "_")
        if let lastPart = parts.last {
            if let match = allIds.first(where: { $0.lowercased().contains(String(lastPart)) }) {
                return match
            }
        }

        return nil
    }
}
