# Foundation Model Integration

## Overview

AI Food Mixer uses Apple's on-device Foundation Model (available on iOS 26+) to generate creative food concepts from selected emoji ingredients. All generation happens locally with zero network calls.

## FoodGenerationService

The `FoodGenerationService` class manages the interaction with the Foundation Model:

```swift
@Observable
final class FoodGenerationService {
    var isGenerating = false
    var streamedText = ""
    var error: String?
}
```

### Generation Flow

1. User selects ingredients and taps "Mix"
2. `MixViewModel.mix()` calls `FoodGenerationService.generate()`
3. Service creates a `LanguageModelSession` with the system prompt as instructions
4. A user prompt is constructed listing all selected ingredients
5. The session streams the response, updating `streamedText` in real-time
6. The `GenerationView` renders the streaming Markdown output

### FoundationModels API Usage

```swift
#if canImport(FoundationModels)
import FoundationModels

let session = LanguageModelSession(instructions: systemPrompt)
let stream = session.streamResponse(to: userPrompt)
for try await partial in stream {
    streamedText = partial.content
}
#endif
```

### Availability Check

The service checks model availability before generation:

```swift
var isAvailable: Bool {
    #if canImport(FoundationModels)
    SystemLanguageModel.default.availability == .available
    #else
    false
    #endif
}
```

## System Prompt

The default generation prompt instructs the model to produce structured food concepts with:

- Creative dish name
- Concept description
- Layered structure breakdown
- Flavor profile
- Serving suggestion
- Pairing recommendations

The prompt is stored in `DefaultSystemPrompts.swift` and can be customized by the user via the Settings tab.

## Simulator Fallback

When `FoundationModels` is unavailable (simulator or older devices), the service generates a structured placeholder that mimics the real output format:

- Uses the same Markdown structure (headings, layers, pairings)
- Simulates streaming by revealing text in small chunks with delays
- Clearly marked as placeholder content

This ensures the full UI flow can be tested without a physical device running iOS 26+.

## User Prompt Construction

The user prompt lists all selected ingredients with their emoji, label, and category:

```
Selected ingredients:
- 🍕 Pizza (preparedDishes)
- 🍛 Curry Rice (preparedDishes)
- 🍰 Shortcake (desserts)

Create a creative food concept that combines these ingredients into one dish.
```

## Cancellation

Generation can be cancelled by the user via the Close button in `GenerationView`. The service sets `session = nil` to stop streaming.

## Error Handling

Errors are captured and displayed in the `GenerationView` with a retry option:

- Model unavailability: clear message about device/OS requirements
- Generation failure: localized error description with "Try Again" button
- Haptic feedback: error notification on failure, success on completion
