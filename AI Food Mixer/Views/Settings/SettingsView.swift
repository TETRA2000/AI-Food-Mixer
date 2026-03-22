import SwiftUI
import SwiftData

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
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
                        #if os(macOS)
                        Text("macOS 26")
                            .foregroundStyle(.secondary)
                        #else
                        Text("iOS 26")
                            .foregroundStyle(.secondary)
                        #endif
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
        .modelContainer(for: [CustomCategory.self, CustomIngredient.self], inMemory: true)
}
