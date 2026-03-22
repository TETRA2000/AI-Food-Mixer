import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        #if os(macOS)
        MacSidebarView()
        #else
        MainTabView()
        #endif
    }
}

// MARK: - macOS Sidebar Navigation

#if os(macOS)
enum SidebarItem: String, CaseIterable, Identifiable {
    case mix = "Mix"
    case creations = "Creations"
    case discover = "Discover"
    case settings = "Settings"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .mix: "frying.pan"
        case .creations: "list.clipboard"
        case .discover: "lightbulb"
        case .settings: "gear"
        }
    }
}

struct MacSidebarView: View {
    @State private var selection: SidebarItem? = .mix
    @State private var mixViewModel = MixViewModel()

    var body: some View {
        NavigationSplitView {
            List(SidebarItem.allCases, selection: $selection) { item in
                Label(item.rawValue, systemImage: item.systemImage)
                    .tag(item)
            }
            .navigationTitle("AI Food Mixer")
        } detail: {
            switch selection {
            case .mix:
                MixView(viewModel: mixViewModel)
            case .creations:
                ProjectsListView(onRemix: remix)
            case .discover:
                DiscoverView(onRemix: remix)
            case .settings:
                SettingsView()
            case nil:
                ContentUnavailableView {
                    Label("Select a Section", systemImage: "sidebar.left")
                } description: {
                    Text("Choose a section from the sidebar to get started.")
                }
            }
        }
        .frame(minWidth: 700, minHeight: 500)
    }

    private func remix(_ ingredients: [IngredientData]) {
        mixViewModel.loadIngredients(ingredients)
        selection = .mix
    }
}
#endif

#Preview {
    ContentView()
        .modelContainer(
            for: [Project.self, CustomIngredient.self, CustomCategory.self],
            inMemory: true
        )
}
