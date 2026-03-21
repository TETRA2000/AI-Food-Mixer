import ArgumentParser
import Foundation

struct BuildPrompt: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "build-prompt",
        abstract: "Build the complete prompt pair from ingredient IDs."
    )

    @Option(name: .long, help: "Comma-separated ingredient IDs.")
    var ids: String

    @Option(name: .long, help: "Path to a custom system prompt file (overrides default).")
    var systemPromptFile: String?

    @Option(name: .long, help: "Prompt purpose: generation.")
    var purpose: String = "generation"

    @Option(name: .long, help: "Path to custom data JSON file.")
    var customFile: String?

    @Flag(name: .long, help: "Output in JSON format.")
    var json: Bool = false

    func run() throws {
        guard let promptPurpose = PromptPurpose(rawValue: purpose) else {
            throw ValidationError("Invalid purpose '\(purpose)'. Use: generation.")
        }

        let idList = ids.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        let allIngredients = CustomDataStore.mergedIngredients(customFile: customFile)
        let (valid, invalid) = PromptAssembler.resolveIngredients(ids: idList, allIngredients: allIngredients)

        if !invalid.isEmpty {
            let suggestions = invalid.map { id in
                let suggestion = PromptAssembler.suggestId(for: id, from: allIngredients)
                return suggestion.map { "\(id) → did you mean '\($0)'?" } ?? id
            }
            throw ValidationError("Invalid ingredient IDs: \(suggestions.joined(separator: ", "))")
        }

        let systemPromptSource: String
        let systemPrompt: String
        if let file = systemPromptFile {
            systemPrompt = try String(contentsOfFile: file, encoding: .utf8)
            systemPromptSource = file
        } else {
            systemPrompt = PromptAssembler.systemPrompt(for: promptPurpose)
            systemPromptSource = "default"
        }

        let userPrompt = PromptAssembler.buildUserPrompt(from: valid)

        print(OutputFormatter.formatBuiltPrompt(
            systemPrompt: systemPrompt,
            userPrompt: userPrompt,
            ingredients: valid,
            purpose: promptPurpose,
            systemPromptSource: systemPromptSource,
            json: json
        ))
    }
}
