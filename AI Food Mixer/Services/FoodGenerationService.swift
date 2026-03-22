import Foundation
import SwiftUI

#if canImport(FoundationModels)
import FoundationModels
#endif

@Observable
final class FoodGenerationService {
    var isGenerating = false
    var streamedText = ""
    var error: String?

    #if canImport(FoundationModels)
    private var session: LanguageModelSession?
    #endif

    var isAvailable: Bool {
        #if canImport(FoundationModels)
        SystemLanguageModel.default.availability == .available
        #else
        false
        #endif
    }

    @MainActor
    func generate(ingredients: [IngredientData]) async {
        let systemPrompt = DefaultSystemPrompts.generationPromptBody
        isGenerating = true
        streamedText = ""
        error = nil

        #if canImport(FoundationModels)
        guard SystemLanguageModel.default.availability == .available else {
            error = "Foundation Model is not available on this device. Please use a supported device running iOS 26 or later."
            isGenerating = false
            return
        }

        let session = LanguageModelSession(instructions: systemPrompt)
        self.session = session

        let ingredientList = ingredients
            .map { "- \($0.emoji) \($0.label) (\($0.categoryId))" }
            .joined(separator: "\n")

        let userPrompt = """
        Selected ingredients:
        \(ingredientList)

        Create a creative food concept that combines these ingredients into one dish.
        """

        do {
            let stream = session.streamResponse(to: userPrompt)
            for try await partial in stream {
                streamedText = partial.content
            }
        } catch {
            self.error = "Generation failed: \(error.localizedDescription)"
        }
        #else
        // Simulator fallback: generate a placeholder food concept
        await generatePlaceholder(ingredients: ingredients)
        #endif

        isGenerating = false
    }

    func cancel() {
        #if canImport(FoundationModels)
        session = nil
        #endif
        isGenerating = false
    }

    // MARK: - Simulator Placeholder

    @MainActor
    private func generatePlaceholder(ingredients: [IngredientData]) async {
        let ingredientList = ingredients
            .map { "- \($0.emoji) **\($0.label)**" }
            .joined(separator: "\n")

        let names = ingredients.map(\.label)
        let title = names.count > 1
            ? "\(names.first!) \(names.last!) Fusion"
            : "\(names.first ?? "Mystery") Creation"

        let layers = ingredients.enumerated().map { index, ingredient in
            """
            ### Layer \(index + 1): \(ingredient.label) Component
            - A creative interpretation of \(ingredient.emoji) \(ingredient.label)
            - Adds \(["texture", "flavor", "aroma", "color", "crunch"][index % 5]) to the dish
            """
        }.joined(separator: "\n\n")

        let placeholder = """
        # \(title)

        ## Concept
        A bold fusion dish that brings together \(names.joined(separator: ", ")) \
        into one harmonious creation. Each ingredient plays a starring role in this \
        unexpected culinary mashup.

        ## Structure

        \(layers)

        ## Flavor Profile
        A complex balance of flavors that somehow works — each ingredient contributes \
        its signature taste while complementing the others in surprising ways.

        ## Serving Suggestion
        Presented on a large ceramic plate with dramatic plating. \
        Each component is visible and inviting, encouraging diners to explore every layer.

        ## Pairings
        - 🍵 Hot green tea for a clean palate refresher
        - 🥤 Sparkling lemonade for a fizzy contrast
        - 🍷 Light white wine for an elegant pairing

        ---

        *Note: This is a placeholder concept generated in simulator mode. \
        On a real device with iOS 26+, the Foundation Model will generate a fully creative food concept.*
        """

        // Simulate streaming by revealing text in chunks
        let characters = Array(placeholder)
        var current = ""
        var i = 0
        while i < characters.count {
            let chunkEnd = min(i + 6, characters.count)
            current += String(characters[i..<chunkEnd])
            streamedText = current
            i = chunkEnd
            try? await Task.sleep(for: .milliseconds(15))
        }
    }
}
