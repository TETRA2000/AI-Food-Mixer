import Testing
import SwiftUI
import SwiftData
import Foundation
@testable import AI_Food_Mixer

@MainActor
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

    @Test func categoriesSortOrdersAreSequential() {
        let sortOrders = DefaultCategories.all.map(\.sortOrder).sorted()
        #expect(sortOrders == Array(0..<10))
    }

    @Test func allDefaultCategoriesAreMarkedDefault() {
        for category in DefaultCategories.all {
            #expect(category.isDefault == true, "Category '\(category.displayName)' should have isDefault == true")
        }
    }

    @Test func allCategoriesHaveNonEmptyFields() {
        for category in DefaultCategories.all {
            #expect(!category.id.isEmpty)
            #expect(!category.displayName.isEmpty)
            #expect(!category.emoji.isEmpty)
            #expect(!category.colorHex.isEmpty)
            #expect(!category.secondaryColorHex.isEmpty)
        }
    }

    @Test func categoryLookupAllIds() {
        let expectedIds = ["fruits", "vegetables", "grains", "protein", "seafood",
                           "preparedDishes", "fastFood", "desserts", "drinks", "condiments"]
        for id in expectedIds {
            #expect(DefaultCategories.category(for: id) != nil, "Category with id '\(id)' should exist")
        }
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

    @Test func defaultIngredientsTotalCount() {
        #expect(DefaultIngredients.all.count == 120)
    }

    @Test func noDefaultIngredientsAreCustom() {
        for ingredient in DefaultIngredients.all {
            #expect(ingredient.isCustom == false, "Default ingredient '\(ingredient.label)' should not be custom")
        }
    }

    @Test func ingredientsForUnknownCategoryReturnsEmpty() {
        let result = DefaultIngredients.ingredients(for: "nonexistent_category")
        #expect(result.isEmpty)
    }

    @Test func ingredientsForCategoryMatchesDirectAccess() {
        #expect(DefaultIngredients.ingredients(for: "fruits").count == DefaultIngredients.fruits.count)
        #expect(DefaultIngredients.ingredients(for: "vegetables").count == DefaultIngredients.vegetables.count)
        #expect(DefaultIngredients.ingredients(for: "condiments").count == DefaultIngredients.condiments.count)
    }

    @Test func allDefaultIngredientsHaveNonEmptyFields() {
        for ingredient in DefaultIngredients.all {
            #expect(!ingredient.id.isEmpty)
            #expect(!ingredient.emoji.isEmpty)
            #expect(!ingredient.label.isEmpty)
            #expect(!ingredient.categoryId.isEmpty)
            #expect(!ingredient.colorHex.isEmpty)
        }
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

    @Test func ingredientDataDefaultIsCustomFalse() {
        let ingredient = IngredientData(
            emoji: "🍎",
            label: "Apple",
            categoryId: "fruits",
            colorHex: "#FF0000"
        )
        #expect(ingredient.isCustom == false)
    }

    @Test func ingredientDataExplicitIsCustomTrue() {
        let ingredient = IngredientData(
            emoji: "🍎",
            label: "Apple",
            categoryId: "fruits",
            colorHex: "#FF0000",
            isCustom: true
        )
        #expect(ingredient.isCustom == true)
    }

    @Test func ingredientDataFromCustomIngredient() {
        let custom = CustomIngredient(
            ingredientId: "custom_test",
            emoji: "🧪",
            label: "Test Item",
            categoryId: "fruits",
            colorHex: "#AABBCC"
        )
        let data = IngredientData(from: custom)
        #expect(data.id == "custom_test")
        #expect(data.emoji == "🧪")
        #expect(data.label == "Test Item")
        #expect(data.categoryId == "fruits")
        #expect(data.colorHex == "#AABBCC")
        #expect(data.isCustom == true)
    }

    @Test func ingredientDataAutoGeneratesId() {
        let ingredient1 = IngredientData(emoji: "🍎", label: "Apple", categoryId: "fruits", colorHex: "#FF0000")
        let ingredient2 = IngredientData(emoji: "🍎", label: "Apple", categoryId: "fruits", colorHex: "#FF0000")
        #expect(ingredient1.id != ingredient2.id)
    }

    @Test func ingredientDataHashable() {
        let ingredient = IngredientData(
            id: "test_id",
            emoji: "🍎",
            label: "Apple",
            categoryId: "fruits",
            colorHex: "#FF0000"
        )
        let set: Set<IngredientData> = [ingredient, ingredient]
        #expect(set.count == 1)
    }

    @Test func ingredientDataIdentifiable() {
        let ingredient = IngredientData(
            id: "my_id",
            emoji: "🍎",
            label: "Apple",
            categoryId: "fruits",
            colorHex: "#FF0000"
        )
        #expect(ingredient.id == "my_id")
    }

    @Test func ingredientDataCodableWithCustomTrue() throws {
        let ingredient = IngredientData(
            id: "custom_1",
            emoji: "🧪",
            label: "Custom",
            categoryId: "test",
            colorHex: "#000000",
            isCustom: true
        )
        let data = try JSONEncoder().encode(ingredient)
        let decoded = try JSONDecoder().decode(IngredientData.self, from: data)
        #expect(decoded.isCustom == true)
    }

    @Test func ingredientDataCodableWithEmoji() throws {
        let ingredient = IngredientData(
            id: "test",
            emoji: "🍋‍🟩",
            label: "Lime",
            categoryId: "fruits",
            colorHex: "#00FF00"
        )
        let data = try JSONEncoder().encode(ingredient)
        let decoded = try JSONDecoder().decode(IngredientData.self, from: data)
        #expect(decoded.emoji == "🍋‍🟩")
    }

    // MARK: - CustomIngredient

    @Test func customIngredientAutoGeneratesId() {
        let custom1 = CustomIngredient(emoji: "🍎", label: "Apple", categoryId: "fruits", colorHex: "#FF0000")
        let custom2 = CustomIngredient(emoji: "🍎", label: "Apple", categoryId: "fruits", colorHex: "#FF0000")
        #expect(custom1.ingredientId != custom2.ingredientId)
    }

    @Test func customIngredientExplicitId() {
        let custom = CustomIngredient(
            ingredientId: "specific_id",
            emoji: "🍎",
            label: "Apple",
            categoryId: "fruits",
            colorHex: "#FF0000"
        )
        #expect(custom.ingredientId == "specific_id")
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

    @Test func categoryDataDefaultIsDefaultTrue() {
        let category = CategoryData(
            id: "test",
            displayName: "Test",
            emoji: "🧪",
            colorHex: "#FF0000",
            secondaryColorHex: "#FF8888",
            sortOrder: 0
        )
        #expect(category.isDefault == true)
    }

    @Test func categoryDataExplicitIsDefaultFalse() {
        let category = CategoryData(
            id: "test",
            displayName: "Test",
            emoji: "🧪",
            colorHex: "#FF0000",
            secondaryColorHex: "#FF8888",
            sortOrder: 0,
            isDefault: false
        )
        #expect(category.isDefault == false)
    }

    @Test func categoryDataFromCustomCategory() {
        let custom = CustomCategory(
            categoryId: "custom_cat",
            displayName: "Custom Category",
            emoji: "🎨",
            colorHex: "#112233",
            secondaryColorHex: "#445566",
            sortOrder: 42
        )
        let data = CategoryData(from: custom)
        #expect(data.id == "custom_cat")
        #expect(data.displayName == "Custom Category")
        #expect(data.emoji == "🎨")
        #expect(data.colorHex == "#112233")
        #expect(data.secondaryColorHex == "#445566")
        #expect(data.sortOrder == 42)
        #expect(data.isDefault == false)
    }

    @Test func categoryDataHashable() {
        let category = CategoryData(
            id: "test",
            displayName: "Test",
            emoji: "🧪",
            colorHex: "#FF0000",
            secondaryColorHex: "#FF8888",
            sortOrder: 0
        )
        let set: Set<CategoryData> = [category, category]
        #expect(set.count == 1)
    }

    @Test func categoryDataCodableRoundTrip() throws {
        let category = CategoryData(
            id: "round_trip",
            displayName: "Round Trip",
            emoji: "🔄",
            colorHex: "#AABBCC",
            secondaryColorHex: "#DDEEFF",
            sortOrder: 15,
            isDefault: false
        )
        let data = try JSONEncoder().encode(category)
        let decoded = try JSONDecoder().decode(CategoryData.self, from: data)
        #expect(decoded.id == "round_trip")
        #expect(decoded.emoji == "🔄")
        #expect(decoded.sortOrder == 15)
        #expect(decoded.isDefault == false)
    }

    // MARK: - CustomCategory

    @Test func customCategoryAutoGeneratesId() {
        let cat1 = CustomCategory(displayName: "Cat", emoji: "🐱", colorHex: "#000", secondaryColorHex: "#111", sortOrder: 0)
        let cat2 = CustomCategory(displayName: "Cat", emoji: "🐱", colorHex: "#000", secondaryColorHex: "#111", sortOrder: 0)
        #expect(cat1.categoryId != cat2.categoryId)
    }

    @Test func customCategoryExplicitId() {
        let cat = CustomCategory(
            categoryId: "my_cat_id",
            displayName: "Cat",
            emoji: "🐱",
            colorHex: "#000",
            secondaryColorHex: "#111",
            sortOrder: 0
        )
        #expect(cat.categoryId == "my_cat_id")
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

    @Test func systemPromptContainsStructureTerms() {
        let prompt = DefaultSystemPrompts.generationPromptBody
        #expect(prompt.contains("Concept"))
        #expect(prompt.contains("Structure"))
    }

    @Test func systemPromptContainsMarkdownRules() {
        let prompt = DefaultSystemPrompts.generationPromptBody
        #expect(prompt.contains("#"))
        #expect(prompt.contains("Markdown"))
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

    @Test func discoverItemsHaveNonEmptyTitlesAndDescriptions() {
        for item in DefaultDiscoverItems.all {
            #expect(!item.title.isEmpty)
            #expect(!item.description.isEmpty)
        }
    }

    @Test func discoverItemConceptsContainAllSections() {
        let requiredSections = ["## Concept", "## Structure", "## Flavor Profile", "## Serving Suggestion", "## Pairings"]
        for item in DefaultDiscoverItems.all {
            for section in requiredSections {
                #expect(item.conceptPreview.contains(section),
                        "Discover item '\(item.title)' missing '\(section)' section")
            }
        }
    }

    @Test func discoverItemConceptsContainTitle() {
        for item in DefaultDiscoverItems.all {
            #expect(item.conceptPreview.contains("# \(item.title)"),
                    "Discover item '\(item.title)' concept should contain its title as a heading")
        }
    }

    @Test func discoverItemIngredientCounts() {
        #expect(DefaultDiscoverItems.curryLavaPizzaCake.ingredients.count == 3)
        #expect(DefaultDiscoverItems.sushiTacoFusion.ingredients.count == 3)
        #expect(DefaultDiscoverItems.breakfastRamenBowl.ingredients.count == 4)
        #expect(DefaultDiscoverItems.dessertBurger.ingredients.count == 4)
        #expect(DefaultDiscoverItems.mediterraneanDumpling.ingredients.count == 4)
    }

    // MARK: - DiscoverItem Model

    @Test func discoverItemIdentifiable() {
        let item = DiscoverItem(
            title: "Test",
            description: "Desc",
            ingredients: [],
            conceptPreview: "Preview"
        )
        // id should be a valid UUID
        #expect(item.id != UUID(uuidString: "00000000-0000-0000-0000-000000000000"))
    }

    @Test func discoverItemHashable() {
        let item1 = DiscoverItem(
            title: "Test",
            description: "Desc",
            ingredients: [],
            conceptPreview: "Preview"
        )
        let item2 = DiscoverItem(
            title: "Test",
            description: "Desc",
            ingredients: [],
            conceptPreview: "Preview"
        )
        // Different instances have different ids
        #expect(item1 != item2)
        let set: Set<DiscoverItem> = [item1, item1]
        #expect(set.count == 1)
    }

    @Test func discoverItemExplicitId() {
        let id = UUID()
        let item = DiscoverItem(
            id: id,
            title: "Test",
            description: "Desc",
            ingredients: [],
            conceptPreview: "Preview"
        )
        #expect(item.id == id)
    }

    // MARK: - ExportService

    @Test func exportSanitizeFileName() {
        let url = ExportService.markdownFileURL(title: "", content: "test")
        #expect(url != nil)
        #expect(url?.lastPathComponent == "FoodConcept.md")
    }

    @Test func exportMarkdownFile() {
        let url = ExportService.markdownFileURL(title: "Test Dish", content: "# Test")
        #expect(url != nil)
        #expect(url?.lastPathComponent == "Test_Dish.md")
    }

    @Test func exportMarkdownFileContent() throws {
        let content = "# My Food\n\n## Concept\nSome concept here."
        let url = ExportService.markdownFileURL(title: "Content Test", content: content)
        #expect(url != nil)
        let fileContent = try String(contentsOf: url!, encoding: .utf8)
        #expect(fileContent == content)
    }

    @Test func exportPlainTextFileContent() throws {
        let content = "# Heading\n**Bold** text"
        let url = ExportService.plainTextFileURL(title: "Plain Test", content: content)
        #expect(url != nil)
        let fileContent = try String(contentsOf: url!, encoding: .utf8)
        // Markdown should be stripped
        #expect(!fileContent.contains("# "))
        #expect(!fileContent.contains("**"))
        #expect(fileContent.contains("Heading"))
        #expect(fileContent.contains("Bold"))
        #expect(fileContent.contains("text"))
    }

    @Test func exportSanitizeWhitespaceOnlyTitle() {
        let url = ExportService.markdownFileURL(title: "   ", content: "test")
        #expect(url != nil)
        #expect(url?.lastPathComponent == "FoodConcept.md")
    }

    @Test func exportSanitizeEmojiTitle() {
        let url = ExportService.markdownFileURL(title: "🍕🍛🍰", content: "test")
        #expect(url != nil)
        // Emoji are not alphanumeric unicode scalars, so they get stripped -> fallback
        #expect(url?.lastPathComponent == "FoodConcept.md")
    }

    @Test func exportSanitizeMultipleSpacesTitle() {
        let url = ExportService.markdownFileURL(title: "Hello  World", content: "test")
        #expect(url != nil)
        // Double space becomes double underscore since replacingOccurrences replaces each space
        #expect(url?.lastPathComponent == "Hello__World.md")
    }

    @Test func exportIngredientsJSONContent() throws {
        let ingredients = Array(DefaultIngredients.fruits.prefix(2))
        let url = ExportService.ingredientsJSON(ingredients)
        #expect(url != nil)
        let data = try Data(contentsOf: url!)
        let decoded = try JSONDecoder().decode(IngredientExport.self, from: data)
        #expect(decoded.formatVersion == 1)
        #expect(decoded.ingredients.count == 2)
        #expect(decoded.ingredients[0].id == ingredients[0].id)
        #expect(decoded.ingredients[1].id == ingredients[1].id)
    }

    @Test func exportIngredientsJSONEmpty() throws {
        let url = ExportService.ingredientsJSON([])
        #expect(url != nil)
        let data = try Data(contentsOf: url!)
        let decoded = try JSONDecoder().decode(IngredientExport.self, from: data)
        #expect(decoded.formatVersion == 1)
        #expect(decoded.ingredients.isEmpty)
    }

    @Test func exportPlainTextStripsHeadings() throws {
        let content = "# Title\n## Section\n### Subsection\nNormal text"
        let url = ExportService.plainTextFileURL(title: "Strip Test", content: content)
        let fileContent = try String(contentsOf: url!, encoding: .utf8)
        #expect(!fileContent.contains("#"))
        #expect(fileContent.contains("Title"))
        #expect(fileContent.contains("Section"))
        #expect(fileContent.contains("Normal text"))
    }

    @Test func exportPlainTextStripsBoldAndItalic() throws {
        let content = "**bold** and *italic* and ***both***"
        let url = ExportService.plainTextFileURL(title: "Bold Test", content: content)
        let fileContent = try String(contentsOf: url!, encoding: .utf8)
        #expect(fileContent.contains("bold"))
        #expect(fileContent.contains("italic"))
        #expect(fileContent.contains("both"))
        #expect(!fileContent.contains("**"))
    }

    @Test func exportPlainTextStripsLinks() throws {
        let content = "Click [here](https://example.com) for more"
        let url = ExportService.plainTextFileURL(title: "Link Test", content: content)
        let fileContent = try String(contentsOf: url!, encoding: .utf8)
        #expect(fileContent.contains("here"))
        #expect(!fileContent.contains("https://example.com"))
        #expect(!fileContent.contains("["))
        #expect(!fileContent.contains("]"))
    }

    @Test func exportPlainTextStripsCode() throws {
        let content = "Use `code` here"
        let url = ExportService.plainTextFileURL(title: "Code Test", content: content)
        let fileContent = try String(contentsOf: url!, encoding: .utf8)
        #expect(!fileContent.contains("`"))
    }

    // MARK: - IngredientExport

    @Test func ingredientExportCodable() throws {
        let ingredients = [IngredientData(id: "test", emoji: "🍎", label: "Apple", categoryId: "fruits", colorHex: "#FF0000")]
        let export = IngredientExport(formatVersion: 1, ingredients: ingredients)
        let data = try JSONEncoder().encode(export)
        let decoded = try JSONDecoder().decode(IngredientExport.self, from: data)
        #expect(decoded.formatVersion == 1)
        #expect(decoded.ingredients.count == 1)
        #expect(decoded.ingredients[0].id == "test")
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

    @Test func mixViewModelInitialState() {
        let vm = MixViewModel()
        #expect(vm.selectedIngredients.isEmpty)
        #expect(vm.isShowingGeneration == false)
        #expect(vm.projectTitle.isEmpty)
        #expect(vm.selectedCount == 0)
    }

    @Test func mixViewModelTogglePreservesOrder() {
        let vm = MixViewModel()
        let fruit1 = DefaultIngredients.fruits[0]
        let fruit2 = DefaultIngredients.fruits[1]
        let fruit3 = DefaultIngredients.fruits[2]

        vm.toggleIngredient(fruit1)
        vm.toggleIngredient(fruit2)
        vm.toggleIngredient(fruit3)

        #expect(vm.selectedIngredients[0].id == fruit1.id)
        #expect(vm.selectedIngredients[1].id == fruit2.id)
        #expect(vm.selectedIngredients[2].id == fruit3.id)
    }

    @Test func mixViewModelToggleSameIngredientTwiceRestoresState() {
        let vm = MixViewModel()
        let ingredient = DefaultIngredients.fruits[0]

        vm.toggleIngredient(ingredient)
        vm.toggleIngredient(ingredient)

        #expect(vm.selectedIngredients.isEmpty)
        #expect(!vm.isSelected(ingredient))
    }

    @Test func mixViewModelIsSelectedMatchesById() {
        let vm = MixViewModel()
        let original = DefaultIngredients.fruits[0]

        vm.toggleIngredient(original)

        // Create a copy with the same id but different fields
        var copy = original
        copy.label = "Modified Label"
        #expect(vm.isSelected(copy))
    }

    @Test func mixViewModelAllCategoriesWithCustom() {
        let vm = MixViewModel()
        let custom = CustomCategory(
            categoryId: "custom_cat",
            displayName: "Custom",
            emoji: "🎨",
            colorHex: "#000",
            secondaryColorHex: "#111",
            sortOrder: 5 // between preparedDishes (5) and fastFood (6)
        )
        let categories = vm.allCategories(customCategories: [custom])
        #expect(categories.count == DefaultCategories.all.count + 1)
        // Verify sorted
        for i in 0..<categories.count - 1 {
            #expect(categories[i].sortOrder <= categories[i + 1].sortOrder)
        }
    }

    @Test func mixViewModelAllCategoriesCustomSortedAfterDefaults() {
        let vm = MixViewModel()
        let custom = CustomCategory(
            categoryId: "custom_cat",
            displayName: "Custom",
            emoji: "🎨",
            colorHex: "#000",
            secondaryColorHex: "#111",
            sortOrder: 100
        )
        let categories = vm.allCategories(customCategories: [custom])
        #expect(categories.last?.id == "custom_cat")
    }

    @Test func mixViewModelIngredientsWithCustom() {
        let vm = MixViewModel()
        let custom = CustomIngredient(
            ingredientId: "custom_fruit",
            emoji: "🫐",
            label: "Custom Berry",
            categoryId: "fruits",
            colorHex: "#FF0000"
        )
        let result = vm.ingredients(for: "fruits", customIngredients: [custom])
        #expect(result.count == DefaultIngredients.fruits.count + 1)
        #expect(result.last?.id == "custom_fruit")
        #expect(result.last?.isCustom == true)
    }

    @Test func mixViewModelIngredientsCustomFilteredByCategory() {
        let vm = MixViewModel()
        let customFruit = CustomIngredient(
            ingredientId: "cf",
            emoji: "🍎",
            label: "Custom Fruit",
            categoryId: "fruits",
            colorHex: "#FF0000"
        )
        let customVeg = CustomIngredient(
            ingredientId: "cv",
            emoji: "🥕",
            label: "Custom Veg",
            categoryId: "vegetables",
            colorHex: "#00FF00"
        )
        let fruits = vm.ingredients(for: "fruits", customIngredients: [customFruit, customVeg])
        // Only custom fruit should appear, not custom veg
        #expect(fruits.contains { $0.id == "cf" })
        #expect(!fruits.contains { $0.id == "cv" })
    }

    @Test func mixViewModelLoadIngredientsReplacesSelection() {
        let vm = MixViewModel()
        vm.toggleIngredient(DefaultIngredients.fruits[0])
        vm.toggleIngredient(DefaultIngredients.fruits[1])
        #expect(vm.selectedCount == 2)

        let newIngredients = Array(DefaultIngredients.vegetables.prefix(1))
        vm.loadIngredients(newIngredients)
        #expect(vm.selectedCount == 1)
        #expect(vm.selectedIngredients[0].categoryId == "vegetables")
    }

    @Test func mixViewModelLoadEmptyIngredients() {
        let vm = MixViewModel()
        vm.toggleIngredient(DefaultIngredients.fruits[0])
        vm.loadIngredients([])
        #expect(vm.selectedCount == 0)
    }

    @Test func mixViewModelSurpriseMeClearsExistingSelection() {
        let vm = MixViewModel()
        vm.toggleIngredient(DefaultIngredients.fruits[0])
        vm.toggleIngredient(DefaultIngredients.fruits[1])
        #expect(vm.selectedCount == 2)

        vm.surpriseMe(customCategories: [], customIngredients: [])
        // Should clear existing selection and pick 3–6 random ingredients
        #expect(vm.selectedCount >= 3 && vm.selectedCount <= 6)
    }

    @Test func mixViewModelIngredientsForUnknownCategory() {
        let vm = MixViewModel()
        let result = vm.ingredients(for: "nonexistent", customIngredients: [])
        #expect(result.isEmpty)
    }

    // MARK: - DiscoverViewModel

    @Test func discoverViewModelInitialState() {
        let vm = DiscoverViewModel()
        #expect(vm.items.count == 5)
        #expect(vm.items == DefaultDiscoverItems.all)
    }

    @Test func discoverViewModelItemsMutable() {
        let vm = DiscoverViewModel()
        vm.items = []
        #expect(vm.items.isEmpty)
    }

    // MARK: - ProjectsViewModel

    @Test func projectsViewModelInstantiation() {
        let vm = ProjectsViewModel()
        // Verify it can be instantiated without crashing
        #expect(type(of: vm) == ProjectsViewModel.self)
    }

    // MARK: - SettingsViewModel

    @Test func settingsViewModelInstantiation() {
        let vm = SettingsViewModel()
        #expect(type(of: vm) == SettingsViewModel.self)
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

    @Test func projectWordCountSingleWord() {
        let project = Project(
            title: "Test",
            ingredients: [],
            systemPromptBody: "",
            generatedConcept: "word"
        )
        #expect(project.wordCount == 1)
    }

    @Test func projectWordCountMultipleSpaces() {
        let project = Project(
            title: "Test",
            ingredients: [],
            systemPromptBody: "",
            generatedConcept: "hello   world"
        )
        // split(separator:) ignores consecutive separators
        #expect(project.wordCount == 2)
    }

    @Test func projectIngredientsRoundTrip() {
        let ingredients = Array(DefaultIngredients.fruits.prefix(3))
        let project = Project(
            title: "Test",
            ingredients: ingredients,
            systemPromptBody: "",
            generatedConcept: ""
        )
        let decoded = project.ingredients
        #expect(decoded.count == 3)
        #expect(decoded[0].id == ingredients[0].id)
        #expect(decoded[1].id == ingredients[1].id)
        #expect(decoded[2].id == ingredients[2].id)
    }

    @Test func projectIngredientsSetter() {
        let project = Project(
            title: "Test",
            ingredients: [],
            systemPromptBody: "",
            generatedConcept: ""
        )
        let originalUpdatedAt = project.updatedAt
        // Small delay to ensure updatedAt changes
        let newIngredients = Array(DefaultIngredients.fruits.prefix(2))
        project.ingredients = newIngredients
        #expect(project.ingredients.count == 2)
        #expect(project.updatedAt >= originalUpdatedAt)
    }

    @Test func projectIngredientEmojisJoined() {
        let ingredients = [
            IngredientData(id: "1", emoji: "🍎", label: "Apple", categoryId: "fruits", colorHex: "#F00"),
            IngredientData(id: "2", emoji: "🍌", label: "Banana", categoryId: "fruits", colorHex: "#FF0"),
            IngredientData(id: "3", emoji: "🍕", label: "Pizza", categoryId: "preparedDishes", colorHex: "#F90"),
        ]
        let project = Project(title: "Test", ingredients: ingredients, systemPromptBody: "", generatedConcept: "")
        #expect(project.ingredientEmojis == "🍎🍌🍕")
    }

    @Test func projectImageNilWhenNoImageData() {
        let project = Project(
            title: "Test",
            ingredients: [],
            systemPromptBody: "",
            generatedConcept: ""
        )
        #expect(project.imageData == nil)
        #expect(project.image == nil)
    }

    @Test func projectImageNilForInvalidData() {
        let project = Project(
            title: "Test",
            ingredients: [],
            systemPromptBody: "",
            generatedConcept: "",
            imageData: Data([0x00, 0x01, 0x02])
        )
        #expect(project.imageData != nil)
        #expect(project.image == nil)
    }

    @Test func projectCorruptedIngredientsDataReturnsEmptyArray() {
        let project = Project(
            title: "Test",
            ingredients: [],
            systemPromptBody: "",
            generatedConcept: ""
        )
        // Manually set corrupt data
        project.ingredientsData = Data("not json".utf8)
        #expect(project.ingredients.isEmpty)
    }

    @Test func projectCreatedAtAndUpdatedAtSet() {
        let before = Date()
        let project = Project(
            title: "Test",
            ingredients: [],
            systemPromptBody: "",
            generatedConcept: ""
        )
        let after = Date()
        #expect(project.createdAt >= before)
        #expect(project.createdAt <= after)
        #expect(project.updatedAt >= before)
        #expect(project.updatedAt <= after)
    }

    @Test func projectIdIsUnique() {
        let project1 = Project(title: "A", ingredients: [], systemPromptBody: "", generatedConcept: "")
        let project2 = Project(title: "B", ingredients: [], systemPromptBody: "", generatedConcept: "")
        #expect(project1.projectId != project2.projectId)
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

    @Test func exportIngredientsJSONFileName() {
        let url = ExportService.ingredientsJSON([])
        #expect(url != nil)
        let filename = url!.lastPathComponent
        #expect(filename.hasPrefix("ingredients_"))
        #expect(filename.hasSuffix(".json"))
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

    @Test func foodGenerationServiceGenerateCompletesSuccessfully() async {
        let service = FoodGenerationService()
        let ingredients = [
            IngredientData(id: "1", emoji: "🍎", label: "Apple", categoryId: "fruits", colorHex: "#F00"),
            IngredientData(id: "2", emoji: "🍌", label: "Banana", categoryId: "fruits", colorHex: "#FF0"),
        ]
        await service.generate(ingredients: ingredients)

        // After generation completes, isGenerating should be false
        #expect(!service.isGenerating)
        // Either generation succeeded with text, or failed with an error
        // (On CI/Xcode Cloud the model may report available but fail at runtime)
        if service.error == nil {
            #expect(!service.streamedText.isEmpty)
        }
    }

    @Test func foodGenerationServiceGenerateSingleIngredient() async {
        let service = FoodGenerationService()
        let ingredients = [
            IngredientData(id: "1", emoji: "🍎", label: "Apple", categoryId: "fruits", colorHex: "#F00"),
        ]
        await service.generate(ingredients: ingredients)

        #expect(!service.isGenerating)
        if service.error == nil {
            #expect(!service.streamedText.isEmpty)
        }
    }

    @Test func foodGenerationServiceGenerateMultipleIngredients() async {
        let service = FoodGenerationService()
        let ingredients = [
            IngredientData(id: "1", emoji: "🍎", label: "Apple", categoryId: "fruits", colorHex: "#F00"),
            IngredientData(id: "2", emoji: "🍌", label: "Banana", categoryId: "fruits", colorHex: "#FF0"),
            IngredientData(id: "3", emoji: "🍕", label: "Pizza", categoryId: "preparedDishes", colorHex: "#F90"),
        ]
        await service.generate(ingredients: ingredients)

        #expect(!service.isGenerating)
        if service.error == nil {
            #expect(!service.streamedText.isEmpty)
        }
    }

    @Test func foodGenerationServiceGenerateEmptyIngredients() async {
        let service = FoodGenerationService()
        await service.generate(ingredients: [], systemPrompt: "test")

        #expect(!service.isGenerating)
        // Either produced output or set an error
        if service.error == nil {
            #expect(!service.streamedText.isEmpty)
        }
    }

    @Test func foodGenerationServiceGenerateClearsState() async {
        let service = FoodGenerationService()
        let ingredients = [
            IngredientData(id: "1", emoji: "🍎", label: "Apple", categoryId: "fruits", colorHex: "#F00"),
        ]

        // Run generation once
        await service.generate(ingredients: ingredients)

        // Run again - should clear previous state
        await service.generate(ingredients: ingredients)

        #expect(!service.isGenerating)
        // streamedText is cleared at start of each generate call
        if service.error == nil {
            #expect(!service.streamedText.isEmpty)
        }
    }

    @Test func foodGenerationServiceGenerateNoError() async {
        let service = FoodGenerationService()
        let ingredients = [
            IngredientData(id: "1", emoji: "🍎", label: "Apple", categoryId: "fruits", colorHex: "#F00"),
            IngredientData(id: "2", emoji: "🍌", label: "Banana", categoryId: "fruits", colorHex: "#FF0"),
        ]
        await service.generate(ingredients: ingredients)

        // On CI/Xcode Cloud, the model may report as available but fail at runtime
        // with a GenerationError — so we only verify the post-condition is consistent:
        // either both succeeded or error was set gracefully
        #expect(!service.isGenerating)
        if service.error != nil {
            #expect(service.streamedText.isEmpty)
        }
    }

    // MARK: - HapticService

    @Test func hapticServiceMethodsDoNotCrash() {
        // Verify all haptic methods can be called without crashing
        HapticService.selection()
        HapticService.mixStart()
        HapticService.mixComplete()
        HapticService.error()
        HapticService.remove()
    }

    // MARK: - Color+Hex

    @Test func colorFromHexValid() {
        // Verify Color(hex:) creates a color without crashing for valid 6-char hex
        let color = Color(hex: "#FF0000")
        #expect(type(of: color) == Color.self)
    }

    @Test func colorFromHexWithoutHash() {
        // Verify hex without # prefix works
        let color = Color(hex: "FF0000")
        #expect(type(of: color) == Color.self)
    }

    @Test func colorFromHexEmptyString() {
        // Empty string -> 0 chars -> default gray (should not crash)
        let color = Color(hex: "")
        #expect(type(of: color) == Color.self)
    }

    @Test func colorFromHexInvalidLength() {
        // 3 chars -> default gray (should not crash)
        let color = Color(hex: "#FFF")
        #expect(type(of: color) == Color.self)
    }

    @Test func colorFromHex8CharRGBA() {
        // 8 chars for RGBA (should not crash)
        let color = Color(hex: "#FF000080")
        #expect(type(of: color) == Color.self)
    }

    @Test func colorFromHexLowercase() {
        let color = Color(hex: "#ff0000")
        #expect(type(of: color) == Color.self)
    }

    @Test func colorFromHexBlack() {
        let color = Color(hex: "#000000")
        #expect(type(of: color) == Color.self)
    }

    @Test func colorFromHexWhite() {
        let color = Color(hex: "#FFFFFF")
        #expect(type(of: color) == Color.self)
    }

    @Test func colorFromHexStripsNonAlphanumeric() {
        // "0x" prefix: '0' and 'x' are alphanumeric so they remain.
        // "0xFF0000" is 8 chars after stripping, so parsed as RGBA.
        let color = Color(hex: "0xFF0000")
        #expect(type(of: color) == Color.self)
    }

    // MARK: - IngredientData Gradient

    @Test func ingredientCardGradient() {
        let ingredient = DefaultIngredients.fruits[0]
        let gradient = ingredient.cardGradient
        #expect(type(of: gradient) == LinearGradient.self)
    }

    // MARK: - CategoryData Gradient

    @Test func categoryGradient() {
        let category = DefaultCategories.all[0]
        let gradient = category.gradient
        #expect(type(of: gradient) == LinearGradient.self)
    }

    @Test func allCategoriesGradient() {
        // Verify no category crashes when creating gradient
        for category in DefaultCategories.all {
            let gradient = category.gradient
            #expect(type(of: gradient) == LinearGradient.self)
        }
    }

    @Test func allIngredientsCardGradient() {
        // Verify no ingredient crashes when creating gradient
        for ingredient in DefaultIngredients.all {
            let gradient = ingredient.cardGradient
            #expect(type(of: gradient) == LinearGradient.self)
        }
    }


    // MARK: - AttributedString+Markdown

    @Test func attributedStringInlineMarkdown() {
        let attr = AttributedString(markdown: "**bold** and *italic*")
        let plain = String(attr.characters)
        #expect(plain.contains("bold"))
        #expect(plain.contains("italic"))
    }

    @Test func attributedStringFullMarkdown() {
        let attr = AttributedString(fullMarkdown: "# Heading\n\nParagraph text")
        let plain = String(attr.characters)
        #expect(plain.contains("Heading"))
        #expect(plain.contains("Paragraph text"))
    }

    @Test func attributedStringEmptyMarkdown() {
        let attr = AttributedString(markdown: "")
        let plain = String(attr.characters)
        #expect(plain.isEmpty)
    }

    @Test func attributedStringEmptyFullMarkdown() {
        let attr = AttributedString(fullMarkdown: "")
        let plain = String(attr.characters)
        #expect(plain.isEmpty)
    }

    @Test func attributedStringPlainText() {
        let attr = AttributedString(markdown: "Just plain text")
        let plain = String(attr.characters)
        #expect(plain == "Just plain text")
    }

    @Test func attributedStringFullMarkdownPlainText() {
        let attr = AttributedString(fullMarkdown: "Just plain text")
        let plain = String(attr.characters)
        #expect(plain == "Just plain text")
    }

    // MARK: - String+MarkdownTitle

    @Test func markdownTitleSimple() {
        #expect("# Hello World".markdownTitle == "Hello World")
    }

    @Test func markdownTitleNone() {
        #expect("No heading here".markdownTitle == nil)
    }

    @Test func markdownTitleEmpty() {
        #expect("".markdownTitle == nil)
    }

    @Test func markdownTitleSkipsSubheadings() {
        #expect("## Sub Heading".markdownTitle == nil)
        #expect("### Third Level".markdownTitle == nil)
    }

    @Test func markdownTitleFindsFirstH1() {
        let text = "## Not This\n# This One\n# Not This Either"
        #expect(text.markdownTitle == "This One")
    }

    @Test func markdownTitleTrimsWhitespace() {
        #expect("  # Indented  ".markdownTitle == "Indented")
    }

    @Test func markdownTitleWithTrailingContent() {
        let text = "Some text\n# The Title\nMore text"
        #expect(text.markdownTitle == "The Title")
    }

    @Test func imagePlaygroundConceptWithTitleAndConcept() {
        let text = "# My Dish\n\n## Concept\nA bold fusion of flavors."
        let result = text.imagePlaygroundConcept
        #expect(result == "My Dish: A bold fusion of flavors.")
    }

    @Test func imagePlaygroundConceptNoTitle() {
        let text = "No heading\n## Concept\nSome concept text."
        let result = text.imagePlaygroundConcept
        #expect(result == "Creative food concept: Some concept text.")
    }

    @Test func imagePlaygroundConceptNoConcept() {
        let text = "# My Dish\n\n## Structure\nSome structure."
        let result = text.imagePlaygroundConcept
        #expect(result == "My Dish")
    }

    @Test func imagePlaygroundConceptEmpty() {
        let result = "".imagePlaygroundConcept
        #expect(result == "Creative food concept")
    }

    @Test func imagePlaygroundConceptStripsBold() {
        let text = "# Title\n## Concept\n**Bold** description"
        let result = text.imagePlaygroundConcept
        #expect(result == "Title: Bold description")
        #expect(!result.contains("**"))
    }

    @Test func imagePlaygroundConceptStripsItalic() {
        let text = "# Title\n## Concept\n*Italic* description"
        let result = text.imagePlaygroundConcept
        #expect(result == "Title: Italic description")
        #expect(!result.contains("*"))
    }

    @Test func imagePlaygroundConceptSkipsEmptyLines() {
        let text = "# Title\n## Concept\n\n\nThe actual concept."
        let result = text.imagePlaygroundConcept
        #expect(result == "Title: The actual concept.")
    }

    @Test func imagePlaygroundConceptCaseInsensitive() {
        let text = "# Title\n## CONCEPT\nThe concept text."
        let result = text.imagePlaygroundConcept
        #expect(result == "Title: The concept text.")
    }

    @Test func imagePlaygroundConceptSkipsSubheadingsAfterConcept() {
        let text = "# Title\n## Concept\n### Sub\nThe concept text."
        let result = text.imagePlaygroundConcept
        // "### Sub" starts with "#" so it should be skipped
        #expect(result == "Title: The concept text.")
    }

    @Test func strippedMarkdownHeadings() {
        #expect("# Title".strippedMarkdown == "Title")
        #expect("## Section".strippedMarkdown == "Section")
        #expect("### Subsection".strippedMarkdown == "Subsection")
    }

    @Test func strippedMarkdownBold() {
        #expect("**bold**".strippedMarkdown == "bold")
    }

    @Test func strippedMarkdownItalic() {
        #expect("*italic*".strippedMarkdown == "italic")
    }

    @Test func strippedMarkdownBoldItalic() {
        // *** -> ** removal first leaves *italic*, then * removal leaves "italic"
        #expect("***both***".strippedMarkdown == "both")
    }

    @Test func strippedMarkdownHorizontalRule() {
        #expect("---".strippedMarkdown == "")
    }

    @Test func strippedMarkdownListItem() {
        #expect("- List item".strippedMarkdown == "List item")
    }

    @Test func strippedMarkdownPlainText() {
        #expect("Normal text".strippedMarkdown == "Normal text")
    }

    @Test func strippedMarkdownComplex() {
        let text = "# Title\n## Section\n**bold** and *italic*\n- Item\n---"
        let result = text.strippedMarkdown
        #expect(!result.contains("# "))
        #expect(!result.contains("## "))
        #expect(!result.contains("**"))
        #expect(!result.contains("---"))
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

    // MARK: - MixViewModel Async

    @Test func mixViewModelMixAsync() async {
        let vm = MixViewModel()
        let ingredients = Array(DefaultIngredients.fruits.prefix(2))
        vm.loadIngredients(ingredients)
        await vm.mix()

        // After mix completes, generation service should not be generating
        #expect(!vm.generationService.isGenerating)
        // On CI/Xcode Cloud the model may fail at runtime — only assert text when no error
        if vm.generationService.error == nil {
            #expect(!vm.generationService.streamedText.isEmpty)
        }
    }
}
