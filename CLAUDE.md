# AI Food Mixer

## Overview

AI Food Mixer is a native iOS app that transforms food creativity into a tap-driven mixing experience. Users select food emoji "ingredient" cards from curated culinary categories, and the app generates a creative new food concept — complete with a name, layered structure, flavor profile, and serving suggestion — using Apple's on-device Foundation Model. An accompanying image is generated via Image Playground. No keyboard required.

## Tech Stack

- **Language**: Swift
- **UI**: SwiftUI
- **Data**: SwiftData (on-device, no cloud)
- **AI**: Apple Foundation Model (iOS 26+, on-device only)
- **Image**: Image Playground (iOS 26+, on-device)
- **Architecture**: MVVM with `@Observable` macros
- **Dependencies**: None for the iOS app (Apple frameworks only); [swift-argument-parser](https://github.com/apple/swift-argument-parser) for the CLI tool

## Project Structure

- `AI Food Mixer/Models/` — Data types (`IngredientData`, `CategoryData`) and SwiftData models (`Project`, `CustomIngredient`, `CustomCategory`, `SystemPrompt`)
- `AI Food Mixer/Data/` — Static default content (10 categories, ~120 food emoji ingredients, generation prompt, 5 discover items)
- `AI Food Mixer/Services/` — Business logic (`FoodGenerationService`, `ExportService`, `HapticService`)
- `AI Food Mixer/ViewModels/` — UI state management (`MixViewModel`, `ProjectsViewModel`, `DiscoverViewModel`, `SettingsViewModel`)
- `AI Food Mixer/Views/` — SwiftUI views organized by tab (Mix, Creations, Discover, Settings)
- `AI Food Mixer/Extensions/` — `Color+Hex`, `AttributedString+Markdown`
- `FoodTuner/Sources/` — Food Tuner CLI tool (macOS, shares app models via SPM)
- `docs/` — Architecture, data model, UI guide, foundation model integration, and customization docs

## Build & Run

Requires Xcode 26+ and iOS 26+ deployment target.

```bash
# Build iOS app
xcodebuild -scheme "AI Food Mixer" -configuration Debug

# Run tests
xcodebuild -scheme "AI Food Mixer" -destination generic/platform=iOS test

# Build and run Food Tuner CLI (macOS)
swift build --product food-tuner
swift run food-tuner --help
```

Foundation Model and Image Playground features require an Apple Silicon device. The simulator uses placeholder generation with simulated streaming.

## Key Concepts

- **Value types for defaults** — Built-in ingredients/categories are static `[IngredientData]`/`[CategoryData]` arrays, NOT SwiftData models. This avoids schema migration issues.
- **JSON blob storage** — `Project.ingredientsData` stores ingredients as encoded JSON `Data`, making projects self-contained.
- **Single PromptPurpose** — Only `.generation` exists (no `.suggestion` or `.reverse`).
- **Simulator fallback** — `FoodGenerationService` uses `#if canImport(FoundationModels)` to provide placeholder content on simulator.
- **Image generation** — `GenerationView` uses `#if canImport(ImagePlayground)` to generate food concept images on-device.

## Development Guidelines

- **Write tests**: All new features and bug fixes must include corresponding unit tests in `AI Food MixerTests/`. Add UI tests in `AI Food MixerUITests/` for user-facing flows. Run the full test suite before considering work complete.
- **Update docs**: When changing behavior, adding features, or modifying APIs, update the relevant docs in `docs/` (architecture.md, data-model.md, foundation-model-integration.md, ui-guide.md, customization.md) and this file as needed. Keep docs in sync with the code.
