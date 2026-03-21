import ArgumentParser

struct ShowPrompts: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "show-prompts",
        abstract: "Display system prompt templates."
    )

    @Option(name: .long, help: "Filter by purpose: generation.")
    var purpose: String?

    @Flag(name: .long, help: "Output in JSON format.")
    var json: Bool = false

    func run() throws {
        let purposes: [PromptPurpose]
        if let purposeStr = purpose {
            guard let p = PromptPurpose(rawValue: purposeStr) else {
                throw ValidationError("Invalid purpose '\(purposeStr)'. Use: generation.")
            }
            purposes = [p]
        } else {
            purposes = PromptPurpose.allCases
        }

        let prompts = purposes.map { (purpose: $0, body: PromptAssembler.systemPrompt(for: $0)) }
        print(OutputFormatter.formatPrompts(prompts, json: json))
    }
}
