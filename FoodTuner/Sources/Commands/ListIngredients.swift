import ArgumentParser

struct ListIngredients: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "list-ingredients",
        abstract: "List all ingredients, optionally filtered by category."
    )

    @Option(name: .long, help: "Filter by category ID (e.g., fruits, desserts).")
    var category: String?

    @Option(name: .long, help: "Path to custom data JSON file.")
    var customFile: String?

    @Flag(name: .long, help: "Output in JSON format.")
    var json: Bool = false

    func run() {
        var ingredients = CustomDataStore.mergedIngredients(customFile: customFile)
        if let category {
            ingredients = ingredients.filter { $0.categoryId == category }
        }
        print(OutputFormatter.formatIngredients(ingredients, json: json))
    }
}
