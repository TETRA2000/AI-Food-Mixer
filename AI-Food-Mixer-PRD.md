# AI Food Mixer — Product Requirements Document

## 1. Overview

**AI Food Mixer** is a native iOS app that transforms food creativity into a tap-driven mixing experience. Users select food emoji "ingredient" cards from curated categories, and the app generates a creative new food concept — complete with a name, description, layered structure, and serving suggestion — using Apple's on-device Foundation Model. No keyboard required.

### PoC Example

**Input**: 🍕 Pizza × 🍛 Curry × 🍰 Cake

**Output**: "Curry Lava Pizza Cake" — A three-layered savory-sweet masterpiece with a pizza crust base, curry lava filling with melted mozzarella, and a savory cake glaze topped with whipped mashed potato "icing," pepperoni, basil, and curry drizzle. Cutting in releases warm, gooey curry and cheese like a lava cake.

---

## 2. Goals

| Goal | Metric |
|------|--------|
| Make food creativity effortless | Users can generate a new food concept in under 30 seconds |
| Encourage serendipity | "Surprise Me" random picks lead to unexpected, delightful combos |
| On-device & private | Zero network calls — all generation via Apple Foundation Model |
| Iterate fast | CLI tool enables prompt tuning without rebuilding the app |

### Non-Goals

- Recipe generation with exact measurements/cooking instructions (this is creative ideation, not a cookbook)
- Nutritional analysis or calorie tracking
- Social features or sharing to food platforms
- Reverse food analysis (decomposing a dish into emoji ingredients)
- AI-powered ingredient suggestions based on current selection

---

## 3. Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Swift |
| UI | SwiftUI |
| Data | SwiftData (on-device, no cloud) |
| AI | Apple Foundation Model (iOS 26+, on-device only) |
| Architecture | MVVM with `@Observable` macros |
| Dependencies | None for iOS app; [swift-argument-parser](https://github.com/apple/swift-argument-parser) for CLI |

---

## 4. Target Users

- **Foodies & home cooks** looking for creative meal inspiration
- **Content creators** seeking novel food concepts for videos/posts
- **Kids & families** having fun imagining impossible food mashups
- **Chefs & food designers** brainstorming fusion dish ideas

---

## 5. Core Features

### 5.1 Easy Mixup (Mix Tab)

The primary screen. Users browse food emoji cards organized by category, tap to select ingredients, and hit "Mix" to generate a new food concept.

**Flow:**
1. User scrolls through horizontally-scrollable category rows
2. Taps ingredient cards to add/remove from the Mixing Bowl
3. Mixing Bowl shows selected items with count badge (collapsible)
4. Taps the "Mix" button to start on-device generation
5. Full-screen GenerationView streams the result in real-time (Markdown)
6. User can save, share, or dismiss the result

**UI Components:**
- `MixView` — Main mixing interface with LazyVStack of CategoryRows
- `CategoryRow` — Horizontal scroll of IngredientCards per category
- `IngredientCard` — 100×120pt card with emoji (size 36), label, gradient background, selection state
- `MixingBowlView` — Collapsible container of selected ingredients with clear/remove controls
- `MixButton` — Large action button showing ingredient count, disabled when empty
- `GenerationView` — Full-screen streaming output with save/share/retry actions

**Haptic Feedback:**
- Light impact on ingredient tap
- Medium impact on mix start
- Success notification on completion
- Error notification on failure
- Rigid impact on ingredient removal

### 5.2 Random Selection ("Surprise Me")

One-tap random ingredient selection accessible via toolbar button.

**Behavior:**
1. Clears current selection
2. Iterates through all categories (sorted by sortOrder)
3. Picks one random ingredient from each category via `.randomElement()`
4. Adds all to selectedIngredients
5. Triggers haptic feedback

Guarantees diversity — one ingredient per category in every random mix.

### 5.3 Categorization

All food emojis organized into intuitive culinary categories. Each category has a distinct emoji icon, color scheme, and sort order.

**Default Categories (10):**

| # | Category | Emoji | Color | Description |
|---|----------|-------|-------|-------------|
| 0 | Fruits | 🍎 | #FF6B6B | Fresh fruits and berries |
| 1 | Vegetables | 🥦 | #51CF66 | Vegetables, legumes, and greens |
| 2 | Grains & Bread | 🍞 | #D4A574 | Breads, cereals, and grain-based foods |
| 3 | Protein & Meat | 🥩 | #E03131 | Meats, poultry, and protein sources |
| 4 | Seafood | 🦐 | #F08C5A | Fish, shellfish, and ocean foods |
| 5 | Prepared Dishes | 🍛 | #FF922B | Cooked meals, bowls, and cuisines |
| 6 | Fast Food & Snacks | 🍔 | #FCC419 | Quick bites, street food, and snacks |
| 7 | Desserts & Sweets | 🍰 | #F06595 | Cakes, candies, and sweet treats |
| 8 | Drinks & Beverages | 🍹 | #845EF7 | Hot drinks, cold drinks, and alcohol |
| 9 | Condiments & Extras | 🧂 | #868E96 | Sauces, seasonings, and toppings |

### 5.4 Default Food Emoji Ingredients

All food-related emojis available on latest iOS, organized by category:

**Fruits (19)**
| Emoji | Label |
|-------|-------|
| 🍇 | Grapes |
| 🍈 | Melon |
| 🍉 | Watermelon |
| 🍊 | Tangerine |
| 🍋 | Lemon |
| 🍋‍🟩 | Lime |
| 🍌 | Banana |
| 🍍 | Pineapple |
| 🥭 | Mango |
| 🍎 | Red Apple |
| 🍏 | Green Apple |
| 🍐 | Pear |
| 🍑 | Peach |
| 🍒 | Cherries |
| 🍓 | Strawberry |
| 🫐 | Blueberries |
| 🥝 | Kiwi |
| 🍅 | Tomato |
| 🥥 | Coconut |

**Vegetables (18)**
| Emoji | Label |
|-------|-------|
| 🥑 | Avocado |
| 🍆 | Eggplant |
| 🥔 | Potato |
| 🥕 | Carrot |
| 🌽 | Corn |
| 🌶️ | Hot Pepper |
| 🫑 | Bell Pepper |
| 🥒 | Cucumber |
| 🥬 | Leafy Green |
| 🥦 | Broccoli |
| 🧄 | Garlic |
| 🧅 | Onion |
| 🍄 | Mushroom |
| 🫛 | Pea Pod |
| 🫚 | Ginger |
| 🥜 | Peanuts |
| 🫘 | Beans |
| 🫒 | Olive |

**Grains & Bread (8)**
| Emoji | Label |
|-------|-------|
| 🍞 | Bread |
| 🥖 | Baguette |
| 🫓 | Flatbread |
| 🥨 | Pretzel |
| 🥯 | Bagel |
| 🥞 | Pancakes |
| 🧇 | Waffle |
| 🍚 | Rice |

**Protein & Meat (5)**
| Emoji | Label |
|-------|-------|
| 🥩 | Cut of Meat |
| 🍖 | Meat on Bone |
| 🍗 | Poultry Leg |
| 🥓 | Bacon |
| 🥚 | Egg |

**Seafood (7)**
| Emoji | Label |
|-------|-------|
| 🦐 | Shrimp |
| 🦞 | Lobster |
| 🦀 | Crab |
| 🦑 | Squid |
| 🦪 | Oyster |
| 🐟 | Fish |
| 🍤 | Fried Shrimp |

**Prepared Dishes (18)**
| Emoji | Label |
|-------|-------|
| 🍕 | Pizza |
| 🍝 | Spaghetti |
| 🍜 | Steaming Bowl |
| 🍲 | Pot of Food |
| 🍛 | Curry Rice |
| 🍣 | Sushi |
| 🍱 | Bento Box |
| 🥟 | Dumpling |
| 🍘 | Rice Cracker |
| 🍙 | Rice Ball |
| 🍥 | Fish Cake |
| 🥠 | Fortune Cookie |
| 🥡 | Takeout Box |
| 🥗 | Green Salad |
| 🥣 | Bowl with Spoon |
| 🫕 | Fondue |
| 🥘 | Shallow Pan of Food |
| 🧆 | Falafel |

**Fast Food & Snacks (10)**
| Emoji | Label |
|-------|-------|
| 🍔 | Hamburger |
| 🍟 | French Fries |
| 🌭 | Hot Dog |
| 🌮 | Taco |
| 🌯 | Burrito |
| 🫔 | Tamale |
| 🥙 | Stuffed Flatbread |
| 🥪 | Sandwich |
| 🍿 | Popcorn |
| 🧂 | Salt |

**Desserts & Sweets (13)**
| Emoji | Label |
|-------|-------|
| 🍰 | Shortcake |
| 🎂 | Birthday Cake |
| 🧁 | Cupcake |
| 🥧 | Pie |
| 🍫 | Chocolate Bar |
| 🍬 | Candy |
| 🍭 | Lollipop |
| 🍮 | Custard |
| 🍩 | Doughnut |
| 🍪 | Cookie |
| 🍦 | Soft Ice Cream |
| 🍧 | Shaved Ice |
| 🍨 | Ice Cream |

**Drinks & Beverages (16)**
| Emoji | Label |
|-------|-------|
| ☕ | Hot Beverage |
| 🍵 | Teacup |
| 🫖 | Teapot |
| 🍶 | Sake |
| 🍾 | Bottle with Popping Cork |
| 🍷 | Wine Glass |
| 🍸 | Cocktail Glass |
| 🍹 | Tropical Drink |
| 🍺 | Beer Mug |
| 🍻 | Clinking Beer Mugs |
| 🥂 | Clinking Glasses |
| 🥃 | Tumbler Glass |
| 🧃 | Beverage Box |
| 🥤 | Cup with Straw |
| 🧋 | Bubble Tea |
| 🫗 | Pouring Liquid |

**Condiments & Extras (7)**
| Emoji | Label |
|-------|-------|
| 🧈 | Butter |
| 🥫 | Canned Food |
| 🫙 | Jar |
| 🍯 | Honey Pot |
| 🥄 | Spoon |
| 🧊 | Ice |
| 🫕 | Fondue |

**Total: ~121 food emojis across 10 categories**

### 5.5 Projects (Projects Tab)

Saved food creations for later viewing, sharing, or remixing.

- List of saved projects sorted by most recent
- Each row shows: title, ingredient emojis, creation date, word count
- Tap to view full generated concept in Markdown
- Swipe to delete with confirmation
- "Remix" button reloads ingredients into the mixer for iteration
- Share as Markdown (.md) or plain text (.txt)
- Export ingredients as JSON

### 5.6 Discover (Discover Tab)

Pre-curated food mashup examples to inspire users.

**Default Discover Items (examples):**

| Name | Ingredients | Preview |
|------|-------------|---------|
| Curry Lava Pizza Cake | 🍕🍛🍰 | Three-layered savory-sweet masterpiece... |
| Sushi Taco Fusion | 🍣🌮🥑 | Nori-wrapped taco shells with sashimi filling... |
| Breakfast Ramen Bowl | 🥞🍜🥓🥚 | Pancake noodles in maple-miso broth with bacon... |
| Dessert Burger | 🍔🍩🍦🍫 | Doughnut buns with ice cream patty and chocolate sauce... |
| Mediterranean Dumpling | 🥟🫒🧆🥗 | Olive oil-infused wrappers with falafel filling... |

Each item shows full ingredient list and a preview of the generated concept. "Try This Mix" button loads ingredients into the mixer.

### 5.7 Settings (Settings Tab)

#### Custom Ingredients & Categories
- View all built-in categories and their ingredients (read-only)
- Create custom categories with name, emoji, and color scheme
- Create custom ingredients assigned to any category
- Edit and delete custom categories/ingredients
- Custom items merge with defaults at runtime

#### System Prompt Management
- View and edit the default generation prompt
- Create custom system prompts for different generation styles
- Only one prompt purpose: `.generation` (food concept generation)
- Built-in prompts are non-deletable

---

## 6. Generation System

### 6.1 System Prompt

The generation prompt instructs the Foundation Model to create a food concept from selected emoji ingredients. The output follows a fixed template:

```
# [Creative Food Name]

## Concept
[1-2 sentence elevator pitch of the dish]

## Structure
[Layered breakdown of how the dish is constructed, referencing each input ingredient]

### Layer 1: [Name]
- Description of this component
- How it incorporates [ingredient emoji]

### Layer 2: [Name]
...

## Flavor Profile
[Description of taste balance: sweet, savory, spicy, umami, etc.]

## Serving Suggestion
[How to present and eat the dish — the "wow" moment]

## Pairings
[2-3 recommended drink or side pairings with emoji]
```

**Prompt Rules:**
- 200–400 words
- Markdown format
- Creative but plausible name
- Must reference every selected ingredient
- Layered structure that explains how ingredients combine
- End with a surprising or delightful serving suggestion
- Tone: playful, enthusiastic, food-magazine style

### 6.2 User Prompt Format

```
Selected ingredients:
- 🍕 Pizza (preparedDishes)
- 🍛 Curry Rice (preparedDishes)
- 🍰 Shortcake (desserts)
```

### 6.3 Streaming

Generation uses `LanguageModelSession` for real-time streaming. Text appears progressively in the GenerationView as the model produces tokens.

### 6.4 Simulator Fallback

On simulator (no Foundation Model), use placeholder generation with simulated streaming delay to enable UI development without a device.

---

## 7. Data Model

### Value Types (used in views, services, exports)

```swift
struct IngredientData: Codable, Identifiable, Hashable {
    let id: String          // e.g., "fruits_banana"
    let emoji: String       // "🍌"
    let label: String       // "Banana"
    let categoryId: String  // "fruits"
    let colorHex: String    // "#FCC419"
    let isCustom: Bool
}

struct CategoryData: Codable, Identifiable, Hashable {
    let id: String              // "fruits"
    let displayName: String     // "Fruits"
    let emoji: String           // "🍎"
    let colorHex: String        // "#FF6B6B"
    let secondaryColorHex: String
    let sortOrder: Int
    let isDefault: Bool
}
```

### SwiftData Models (persistence)

```swift
@Model class CustomIngredient { /* mirrors IngredientData */ }
@Model class CustomCategory   { /* mirrors CategoryData */ }

@Model class Project {
    var projectId: UUID
    var title: String
    var createdAt: Date
    var updatedAt: Date
    var ingredientsData: Data  // JSON-encoded [IngredientData]
    var systemPromptBody: String
    var generatedConcept: String  // the food concept markdown
}

@Model class SystemPrompt {
    var promptId: UUID
    var name: String
    var body: String
    var isDefault: Bool
}
```

### PromptPurpose

Only one purpose needed (no `.suggestion` or `.reverse`):

```swift
enum PromptPurpose: String, Codable {
    case generation  // Food concept generation
}
```

---

## 8. CLI Tool: Food Tuner

A macOS command-line tool for testing prompts and iterating on ingredients without rebuilding the iOS app. Shares the app's models via Swift Package Manager.

### Commands

| Command | Description |
|---------|-------------|
| `food-tuner list-categories` | List all categories (built-in + custom) |
| `food-tuner list-ingredients` | List all ingredients, optionally filtered by `--category` |
| `food-tuner show-prompts` | Display the system prompt template |
| `food-tuner build-prompt --ids "fruits_banana,desserts_cake,preparedDishes_curry"` | Build complete prompt from ingredient IDs |
| `food-tuner validate-ids --ids "..."` | Check if IDs are valid with fuzzy-match suggestions |
| `food-tuner add-ingredient --id "..." --label "..." --emoji "..." --category "..."` | Add custom ingredient to config |
| `food-tuner add-category --id "..." --name "..." --emoji "..."` | Add custom category to config |
| `food-tuner generate --ids "fruits_banana,desserts_cake"` | Generate food concept using on-device Foundation Model |

### Options

- `--custom-file <path>` — Path to custom_data.json (default: `~/.food-tuner/custom_data.json`)
- `--json` — Output in JSON format
- `--output <path>` — Write generation result to file
- `--system-prompt-file <path>` — Use custom system prompt from file

---

## 9. Project Structure

```
AI Food Mixer/
├── AI Food Mixer/
│   ├── AI_Food_MixerApp.swift          # App entry point
│   ├── Models/
│   │   ├── Ingredient.swift            # IngredientData value type
│   │   ├── IngredientCategory.swift    # CategoryData value type
│   │   ├── CustomIngredient.swift      # SwiftData model
│   │   ├── CustomCategory.swift        # SwiftData model
│   │   ├── Project.swift               # SwiftData model
│   │   ├── SystemPrompt.swift          # SwiftData model
│   │   ├── PromptPurpose.swift         # Generation-only enum
│   │   └── DiscoverItem.swift          # Pre-curated examples
│   ├── Data/
│   │   ├── DefaultCategories.swift     # 10 food categories
│   │   ├── DefaultIngredients.swift    # ~121 food emojis
│   │   ├── DefaultSystemPrompts.swift  # Generation prompt
│   │   └── DefaultDiscoverItems.swift  # Pre-curated mashups
│   ├── Services/
│   │   ├── FoodGenerationService.swift # On-device Foundation Model generation
│   │   ├── HapticService.swift         # Haptic feedback
│   │   └── ExportService.swift         # File export (md, txt, json)
│   ├── ViewModels/
│   │   ├── MixViewModel.swift          # Mix tab state
│   │   ├── ProjectsViewModel.swift     # Projects tab state
│   │   ├── DiscoverViewModel.swift     # Discover tab state
│   │   └── SettingsViewModel.swift     # Settings tab state
│   ├── Views/
│   │   ├── MainTabView.swift           # Tab navigation
│   │   ├── Mix/
│   │   │   ├── MixView.swift
│   │   │   ├── CategoryRow.swift
│   │   │   ├── IngredientCard.swift
│   │   │   ├── MixingBowlView.swift
│   │   │   ├── MixButton.swift
│   │   │   └── GenerationView.swift
│   │   ├── Projects/
│   │   │   ├── ProjectsListView.swift
│   │   │   ├── ProjectRowView.swift
│   │   │   └── ProjectDetailView.swift
│   │   ├── Discover/
│   │   │   ├── DiscoverView.swift
│   │   │   ├── DiscoverCardView.swift
│   │   │   └── DiscoverDetailView.swift
│   │   ├── Settings/
│   │   │   ├── SettingsView.swift
│   │   │   ├── IngredientManagerView.swift
│   │   │   ├── CategoryEditorView.swift
│   │   │   ├── IngredientEditorView.swift
│   │   │   ├── SystemPromptListView.swift
│   │   │   └── SystemPromptEditorView.swift
│   │   └── Shared/
│   │       ├── MarkdownView.swift
│   │       ├── ShareSheetView.swift
│   │       └── GradientStyle.swift
│   └── Extensions/
│       ├── Color+Hex.swift
│       └── AttributedString+Markdown.swift
├── AI Food MixerTests/
├── AI Food MixerUITests/
├── FoodTuner/
│   ├── Package.swift
│   └── Sources/
│       ├── FoodTuner.swift             # CLI entry point
│       ├── Commands/
│       │   ├── ListCategories.swift
│       │   ├── ListIngredients.swift
│       │   ├── ShowPrompts.swift
│       │   ├── BuildPrompt.swift
│       │   ├── ValidateIds.swift
│       │   ├── AddIngredient.swift
│       │   ├── AddCategory.swift
│       │   └── Generate.swift
│       └── Support/
│           ├── PromptAssembler.swift
│           ├── CustomDataStore.swift
│           └── OutputFormatter.swift
└── docs/
    ├── architecture.md
    ├── data-model.md
    ├── foundation-model-integration.md
    ├── ui-guide.md
    └── customization.md
```

---

## 10. UI Design

### Visual Identity

- **Theme**: Warm, appetizing, kitchen-inspired
- **Primary colors**: Warm orange (#FF922B) and rich red (#E03131)
- **Accent**: Golden yellow (#FCC419)
- **Cards**: Rounded corners with subtle food-category gradients
- **Typography**: System fonts, emoji displayed at 36pt on cards
- **Animation**: Subtle bounce on card selection, smooth streaming text

### Tab Bar

| Tab | Icon | Label |
|-----|------|-------|
| Mix | 🍳 | Mix |
| Projects | 📋 | Creations |
| Discover | 💡 | Discover |
| Settings | ⚙️ | Settings |

### Mix Tab Layout

```
┌────────────────────────────┐
│ 🍳 AI Food Mixer    [🎲]  │  ← Title + Surprise Me
├────────────────────────────┤
│ 🍎 Fruits (2)              │
│ [🍌][🍓][🍍][🥭]→         │  ← Horizontal scroll
│                            │
│ 🥦 Vegetables (0)          │
│ [🥑][🌽][🧄][🥕]→         │
│                            │
│ 🍛 Prepared Dishes (1)     │
│ [🍕][🍛][🍣][🍜]→         │
│ ...                        │
├────────────────────────────┤
│ 🥘 Mixing Bowl (3)    [▼]  │  ← Collapsible
│  🍌 Banana  ✕              │
│  🍓 Strawberry  ✕          │
│  🍛 Curry Rice  ✕          │
├────────────────────────────┤
│     [ 🍳 Mix 3 Items ]     │  ← Big action button
└────────────────────────────┘
```

---

## 11. Milestones

### M1: Foundation (Week 1–2)
- Xcode project setup with SwiftData
- Data models (Ingredient, Category, Project, SystemPrompt)
- Default data (10 categories, ~121 food emojis)
- Basic MixView with category rows and ingredient cards
- Ingredient selection with MixingBowl

### M2: Generation (Week 3)
- FoodGenerationService with Foundation Model integration
- System prompt for food concept generation
- GenerationView with streaming output
- Simulator fallback with placeholder content
- Save to Project

### M3: Full App (Week 4)
- Projects tab (list, detail, delete, share, remix)
- Discover tab with pre-curated examples
- Settings tab (custom ingredients, categories, prompts)
- Haptic feedback throughout
- Export service (Markdown, plain text, JSON)

### M4: CLI Tool (Week 5)
- FoodTuner CLI with swift-argument-parser
- All 8 commands (list, show, build, validate, add, generate)
- Shared models via SPM
- Custom data store (custom_data.json)

### M5: Polish & Testing (Week 6)
- Unit tests for models, services, and view models
- UI tests for core flows
- Accessibility audit
- Performance optimization for large emoji grids
- Documentation (architecture, data model, UI guide, customization)

---

## 12. Excluded Features

The following PRD Mixer features are explicitly **not included**:

| Feature | Reason |
|---------|--------|
| Reverse PRD / Reverse Food Analysis | Not needed — users start from emojis, not from existing dishes |
| Ingredient Suggestion | Not needed — the emoji set is intuitive enough for direct browsing |
| `.suggestion` prompt purpose | Removed along with ingredient suggestion |
| `.reverse` prompt purpose | Removed along with reverse analysis |
| `ReversePRDService` equivalent | Not implemented |
| `IngredientSuggestionService` equivalent | Not implemented |

---

## 13. Open Questions

1. **Emoji coverage**: Should we include non-food emojis that are cooking-related (🔪 knife, 🍽️ plate, 🥢 chopsticks) as a "Tools & Serving" category?
2. **Generation length**: Is 200–400 words the right target, or should food concepts be shorter/punchier than PRDs?
3. **Image generation**: Future phase — could we render the food concept as an AI-generated image?
4. **Sharing format**: Should we add a visual card format (image with emoji + concept name) for social sharing?
