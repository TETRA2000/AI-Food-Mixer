# Architecture

## Overview

AI Food Mixer follows the **MVVM (Model-View-ViewModel)** architecture pattern using Swift's `@Observable` macro for reactive state management and **SwiftData** for on-device persistence.

## Layer Diagram

```
┌─────────────────────────────────────┐
│             Views (SwiftUI)         │
│  Mix │ Projects │ Discover │ Settings│
├─────────────────────────────────────┤
│           ViewModels (@Observable)  │
│  MixVM │ ProjectsVM │ DiscoverVM   │
│              SettingsVM             │
├─────────────────────────────────────┤
│             Services                │
│  FoodGenerationService              │
│  ExportService │ HapticService      │
├─────────────────────────────────────┤
│           Data Layer                │
│  SwiftData Models (Project, Custom*)│
│  Value Types (IngredientData, etc.) │
│  Default Data (Categories, etc.)    │
├─────────────────────────────────────┤
│        Apple Foundation Model       │
│         (iOS 26+, on-device)        │
└─────────────────────────────────────┘
```

## Key Patterns

### Reactive State with @Observable

All ViewModels use Swift's `@Observable` macro instead of `ObservableObject`/`@Published`. This provides automatic observation tracking without explicit property wrappers:

```swift
@Observable
final class MixViewModel {
    var selectedIngredients: [IngredientData] = []
    var isShowingGeneration = false
}
```

### Value Types vs. Persisted Models

The app uses a dual-type strategy:

- **Value types** (`IngredientData`, `CategoryData`) — used in-memory for UI rendering, passed around freely, stored as JSON inside `Project`.
- **SwiftData models** (`CustomIngredient`, `CustomCategory`, `Project`) — persisted to disk, queried via `@Query`.

This avoids coupling the UI to the persistence layer while keeping serialization simple.

### Tab-Based Navigation

`MainTabView` owns a shared `MixViewModel` and distributes a `remix` callback to the Projects and Discover tabs, enabling cross-tab ingredient loading:

```swift
struct MainTabView: View {
    @State private var mixViewModel = MixViewModel()
    @State private var selectedTab = 0

    private func remix(_ ingredients: [IngredientData]) {
        mixViewModel.loadIngredients(ingredients)
        selectedTab = 0
    }
}
```

### Service Layer

- **FoodGenerationService** — wraps Apple's FoundationModels framework with streaming support and a simulator fallback.
- **ExportService** — stateless utility (enum) for writing Markdown, plain text, and JSON to temporary files.
- **HapticService** — stateless utility (enum) for UIKit haptic feedback patterns.

## Project Structure

```
AI Food Mixer/
├── Models/       # Value types + SwiftData models
├── Data/         # Default categories, ingredients, prompts, discover items
├── Services/     # Generation, export, haptics
├── ViewModels/   # @Observable view models
├── Views/        # SwiftUI views organized by tab
│   ├── Mix/
│   ├── Projects/
│   ├── Discover/
│   ├── Settings/
│   └── Shared/
└── Extensions/   # Color+Hex, AttributedString+Markdown
```

## Dependencies

- **iOS app**: Zero external dependencies. Uses only Apple frameworks (SwiftUI, SwiftData, FoundationModels, UIKit).
- **CLI tool (FoodTuner)**: [swift-argument-parser](https://github.com/apple/swift-argument-parser) for command-line parsing. Shares model files with the iOS app via Swift Package Manager.
