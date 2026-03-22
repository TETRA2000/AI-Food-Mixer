import ArgumentParser
import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif

struct Generate: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "generate",
        abstract: "Generate a food concept using the on-device Foundation Model."
    )

    @Option(name: .long, help: "Comma-separated ingredient IDs.")
    var ids: String

    @Option(name: .long, help: "Path to a custom system prompt file (overrides default).")
    var systemPromptFile: String?

    @Option(name: .long, help: "Path to custom data JSON file.")
    var customFile: String?

    @Option(name: .long, help: "Path to write the generated concept (default: stdout).")
    var output: String?

    func run() async throws {
        #if canImport(FoundationModels)
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

        let systemPrompt: String
        if let file = systemPromptFile {
            systemPrompt = try String(contentsOfFile: file, encoding: .utf8)
        } else {
            systemPrompt = PromptAssembler.systemPrompt()
        }

        let userPrompt = PromptAssembler.buildUserPrompt(from: valid)

        // Check availability
        guard SystemLanguageModel.default.availability == .available else {
            throw ValidationError("Foundation Model is not available on this device.")
        }

        let session = LanguageModelSession(instructions: systemPrompt)

        FileHandle.standardError.write(Data("Generating food concept with \(valid.count) ingredients...\n".utf8))

        var result = ""
        let stream = session.streamResponse(to: userPrompt)
        for try await partial in stream {
            // Print incremental content to stderr for progress
            let newContent = String(partial.content.dropFirst(result.count))
            if !newContent.isEmpty {
                FileHandle.standardError.write(Data(newContent.utf8))
            }
            result = partial.content
        }
        FileHandle.standardError.write(Data("\n".utf8))

        // Write final result to stdout or file
        if let outputPath = output {
            try result.write(toFile: outputPath, atomically: true, encoding: .utf8)
            FileHandle.standardError.write(Data("Written to \(outputPath)\n".utf8))
        } else {
            print(result)
        }
        #else
        throw ValidationError("FoundationModels framework is not available. Requires macOS 26+ or iOS 26+.")
        #endif
    }
}
