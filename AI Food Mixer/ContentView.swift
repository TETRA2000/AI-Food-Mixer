import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .modelContainer(
            for: [Project.self, CustomIngredient.self, CustomCategory.self, SystemPrompt.self],
            inMemory: true
        )
}
