# Customization Guide

## Custom Ingredients

Users can add their own food emoji ingredients via **Settings > Ingredient Categories**.

### Adding a Custom Ingredient

1. Navigate to Settings > Ingredient Categories
2. Select a category (or create a new one)
3. Tap "Add Ingredient"
4. Provide: emoji, label, and color

Custom ingredients appear alongside default ingredients in their assigned category on the Mix tab.

### Data Storage

Custom ingredients are persisted as `CustomIngredient` SwiftData models and converted to `IngredientData` value types at runtime:

```swift
// Conversion from persisted to value type
init(from custom: CustomIngredient) {
    self.id = custom.ingredientId
    self.emoji = custom.emoji
    self.label = custom.label
    self.categoryId = custom.categoryId
    self.colorHex = custom.colorHex
    self.isCustom = true
}
```

## Custom Categories

Users can create entirely new ingredient categories.

### Adding a Custom Category

1. Navigate to Settings > Ingredient Categories
2. Tap "Add Category"
3. Provide: display name, emoji, primary color, secondary color

Custom categories receive a `sortOrder` one higher than the current maximum, appearing at the bottom of the Mix tab. Deleting a custom category also removes all its custom ingredients.

## System Prompt Customization

The system prompt controls how the Foundation Model generates food concepts.

### Editing the System Prompt

1. Navigate to Settings > System Prompts
2. Select the "Food Concept Generation" prompt
3. Edit the prompt body
4. Changes take effect on the next generation

### Prompt Structure

The default prompt instructs the model to produce:

- A creative dish name (as a Markdown heading)
- A concept description
- Layered structure with ingredient roles
- Flavor profile analysis
- Serving suggestion
- Drink/side pairings

### Tips for Prompt Tuning

- Be specific about output format (Markdown headings, bullet points)
- Include examples of the tone you want (playful, technical, poetic)
- Mention dietary considerations if needed
- Use the FoodTuner CLI for rapid iteration without rebuilding the app

## FoodTuner CLI

The command-line tool enables rapid prompt and ingredient iteration:

```bash
# List all categories
food-tuner list-categories

# List ingredients, optionally filtered
food-tuner list-ingredients --category fruits

# Preview the system prompt
food-tuner show-prompts

# Build a complete prompt from ingredient IDs
food-tuner build-prompt --ids "fruits_banana,desserts_cake"

# Validate ingredient IDs (with fuzzy suggestions)
food-tuner validate-ids --ids "fruits_banan"

# Add custom ingredients/categories
food-tuner add-ingredient --id "custom_tofu" --label "Tofu" --emoji "🧈" --category "protein"
food-tuner add-category --id "spicy" --name "Spicy Foods" --emoji "🌶️"

# Generate a food concept directly
food-tuner generate --ids "fruits_banana,desserts_cake"
```

### Custom Data File

The CLI stores custom additions in `~/.food-tuner/custom_data.json`. Use `--custom-file <path>` to specify an alternate location.

### Output Formats

- Default: formatted text output
- `--json`: structured JSON output
- `--output <path>`: write generation results to a file

## Export Formats

Generated food concepts can be exported in three formats:

| Format | Extension | Description |
|--------|-----------|-------------|
| Markdown | `.md` | Original formatted output |
| Plain Text | `.txt` | Markdown syntax stripped |
| JSON | `.json` | Structured ingredient data |

Export is available from the Generation View (Share button) and Project Detail View (Share button in toolbar).
