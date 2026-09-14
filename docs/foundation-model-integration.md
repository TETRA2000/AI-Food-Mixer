# Foundation Model Integration

## Overview

AI Food Mixer uses Apple's on-device Foundation Model (available on iOS 27+) to generate creative food concepts from selected emoji ingredients. All generation happens locally with zero network calls.

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
3. Service reuses the session prewarmed on the Mix tap (see below), or creates a `LanguageModelSession` with the system prompt as instructions
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

### Prewarming

`MixViewModel` calls `FoodGenerationService.prewarm()` when the user taps Mix, before the generation screen appears. This creates the session up front and calls `session.prewarm(promptPrefix:)` with the static part of the user prompt so the model can cache it, reducing time-to-first-token. `generate()` reuses that session; `cancel()` discards it.

## System Prompt

The default generation prompt instructs the model to produce structured food concepts with:

- Creative dish name
- Concept description
- Layered structure breakdown
- Flavor profile
- Serving suggestion
- Pairing recommendations

The prompt is defined as a static string in `DefaultSystemPrompts.swift`.

## Simulator Fallback

When `FoundationModels` is unavailable (simulator or older devices), the service generates a structured placeholder that mimics the real output format:

- Uses the same Markdown structure (headings, layers, pairings)
- Simulates streaming by revealing text in small chunks with delays
- Clearly marked as placeholder content

This ensures the full UI flow can be tested without a physical device running iOS 27+.

## User Prompt Construction

The user prompt starts with a fixed instruction prefix (shared with prewarming so the model can cache it), followed by the selected ingredients with their emoji, label, and category:

```
Create a creative food concept that combines the following ingredients into one dish.

Selected ingredients:
- 🍕 Pizza (preparedDishes)
- 🍛 Curry Rice (preparedDishes)
- 🍰 Shortcake (desserts)
```

## Cancellation

Generation can be cancelled by the user via the Close button in `GenerationView`, or implicitly when the SwiftUI `.task` that started it is torn down. `cancel()` cancels the streaming `Task`, drops the session, and resets `isGenerating`; parent-task cancellation is bridged to the inner task with `withTaskCancellationHandler`, and a `CancellationError` is swallowed rather than surfaced as an error.

## Error Handling

Errors are captured and displayed in the `GenerationView` with a retry option:

- Model unavailability: clear message about device/OS requirements
- Generation failure: localized error description with "Try Again" button
- Haptic feedback: error notification on failure, success on completion
