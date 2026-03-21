import Foundation

enum OutputFormatter {

    // MARK: - Categories

    static func formatCategories(_ categories: [CategoryData], json: Bool) -> String {
        if json {
            return encodeCodableJSON(CategoriesOutput(categories: categories, count: categories.count))
        }

        var lines: [String] = ["Categories (\(categories.count)):"]
        for cat in categories.sorted(by: { $0.sortOrder < $1.sortOrder }) {
            lines.append("  \(cat.sortOrder). \(cat.emoji) [\(cat.id)] \(cat.displayName)")
        }
        return lines.joined(separator: "\n")
    }

    // MARK: - Ingredients

    static func formatIngredients(_ ingredients: [IngredientData], json: Bool) -> String {
        if json {
            return encodeCodableJSON(IngredientsOutput(ingredients: ingredients, count: ingredients.count))
        }

        // Group by category
        let grouped = Dictionary(grouping: ingredients, by: \.categoryId)
        let categoryOrder = DefaultCategories.all.map(\.id)
        let allCategoryIds = categoryOrder + grouped.keys.filter { !categoryOrder.contains($0) }.sorted()

        var lines: [String] = []
        for catId in allCategoryIds {
            guard let items = grouped[catId], !items.isEmpty else { continue }
            let catName = DefaultCategories.category(for: catId)?.displayName ?? catId
            lines.append("\(catName) (\(items.count)):")
            for ing in items {
                lines.append("  \(ing.emoji) \(ing.id.padding(toLength: 24, withPad: " ", startingAt: 0)) \(ing.label)")
            }
            lines.append("")
        }
        return lines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Prompts

    static func formatPrompts(_ prompts: [(purpose: PromptPurpose, body: String)], json: Bool) -> String {
        if json {
            let items = prompts.map { PromptOutput(purpose: $0.purpose.rawValue, name: $0.purpose.displayName, body: $0.body) }
            return encodeCodableJSON(PromptsOutput(prompts: items))
        }

        var lines: [String] = []
        for (purpose, body) in prompts {
            lines.append("=== \(purpose.displayName) ===")
            lines.append(body)
            lines.append("")
        }
        return lines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Build Prompt

    static func formatBuiltPrompt(
        systemPrompt: String,
        userPrompt: String,
        ingredients: [IngredientData],
        purpose: PromptPurpose,
        systemPromptSource: String,
        json: Bool
    ) -> String {
        if json {
            let metadata = BuildMetadata(
                ingredientCount: ingredients.count,
                purpose: purpose.rawValue,
                systemPromptSource: systemPromptSource,
                ingredientIds: ingredients.map(\.id)
            )
            let output = BuildPromptOutput(
                systemPrompt: systemPrompt,
                userPrompt: userPrompt,
                metadata: metadata,
                resolvedIngredients: ingredients
            )
            return encodeCodableJSON(output)
        }

        return """
        === SYSTEM PROMPT ===
        \(systemPrompt)

        === USER PROMPT ===
        \(userPrompt)

        === METADATA ===
        Ingredients: \(ingredients.count)
        Purpose: \(purpose.rawValue)
        System prompt source: \(systemPromptSource)
        IDs: \(ingredients.map(\.id).joined(separator: ", "))
        """
    }

    // MARK: - Validation

    static func formatValidation(
        valid: [IngredientData],
        invalid: [(id: String, suggestion: String?)],
        json: Bool
    ) -> String {
        if json {
            let validItems = valid.map { ValidItem(id: $0.id, label: $0.label, emoji: $0.emoji) }
            let invalidItems = invalid.map { InvalidItem(id: $0.id, suggestion: $0.suggestion) }
            return encodeCodableJSON(ValidationOutput(valid: validItems, invalid: invalidItems))
        }

        var lines: [String] = []
        if !valid.isEmpty {
            lines.append("Valid (\(valid.count)):")
            for ing in valid {
                lines.append("  \(ing.emoji) \(ing.id.padding(toLength: 24, withPad: " ", startingAt: 0)) \(ing.label)")
            }
        }
        if !invalid.isEmpty {
            if !lines.isEmpty { lines.append("") }
            lines.append("Invalid (\(invalid.count)):")
            for item in invalid {
                let suggestion = item.suggestion.map { " → Did you mean: \($0)?" } ?? ""
                lines.append("  \(item.id)\(suggestion)")
            }
        }
        return lines.joined(separator: "\n")
    }

    // MARK: - JSON Helpers

    private static func encodeCodableJSON<T: Encodable>(_ value: T) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(value) else { return "{}" }
        return String(data: data, encoding: .utf8) ?? "{}"
    }
}

// MARK: - Output Types

private struct CategoriesOutput: Encodable {
    let categories: [CategoryData]
    let count: Int
}

private struct IngredientsOutput: Encodable {
    let ingredients: [IngredientData]
    let count: Int
}

private struct PromptOutput: Encodable {
    let purpose: String
    let name: String
    let body: String
}

private struct PromptsOutput: Encodable {
    let prompts: [PromptOutput]
}

private struct BuildMetadata: Encodable {
    let ingredientCount: Int
    let purpose: String
    let systemPromptSource: String
    let ingredientIds: [String]
}

private struct BuildPromptOutput: Encodable {
    let systemPrompt: String
    let userPrompt: String
    let metadata: BuildMetadata
    let resolvedIngredients: [IngredientData]
}

private struct ValidItem: Encodable {
    let id: String
    let label: String
    let emoji: String
}

private struct InvalidItem: Encodable {
    let id: String
    let suggestion: String?
}

private struct ValidationOutput: Encodable {
    let valid: [ValidItem]
    let invalid: [InvalidItem]
}
