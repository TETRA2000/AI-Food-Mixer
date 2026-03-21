import SwiftUI
import SwiftData

struct MixView: View {
    @State var viewModel = MixViewModel()
    @Query private var customCategories: [CustomCategory]
    @Query private var customIngredients: [CustomIngredient]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Ingredient browsing
                ScrollView {
                    LazyVStack(spacing: 24) {
                        ForEach(viewModel.allCategories(customCategories: customCategories)) { category in
                            CategoryRow(
                                category: category,
                                ingredients: viewModel.ingredients(
                                    for: category.id,
                                    customIngredients: customIngredients
                                ),
                                selectedIngredients: viewModel.selectedIngredients,
                                onToggle: { viewModel.toggleIngredient($0) }
                            )
                        }
                    }
                    .padding(.vertical)
                    .padding(.bottom, 180) // Space for bowl + button
                }

                // Bottom controls
                VStack(spacing: 12) {
                    MixingBowlView(
                        ingredients: viewModel.selectedIngredients,
                        onRemove: { viewModel.toggleIngredient($0) },
                        onClear: { viewModel.clearSelection() }
                    )

                    MixButton(count: viewModel.selectedCount) {
                        viewModel.isShowingGeneration = true
                    }
                    .padding(.bottom, 8)
                }
            }
            .navigationTitle("AI Food Mixer")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.surpriseMe(
                            customCategories: customCategories,
                            customIngredients: customIngredients
                        )
                    } label: {
                        Label("Surprise Me", systemImage: "dice")
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.isShowingGeneration) {
                GenerationView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    MixView()
        .modelContainer(for: [CustomCategory.self, CustomIngredient.self], inMemory: true)
}
