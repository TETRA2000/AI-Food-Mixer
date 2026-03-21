// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "AIFoodMixerTools",
    platforms: [.macOS(.v26)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
    ],
    targets: [
        .executableTarget(
            name: "food-tuner",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: ".",
            exclude: [
                "AI Food Mixer.xcodeproj",
                "AI Food Mixer/Assets.xcassets",
                "AI Food Mixer/ContentView.swift",
                "AI Food Mixer/AI_Food_MixerApp.swift",
                "AI Food Mixer/Extensions",
                "AI Food Mixer/Services",
                "AI Food Mixer/ViewModels",
                "AI Food Mixer/Views",
                "AI Food Mixer/Models/DiscoverItem.swift",
                "AI Food Mixer/Models/Project.swift",
                "AI Food Mixer/Data/DefaultDiscoverItems.swift",
                "AI Food MixerTests",
                "AI Food MixerUITests",
                "AI-Food-Mixer-PRD.md",
            ],
            sources: [
                "AI Food Mixer/Models/Ingredient.swift",
                "AI Food Mixer/Models/IngredientCategory.swift",
                "AI Food Mixer/Models/PromptPurpose.swift",
                "AI Food Mixer/Models/SystemPrompt.swift",
                "AI Food Mixer/Data/DefaultCategories.swift",
                "AI Food Mixer/Data/DefaultIngredients.swift",
                "AI Food Mixer/Data/DefaultSystemPrompts.swift",
                "FoodTuner/Sources/",
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
    ]
)
