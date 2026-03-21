import ArgumentParser

struct ListCategories: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "list-categories",
        abstract: "List all ingredient categories."
    )

    @Option(name: .long, help: "Path to custom data JSON file.")
    var customFile: String?

    @Flag(name: .long, help: "Output in JSON format.")
    var json: Bool = false

    func run() {
        let categories = CustomDataStore.mergedCategories(customFile: customFile)
        print(OutputFormatter.formatCategories(categories, json: json))
    }
}
