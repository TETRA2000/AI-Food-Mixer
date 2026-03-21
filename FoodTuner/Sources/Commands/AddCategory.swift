import ArgumentParser
import Foundation

struct AddCategory: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "add-category",
        abstract: "Add a custom category to the config file."
    )

    @Option(name: .long, help: "Category ID (e.g., spices).")
    var id: String

    @Option(name: .long, help: "Display name (e.g., Spices).")
    var name: String

    @Option(name: .long, help: "Emoji icon.")
    var emoji: String

    @Option(name: .long, help: "Primary color hex (default: #636E72).")
    var color: String = "#636E72"

    @Option(name: .long, help: "Secondary color hex (default: #B2BEC3).")
    var secondaryColor: String = "#B2BEC3"

    @Option(name: .long, help: "Sort order (default: auto-incremented).")
    var sortOrder: Int?

    @Option(name: .long, help: "Path to custom data JSON file (default: custom_data.json).")
    var customFile: String = "custom_data.json"

    func run() throws {
        var data = try CustomDataStore.loadOrCreate(from: customFile)

        let order = sortOrder ?? (DefaultCategories.all.count + data.categories.count)

        let category = CategoryData(
            id: id,
            displayName: name,
            emoji: emoji,
            colorHex: color,
            secondaryColorHex: secondaryColor,
            sortOrder: order,
            isDefault: false
        )

        if let idx = data.categories.firstIndex(where: { $0.id == id }) {
            data.categories[idx] = category
            print("Updated category: \(emoji) [\(id)] \(name)")
        } else {
            data.categories.append(category)
            print("Added category: \(emoji) [\(id)] \(name)")
        }

        try CustomDataStore.save(data, to: customFile)
        print("Saved to \(customFile)")
    }
}
