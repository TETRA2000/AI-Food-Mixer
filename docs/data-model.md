# Data Model

## Value Types (In-Memory)

### IngredientData

Represents a single food emoji ingredient card. Used in the UI and serialized as JSON inside `Project`.

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Unique identifier (e.g., `"fruits_banana"`) |
| `emoji` | `String` | Food emoji character |
| `label` | `String` | Display name |
| `categoryId` | `String` | Parent category identifier |
| `colorHex` | `String` | Card background color |
| `isCustom` | `Bool` | Whether user-created (default: `false`) |

### CategoryData

Represents an ingredient category with visual styling.

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Unique identifier (e.g., `"fruits"`) |
| `displayName` | `String` | Display name (e.g., `"Fruits"`) |
| `emoji` | `String` | Category icon emoji |
| `colorHex` | `String` | Primary color |
| `secondaryColorHex` | `String` | Gradient secondary color |
| `sortOrder` | `Int` | Display order |
| `isDefault` | `Bool` | Whether built-in (default: `true`) |

### DiscoverItem

Pre-curated food mashup example for the Discover tab.

| Property | Type | Description |
|----------|------|-------------|
| `id` | `UUID` | Unique identifier |
| `title` | `String` | Mashup name |
| `description` | `String` | Short description |
| `ingredients` | `[IngredientData]` | Ingredient list |
| `conceptPreview` | `String` | Full Markdown concept |

## SwiftData Models (Persisted)

### Project

Saved food concept with its ingredients and generation output.

| Property | Type | Description |
|----------|------|-------------|
| `projectId` | `UUID` | Unique identifier |
| `title` | `String` | User-provided or auto-generated name |
| `createdAt` | `Date` | Creation timestamp |
| `updatedAt` | `Date` | Last modification timestamp |
| `ingredientsData` | `Data` | JSON-encoded `[IngredientData]` |
| `systemPromptBody` | `String` | System prompt used for generation |
| `generatedConcept` | `String` | Markdown output from Foundation Model |

Computed properties: `ingredients` (decoded array), `ingredientEmojis` (string of emojis), `wordCount`.

### CustomIngredient

User-created ingredient persisted via SwiftData.

| Property | Type | Description |
|----------|------|-------------|
| `ingredientId` | `String` | Unique identifier |
| `emoji` | `String` | Emoji character |
| `label` | `String` | Display name |
| `categoryId` | `String` | Parent category |
| `colorHex` | `String` | Card color |

### CustomCategory

User-created category persisted via SwiftData.

| Property | Type | Description |
|----------|------|-------------|
| `categoryId` | `String` | Unique identifier |
| `displayName` | `String` | Display name |
| `emoji` | `String` | Category emoji |
| `colorHex` | `String` | Primary color |
| `secondaryColorHex` | `String` | Secondary color |
| `sortOrder` | `Int` | Display order |

## Default Data

| Data Set | Count | File |
|----------|-------|------|
| Categories | 10 | `DefaultCategories.swift` |
| Ingredients | ~120 | `DefaultIngredients.swift` |
| System Prompt | 1 (generation) | `DefaultSystemPrompts.swift` |
| Discover Items | 5 | `DefaultDiscoverItems.swift` |

The generation system prompt is defined as a static string in `DefaultSystemPrompts.generationPromptBody` and used directly by `FoodGenerationService`.
