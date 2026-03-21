import Testing
@testable import AI_Food_Mixer

struct AI_Food_MixerTests {

    // MARK: - Default Categories

    @Test func defaultCategoriesCount() {
        #expect(DefaultCategories.all.count == 10)
    }

    @Test func categoriesHaveUniqueSortOrders() {
        let sortOrders = DefaultCategories.all.map(\.sortOrder)
        #expect(Set(sortOrders).count == sortOrders.count)
    }

    @Test func categoriesHaveUniqueIds() {
        let ids = DefaultCategories.all.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test func categoryLookupWorks() {
        let fruits = DefaultCategories.category(for: "fruits")
        #expect(fruits != nil)
        #expect(fruits?.displayName == "Fruits")
        #expect(fruits?.emoji == "🍎")

        #expect(DefaultCategories.category(for: "nonexistent") == nil)
    }

    // MARK: - Default Ingredients

    @Test func defaultIngredientsAreNonEmpty() {
        #expect(!DefaultIngredients.all.isEmpty)
    }

    @Test func ingredientsHaveUniqueIds() {
        let ids = DefaultIngredients.all.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test func eachCategoryHasIngredients() {
        for category in DefaultCategories.all {
            let ingredients = DefaultIngredients.ingredients(for: category.id)
            #expect(!ingredients.isEmpty, "Category \(category.displayName) has no ingredients")
        }
    }

    @Test func ingredientCategoryIdsMatchCategories() {
        let validCategoryIds = Set(DefaultCategories.all.map(\.id))
        for ingredient in DefaultIngredients.all {
            #expect(validCategoryIds.contains(ingredient.categoryId),
                    "Ingredient \(ingredient.id) has invalid categoryId: \(ingredient.categoryId)")
        }
    }

    @Test func ingredientCategoryBreakdown() {
        #expect(DefaultIngredients.fruits.count == 19)
        #expect(DefaultIngredients.vegetables.count == 18)
        #expect(DefaultIngredients.grains.count == 8)
        #expect(DefaultIngredients.protein.count == 5)
        #expect(DefaultIngredients.seafood.count == 7)
        #expect(DefaultIngredients.preparedDishes.count == 18)
        #expect(DefaultIngredients.fastFood.count == 10)
        #expect(DefaultIngredients.desserts.count == 13)
        #expect(DefaultIngredients.drinks.count == 16)
        #expect(DefaultIngredients.condiments.count == 6)
    }

    // MARK: - IngredientData

    @Test func ingredientDataCodable() throws {
        let ingredient = IngredientData(
            id: "test_pizza",
            emoji: "🍕",
            label: "Pizza",
            categoryId: "preparedDishes",
            colorHex: "#FF922B"
        )

        let data = try JSONEncoder().encode(ingredient)
        let decoded = try JSONDecoder().decode(IngredientData.self, from: data)

        #expect(decoded.id == ingredient.id)
        #expect(decoded.emoji == ingredient.emoji)
        #expect(decoded.label == ingredient.label)
        #expect(decoded.categoryId == ingredient.categoryId)
        #expect(decoded.colorHex == ingredient.colorHex)
        #expect(decoded.isCustom == false)
    }

    // MARK: - CategoryData

    @Test func categoryDataCodable() throws {
        let category = CategoryData(
            id: "test",
            displayName: "Test",
            emoji: "🧪",
            colorHex: "#FF0000",
            secondaryColorHex: "#FF8888",
            sortOrder: 99
        )

        let data = try JSONEncoder().encode(category)
        let decoded = try JSONDecoder().decode(CategoryData.self, from: data)

        #expect(decoded.id == category.id)
        #expect(decoded.displayName == category.displayName)
        #expect(decoded.isDefault == true)
    }

    // MARK: - PromptPurpose

    @Test func promptPurposeOnlyHasGeneration() {
        #expect(PromptPurpose.allCases.count == 1)
        #expect(PromptPurpose.allCases.first == .generation)
    }

    @Test func promptPurposeDisplayName() {
        #expect(PromptPurpose.generation.displayName == "Food Concept Generation")
    }

    // MARK: - DefaultSystemPrompts

    @Test func systemPromptIsNonEmpty() {
        #expect(!DefaultSystemPrompts.generationPromptBody.isEmpty)
    }

    @Test func systemPromptContainsFoodTerms() {
        let prompt = DefaultSystemPrompts.generationPromptBody
        #expect(prompt.contains("food"))
        #expect(prompt.contains("Flavor Profile"))
        #expect(prompt.contains("Serving Suggestion"))
        #expect(prompt.contains("Pairings"))
    }

    // MARK: - DefaultDiscoverItems

    @Test func discoverItemsExist() {
        #expect(DefaultDiscoverItems.all.count == 5)
    }

    @Test func discoverItemsHaveIngredients() {
        for item in DefaultDiscoverItems.all {
            #expect(!item.ingredients.isEmpty, "Discover item '\(item.title)' has no ingredients")
            #expect(!item.conceptPreview.isEmpty, "Discover item '\(item.title)' has no preview")
        }
    }

    // MARK: - ExportService

    @Test func exportSanitizeFileName() {
        // Test the service by creating a markdown file with an empty title
        let url = ExportService.markdownFileURL(title: "", content: "test")
        #expect(url != nil)
        #expect(url?.lastPathComponent == "FoodConcept.md")
    }

    @Test func exportMarkdownFile() {
        let url = ExportService.markdownFileURL(title: "Test Dish", content: "# Test")
        #expect(url != nil)
        #expect(url?.lastPathComponent == "Test_Dish.md")
    }

    // MARK: - MixViewModel

    @Test func mixViewModelSelection() {
        let vm = MixViewModel()
        let ingredient = DefaultIngredients.fruits[0]

        #expect(vm.selectedCount == 0)
        #expect(!vm.isSelected(ingredient))

        vm.toggleIngredient(ingredient)
        #expect(vm.selectedCount == 1)
        #expect(vm.isSelected(ingredient))

        vm.toggleIngredient(ingredient)
        #expect(vm.selectedCount == 0)
        #expect(!vm.isSelected(ingredient))
    }

    @Test func mixViewModelClearSelection() {
        let vm = MixViewModel()
        vm.toggleIngredient(DefaultIngredients.fruits[0])
        vm.toggleIngredient(DefaultIngredients.fruits[1])
        #expect(vm.selectedCount == 2)

        vm.clearSelection()
        #expect(vm.selectedCount == 0)
    }

    @Test func mixViewModelSurpriseMe() {
        let vm = MixViewModel()
        vm.surpriseMe(customCategories: [], customIngredients: [])

        // Should have one ingredient per category
        #expect(vm.selectedCount == DefaultCategories.all.count)

        // Each should be from a different category
        let categoryIds = Set(vm.selectedIngredients.map(\.categoryId))
        #expect(categoryIds.count == DefaultCategories.all.count)
    }

    @Test func mixViewModelLoadIngredients() {
        let vm = MixViewModel()
        let ingredients = Array(DefaultIngredients.fruits.prefix(3))
        vm.loadIngredients(ingredients)
        #expect(vm.selectedCount == 3)
    }
}
