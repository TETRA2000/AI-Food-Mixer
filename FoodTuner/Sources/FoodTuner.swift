import ArgumentParser

@main
struct FoodTuner: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "food-tuner",
        abstract: "Test and iterate on AI Food Mixer system prompts and ingredients.",
        subcommands: [
            ListCategories.self,
            ListIngredients.self,
            ShowPrompts.self,
            BuildPrompt.self,
            ValidateIds.self,
            AddCategory.self,
            AddIngredient.self,
            Generate.self,
        ]
    )
}
