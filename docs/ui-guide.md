# UI Guide

## Visual Identity

| Property | Value |
|----------|-------|
| Theme | Warm, appetizing, kitchen-inspired |
| Primary color | Warm orange `#FF922B` |
| Secondary color | Rich red `#E03131` |
| Accent | Golden yellow `#FCC419` |
| Corner radius | 16pt (cards), 20pt (bowl), 12pt (buttons) |
| Emoji size | 36pt on ingredient cards |
| Font | System fonts throughout |

## Tab Bar

| Tab | System Image | Label |
|-----|-------------|-------|
| Mix | `frying.pan` | Mix |
| Creations | `list.clipboard` | Creations |
| Discover | `lightbulb` | Discover |
| Settings | `gear` | Settings |

## Mix Tab

The primary screen for selecting ingredients and generating food concepts.

### Layout Structure

```
┌────────────────────────────────┐
│  AI Food Mixer         [dice] │  Navigation bar + Surprise Me
├────────────────────────────────┤
│  🍎 Fruits (2)                │  Category header with count
│  [🍌][🍓][🍍][🥭]→           │  Horizontal scroll (LazyHStack)
│                                │
│  🥦 Vegetables (0)            │
│  [🥑][🌽][🧄][🥕]→           │
│  ...                           │
├────────────────────────────────┤
│  🥘 Mixing Bowl (3)     [▼]  │  Collapsible container
│    🍌 Banana  ✕               │  Ingredient chips with remove
│    🍓 Strawberry  ✕           │
├────────────────────────────────┤
│      [ 🍳 Mix 3 Items ]      │  Action button (pulsing glow)
└────────────────────────────────┘
```

### Component Details

- **IngredientCard**: 100x120pt, gradient background, emoji at 36pt, label below, checkmark overlay when selected, spring animation on selection, GPU-accelerated via `drawingGroup()`.
- **CategoryRow**: Category emoji + name header with selected count badge, horizontal `ScrollView` with `LazyHStack` and `scrollTargetBehavior(.viewAligned)`.
- **MixingBowlView**: Collapsible with `.ultraThinMaterial` background, ingredient chips with remove buttons, "Clear All" option.
- **MixButton**: Full-width gradient button, pulsing shadow animation, disabled state when no ingredients selected.

### Haptic Feedback

| Event | Haptic Type |
|-------|-------------|
| Ingredient tap | Light impact |
| Mix start | Medium impact |
| Mix complete | Success notification |
| Generation error | Error notification |
| Ingredient removal | Rigid impact (0.5 intensity) |

## Generation View

Full-screen modal (`fullScreenCover`) displaying streaming Markdown output:

- Progress indicator during generation
- Markdown rendering via `AttributedString`
- Toolbar actions: Close, Share, Save
- Save dialog with editable name
- Error state with retry button

## Projects Tab

- List view with `@Query` sorted by `updatedAt` descending
- `ProjectRowView`: title, emoji strip (first 8), word count, date
- `ProjectDetailView`: ingredient flow layout, Markdown concept, share/remix/delete actions
- Empty state: `ContentUnavailableView`

## Discover Tab

- `LazyVStack` of `DiscoverCardView` items
- Card: emoji strip, title, description (2-line limit)
- Detail view: ingredient flow layout, "Try This Mix" button, full concept preview

## Settings Tab

- Grouped `List` with two sections:
  - **Customisation**: Ingredient & Category manager
  - **About**: Version and platform info

## Accessibility

All interactive elements include accessibility labels and hints:

- `IngredientCard`: label with ingredient name, hint for add/remove, selected trait
- `MixButton`: dynamic label with ingredient count
- `MixingBowlView`: label with count, expand/collapse hint
- `IngredientChip`: combined element with remove action label
- `CategoryRow`: combined header with selection count
- `DiscoverCardView`: combined label with title and description
- `ProjectRowView`: combined label with title and word count
- `ProjectDetailView`: labeled toolbar buttons (Share, Remix, Delete)
- `DiscoverDetailView`: "Try This Mix" button with ingredient count
