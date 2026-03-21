import Foundation

struct CustomData: Codable {
    var categories: [CategoryData]
    var ingredients: [IngredientData]

    init(categories: [CategoryData] = [], ingredients: [IngredientData] = []) {
        self.categories = categories
        self.ingredients = ingredients
    }
}

enum CustomDataStore {

    static func load(from path: String) throws -> CustomData {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(CustomData.self, from: data)
    }

    static func save(_ customData: CustomData, to path: String) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(customData)
        let url = URL(fileURLWithPath: path)
        try data.write(to: url, options: .atomic)
    }

    static func loadOrCreate(from path: String) throws -> CustomData {
        if FileManager.default.fileExists(atPath: path) {
            return try load(from: path)
        }
        return CustomData()
    }

    static func mergedCategories(customFile: String?) -> [CategoryData] {
        var categories = DefaultCategories.all
        guard let path = customFile else { return categories }
        guard let custom = try? load(from: path) else { return categories }

        for customCat in custom.categories {
            if let idx = categories.firstIndex(where: { $0.id == customCat.id }) {
                categories[idx] = customCat
            } else {
                categories.append(customCat)
            }
        }
        return categories.sorted { $0.sortOrder < $1.sortOrder }
    }

    static func mergedIngredients(customFile: String?) -> [IngredientData] {
        var ingredients = DefaultIngredients.all
        guard let path = customFile else { return ingredients }
        guard let custom = try? load(from: path) else { return ingredients }

        for customIng in custom.ingredients {
            if let idx = ingredients.firstIndex(where: { $0.id == customIng.id }) {
                ingredients[idx] = customIng
            } else {
                ingredients.append(customIng)
            }
        }
        return ingredients
    }
}
