import ArgumentParser

struct ValidateIds: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "validate-ids",
        abstract: "Validate ingredient IDs and suggest corrections."
    )

    @Option(name: .long, help: "Comma-separated ingredient IDs to validate.")
    var ids: String

    @Option(name: .long, help: "Path to custom data JSON file.")
    var customFile: String?

    @Flag(name: .long, help: "Output in JSON format.")
    var json: Bool = false

    func run() {
        let idList = ids.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        let allIngredients = CustomDataStore.mergedIngredients(customFile: customFile)
        let (valid, invalidIds) = PromptAssembler.resolveIngredients(ids: idList, allIngredients: allIngredients)

        let invalid = invalidIds.map { id in
            (id: id, suggestion: PromptAssembler.suggestId(for: id, from: allIngredients))
        }

        print(OutputFormatter.formatValidation(valid: valid, invalid: invalid, json: json))
    }
}
