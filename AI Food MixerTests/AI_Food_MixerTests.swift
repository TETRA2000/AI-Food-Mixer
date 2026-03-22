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

        // Should pick between 3 and 6 ingredients
        #expect(vm.selectedCount >= 3)
        #expect(vm.selectedCount <= 6)

        // Each should be from a different category
        let categoryIds = Set(vm.selectedIngredients.map(\.categoryId))
        #expect(categoryIds.count == vm.selectedCount)
    }

    @Test func mixViewModelLoadIngredients() {
        let vm = MixViewModel()
        let ingredients = Array(DefaultIngredients.fruits.prefix(3))
        vm.loadIngredients(ingredients)
        #expect(vm.selectedCount == 3)
    }

    @Test func mixViewModelAllCategories() {
        let vm = MixViewModel()
        let categories = vm.allCategories(customCategories: [])
        #expect(categories.count == DefaultCategories.all.count)
        // Verify sorted by sortOrder
        for i in 0..<categories.count - 1 {
            #expect(categories[i].sortOrder <= categories[i + 1].sortOrder)
        }
    }

    @Test func mixViewModelIngredients() {
        let vm = MixViewModel()
        let fruits = vm.ingredients(for: "fruits", customIngredients: [])
        #expect(fruits.count == DefaultIngredients.fruits.count)
    }

    @Test func mixViewModelGeneratedTitle() {
        let vm = MixViewModel()
        let ingredients = Array(DefaultIngredients.fruits.prefix(3))
        vm.loadIngredients(ingredients)
        // When no projectTitle is set, title is generated from first 3 ingredient labels
        #expect(vm.projectTitle.isEmpty)
    }

    @Test func mixViewModelMaxSelection() {
        let vm = MixViewModel()
        // Select all fruits
        for ingredient in DefaultIngredients.fruits {
            vm.toggleIngredient(ingredient)
        }
        #expect(vm.selectedCount == DefaultIngredients.fruits.count)
        // Deselect all
        for ingredient in DefaultIngredients.fruits {
            vm.toggleIngredient(ingredient)
        }
        #expect(vm.selectedCount == 0)
    }

    // MARK: - DiscoverViewModel

    @Test func discoverViewModelInitialState() {
        let vm = DiscoverViewModel()
        #expect(vm.items.count == 5)
        #expect(vm.items == DefaultDiscoverItems.all)
    }

    // MARK: - Project Model

    @Test func projectInitialization() {
        let ingredients = Array(DefaultIngredients.fruits.prefix(2))
        let project = Project(
            title: "Test",
            ingredients: ingredients,
            systemPromptBody: "prompt",
            generatedConcept: "concept"
        )
        #expect(project.title == "Test")
        #expect(project.ingredients.count == 2)
        #expect(project.systemPromptBody == "prompt")
        #expect(project.generatedConcept == "concept")
        #expect(project.ingredientEmojis == ingredients.map(\.emoji).joined())
    }

    @Test func projectWordCount() {
        let project = Project(
            title: "Test",
            ingredients: [],
            systemPromptBody: "",
            generatedConcept: "This is a five word sentence"
        )
        #expect(project.wordCount == 6)
    }

    @Test func projectEmptyIngredients() {
        let project = Project(
            title: "Empty",
            ingredients: [],
            systemPromptBody: "",
            generatedConcept: ""
        )
        #expect(project.ingredients.isEmpty)
        #expect(project.ingredientEmojis == "")
        #expect(project.wordCount == 0)
    }

    // MARK: - ExportService Extended

    @Test func exportPlainTextFile() {
        let url = ExportService.plainTextFileURL(title: "Test Dish", content: "# Heading\n**Bold** text")
        #expect(url != nil)
        #expect(url?.lastPathComponent == "Test_Dish.txt")
    }

    @Test func exportIngredientsJSON() {
        let ingredients = Array(DefaultIngredients.fruits.prefix(2))
        let url = ExportService.ingredientsJSON(ingredients)
        #expect(url != nil)
        #expect(url?.pathExtension == "json")
    }

    @Test func exportSanitizeSpecialCharacters() {
        let url = ExportService.markdownFileURL(title: "Hello/World:Test!", content: "test")
        #expect(url != nil)
        // Special characters should be stripped
        #expect(url?.lastPathComponent == "HelloWorldTest.md")
    }

    // MARK: - FoodGenerationService

    @Test func foodGenerationServiceInitialState() {
        let service = FoodGenerationService()
        #expect(!service.isGenerating)
        #expect(service.streamedText.isEmpty)
        #expect(service.error == nil)
    }

    @Test func foodGenerationServiceCancel() {
        let service = FoodGenerationService()
        service.cancel()
        #expect(!service.isGenerating)
    }

    // MARK: - Color+Hex

    @Test func colorFromHexValid() {
        let color = Color(hex: "#FF0000")
        #expect(color != nil)
    }

    @Test func colorFromHexWithoutHash() {
        let color = Color(hex: "FF0000")
        #expect(color != nil)
    }

    // MARK: - IngredientData Gradient

    @Test func ingredientCardGradient() {
        let ingredient = DefaultIngredients.fruits[0]
        let gradient = ingredient.cardGradient
        // Just verify it doesn't crash
        #expect(type(of: gradient) == LinearGradient.self)
    }

    // MARK: - CategoryData Gradient

    @Test func categoryGradient() {
        let category = DefaultCategories.all[0]
        let gradient = category.gradient
        #expect(type(of: gradient) == LinearGradient.self)
    }

    // MARK: - SystemPrompt Model

    @Test func systemPromptPurposeConversion() {
        let prompt = SystemPrompt(
            name: "Test",
            body: "Body",
            purpose: .generation,
            isDefault: true
        )
        #expect(prompt.purpose == .generation)
        #expect(prompt.purposeRaw == "generation")
        #expect(prompt.isDefault == true)
    }

    // MARK: - DiscoverItem Validation

    @Test func discoverItemIngredientsAreValid() {
        let validIds = Set(DefaultIngredients.all.map(\.id))
        for item in DefaultDiscoverItems.all {
            for ingredient in item.ingredients {
                #expect(validIds.contains(ingredient.id),
                        "Discover item '\(item.title)' references invalid ingredient: \(ingredient.id)")
            }
        }
    }

    @Test func discoverItemConceptsContainStructure() {
        for item in DefaultDiscoverItems.all {
            #expect(item.conceptPreview.contains("## Concept"),
                    "Discover item '\(item.title)' missing Concept section")
            #expect(item.conceptPreview.contains("## Flavor Profile"),
                    "Discover item '\(item.title)' missing Flavor Profile section")
        }
    }
}
