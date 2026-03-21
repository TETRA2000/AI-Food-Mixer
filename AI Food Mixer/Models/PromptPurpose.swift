import Foundation

enum PromptPurpose: String, Codable, CaseIterable, Identifiable {
    case generation

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .generation: "Food Concept Generation"
        }
    }
}
