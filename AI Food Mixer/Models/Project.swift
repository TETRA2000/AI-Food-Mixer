import Foundation
import SwiftData
import UIKit

@Model
final class Project {
    var projectId: UUID
    var title: String
    var createdAt: Date
    var updatedAt: Date
    var ingredientsData: Data
    var systemPromptBody: String
    var generatedConcept: String
    var imageData: Data?

    init(
        title: String,
        ingredients: [IngredientData],
        systemPromptBody: String,
        generatedConcept: String,
        imageData: Data? = nil
    ) {
        self.projectId = UUID()
        self.title = title
        self.createdAt = Date()
        self.updatedAt = Date()
        self.ingredientsData = (try? JSONEncoder().encode(ingredients)) ?? Data()
        self.systemPromptBody = systemPromptBody
        self.generatedConcept = generatedConcept
        self.imageData = imageData
    }

    var image: UIImage? {
        guard let imageData else { return nil }
        return UIImage(data: imageData)
    }

    var ingredients: [IngredientData] {
        get {
            (try? JSONDecoder().decode([IngredientData].self, from: ingredientsData)) ?? []
        }
        set {
            ingredientsData = (try? JSONEncoder().encode(newValue)) ?? Data()
            updatedAt = Date()
        }
    }

    var ingredientEmojis: String {
        ingredients.map(\.emoji).joined()
    }

    var wordCount: Int {
        generatedConcept.split(separator: " ").count
    }
}
