import Foundation
import SwiftData

@Model
final class SystemPrompt {
    var promptId: UUID
    var name: String
    var body: String
    var purposeRaw: String
    var isDefault: Bool

    init(
        name: String,
        body: String,
        purpose: PromptPurpose,
        isDefault: Bool = false
    ) {
        self.promptId = UUID()
        self.name = name
        self.body = body
        self.purposeRaw = purpose.rawValue
        self.isDefault = isDefault
    }

    var purpose: PromptPurpose {
        get { PromptPurpose(rawValue: purposeRaw) ?? .generation }
        set { purposeRaw = newValue.rawValue }
    }
}
