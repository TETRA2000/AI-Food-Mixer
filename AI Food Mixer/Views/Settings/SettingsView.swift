import SwiftUI
import SwiftData

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        SystemPromptListView()
                    } label: {
                        Label("System Prompts", systemImage: "text.bubble")
                    }
                } header: {
                    Text("AI Configuration")
                }

                Section {
                    NavigationLink {
                        IngredientManagerView()
                    } label: {
                        Label("Ingredient Categories", systemImage: "square.grid.2x2")
                    }
                } header: {
                    Text("Customisation")
                }

                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Platform")
                        Spacer()
                        Text("iOS 26")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [SystemPrompt.self, CustomCategory.self, CustomIngredient.self], inMemory: true)
}
