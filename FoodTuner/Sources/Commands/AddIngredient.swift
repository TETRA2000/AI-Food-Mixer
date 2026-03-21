import ArgumentParser
import Foundation

struct AddIngredient: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "add-ingredient",
        abstract: "Add a custom ingredient to the config file."
    )

    @Option(name: .long, help: "Ingredient ID (e.g., spices_paprika).")
    var id: String

    @Option(name: .long, help: "Display label (e.g., Paprika).")
    var label: String

    @Option(name: .long, help: "Emoji icon.")
    var emoji: String

    @Option(name: .long, help: "Category ID this ingredient belongs to.")
    var category: String

    @Option(name: .long, help: "Color hex (default: #636E72).")
    var color: String = "#636E72"

    @Option(name: .long, help: "Path to custom data JSON file (default: custom_data.json).")
    var customFile: String = "custom_data.json"

    func run() throws {
        var data = try CustomDataStore.loadOrCreate(from: customFile)

        let ingredient = IngredientData(
            id: id,
            emoji: emoji,
            label: label,
            categoryId: category,
            colorHex: color,
            isCustom: true
        )

        if let idx = data.ingredients.firstIndex(where: { $0.id == id }) {
            data.ingredients[idx] = ingredient
            print("Updated ingredient: \(emoji) [\(id)] \(label)")
        } else {
            data.ingredients.append(ingredient)
            print("Added ingredient: \(emoji) [\(id)] \(label)")
        }

        try CustomDataStore.save(data, to: customFile)
        print("Saved to \(customFile)")
    }
}
