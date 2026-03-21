import Foundation

struct DiscoverItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let ingredients: [IngredientData]
    let conceptPreview: String

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        ingredients: [IngredientData],
        conceptPreview: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.ingredients = ingredients
        self.conceptPreview = conceptPreview
    }
}
