import SwiftUI

struct DiscoverView: View {
    @State private var viewModel = DiscoverViewModel()
    var onRemix: (([IngredientData]) -> Void)?

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.items.isEmpty {
                    ContentUnavailableView {
                        Label("Coming Soon", systemImage: "sparkles")
                    } description: {
                        Text("Curated food mashup examples will appear here in a future update.")
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.items) { item in
                                NavigationLink {
                                    DiscoverDetailView(item: item, onRemix: onRemix)
                                } label: {
                                    DiscoverCardView(item: item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Discover")
        }
    }
}

#Preview {
    DiscoverView()
}
