import ArgumentParser

struct ShowPrompts: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "show-prompts",
        abstract: "Display the system prompt template."
    )

    @Flag(name: .long, help: "Output in JSON format.")
    var json: Bool = false

    func run() throws {
        let body = PromptAssembler.systemPrompt()
        print(OutputFormatter.formatPrompt(body: body, json: json))
    }
}
