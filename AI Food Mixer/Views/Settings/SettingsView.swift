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
                        Text(AppInfo.version())
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Platform")
                        Spacer()
                        Text(AppInfo.platform)
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
        .modelContainer(for: [CustomCategory.self, CustomIngredient.self], inMemory: true)
}
