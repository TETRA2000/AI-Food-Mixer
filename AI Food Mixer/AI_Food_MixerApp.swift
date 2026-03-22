import SwiftUI
import SwiftData

@main
struct AI_Food_MixerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Project.self,
            CustomIngredient.self,
            CustomCategory.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
