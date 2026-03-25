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

    private var generationTask: Task<Void, Never>?

    #if canImport(FoundationModels)
    private var session: LanguageModelSession?
    #endif

    /// Extracts the food name from the first `# Heading` in the generated markdown.
    var generatedFoodName: String? {
        guard let line = streamedText.components(separatedBy: .newlines)
            .first(where: { $0.hasPrefix("# ") }) else { return nil }
        let name = line.dropFirst(2).trimmingCharacters(in: .whitespaces)
        return name.isEmpty ? nil : name
    }

    var isAvailable: Bool {
        #if canImport(FoundationModels)
        SystemLanguageModel.default.availability == .available
        #else
        false
        #endif
    }

    /// Returns a user-friendly message explaining why Apple Intelligence is not available,
    /// or `nil` if it is available.
    var unavailabilityMessage: String? {
        #if canImport(FoundationModels)
        switch SystemLanguageModel.default.availability {
        case .available:
            return nil
        case .unavailable(let reason):
            switch reason {
            case .deviceNotEligible:
                return "This device does not support Apple Intelligence. An iPhone 15 Pro or later, or an iPad or Mac with an M1 chip or later, is required."
            case .appleIntelligenceNotEnabled:
                return "Apple Intelligence is not enabled. Please enable it in Settings > Apple Intelligence & Siri to use this app's features."
            case .modelNotReady:
                return "Apple Intelligence is still setting up. Please wait for the download to complete in Settings > Apple Intelligence & Siri, then try again."
            @unknown default:
                return "Apple Intelligence is currently unavailable on this device. Please check Settings > Apple Intelligence & Siri."
            }
        @unknown default:
            return "Apple Intelligence is currently unavailable on this device. Please check Settings > Apple Intelligence & Siri."
        }
        #else
        return "Apple Intelligence is not available in the simulator."
        #endif
    }

    // MARK: - Prewarm

    /// Preloads the Foundation Model and caches the prompt prefix to reduce generation latency.
    /// Call this when the user taps Mix, before presenting the generation screen.
    func prewarm() {
        #if canImport(FoundationModels)
        guard SystemLanguageModel.default.availability == .available else { return }
        guard session == nil else { return }

        let session = LanguageModelSession(instructions: DefaultSystemPrompts.generationPromptBody)
        self.session = session

        session.prewarm(promptPrefix: Prompt(Self.userPromptPrefix))
        #endif
    }

    // MARK: - Generate

    @MainActor
    func generate(ingredients: [IngredientData]) async {
        isGenerating = true
        streamedText = ""
        error = nil

        // Cancel any previous generation task
        generationTask?.cancel()

        let task = Task { @MainActor in
            #if canImport(FoundationModels)
            guard SystemLanguageModel.default.availability == .available else {
                error = unavailabilityMessage ?? "Apple Intelligence is currently unavailable on this device."
                isGenerating = false
                return
            }

            // Reuse prewarmed session if available, otherwise create a new one
            let session = self.session ?? LanguageModelSession(instructions: DefaultSystemPrompts.generationPromptBody)
            self.session = session

            let userPrompt = Self.buildUserPrompt(ingredients: ingredients)

            do {
                let stream = session.streamResponse(to: userPrompt)
                for try await partial in stream {
                    try Task.checkCancellation()
                    streamedText = partial.content
                }
            } catch is CancellationError {
                // Task was cancelled (e.g. user dismissed the view) — not an error
                return
            } catch {
                self.error = "Generation failed: \(error.localizedDescription)"
            }
            #else
            // Simulator fallback: generate a placeholder food concept
            do {
                try await generatePlaceholder(ingredients: ingredients)
            } catch is CancellationError {
                return
            } catch {
                self.error = "Generation failed: \(error.localizedDescription)"
            }
            #endif

            isGenerating = false
        }
        generationTask = task

        // Bridge parent task cancellation (e.g. SwiftUI .task) to the inner task
        await withTaskCancellationHandler {
            await task.value
        } onCancel: {
            task.cancel()
        }
    }

    // MARK: - Prompt Building

    /// The static prefix of the user prompt, shared between prewarm and generate.
    /// Placed first so the Foundation Model can cache and reuse this portion across requests.
    private static let userPromptPrefix = """
        Create a creative food concept that combines the following ingredients into one dish.

        Selected ingredients:

        """

    private static func buildUserPrompt(ingredients: [IngredientData]) -> String {
        let ingredientList = ingredients
            .map { "- \($0.emoji) \($0.label) (\($0.categoryId))" }
            .joined(separator: "\n")

        return "\(userPromptPrefix)\(ingredientList)"
    }

    func cancel() {
        generationTask?.cancel()
        generationTask = nil
        #if canImport(FoundationModels)
        session = nil
        #endif
        isGenerating = false
    }

    // MARK: - Simulator Placeholder

    @MainActor
    private func generatePlaceholder(ingredients: [IngredientData]) async throws {
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
            try Task.checkCancellation()
            let chunkEnd = min(i + 6, characters.count)
            current += String(characters[i..<chunkEnd])
            streamedText = current
            i = chunkEnd
            try await Task.sleep(for: .milliseconds(15))
        }
    }
}
