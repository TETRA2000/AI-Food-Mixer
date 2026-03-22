import SwiftUI
import SwiftData

#if canImport(ImagePlayground)
import ImagePlayground
#endif

struct GenerationView: View {
    @Bindable var viewModel: MixViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var showShareSheet = false
    @State private var showSaveConfirmation = false
    @State private var hasStartedGeneration = false
    @State private var generatedImage: UIImage?
    @State private var generatedImageData: Data?
    @State private var isGeneratingImage = false
    @State private var imageError: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if isGeneratingImage || viewModel.generationService.isGenerating || (hasStartedGeneration && generatedImage == nil) {
                    generatingHeader
                }

                if let error = viewModel.generationService.error {
                    errorView(error)
                } else if hasStartedGeneration {
                    scrollableContent
                } else {
                    emptyState
                }
            }
            .navigationTitle("Food Concept")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        viewModel.generationService.cancel()
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .primaryAction) {
                    if !viewModel.generationService.streamedText.isEmpty && !viewModel.generationService.isGenerating && generatedImage != nil {
                        Button {
                            showShareSheet = true
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }

                        Button {
                            viewModel.projectTitle = viewModel.generationService.generatedFoodName ?? ""
                            showSaveConfirmation = true
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                        }
                    }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                if let generatedImage {
                    ShareSheetView(activityItems: [generatedImage])
                }
            }
            .alert("Save Creation", isPresented: $showSaveConfirmation) {
                TextField("Creation Name", text: $viewModel.projectTitle)
                Button("Save") {
                    viewModel.saveProject(modelContext: modelContext, imageData: generatedImageData)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Give your creation a name.")
            }
            .onAppear {
                // Reset all state for a fresh generation
                viewModel.generationService.streamedText = ""
                viewModel.generationService.error = nil
                viewModel.projectTitle = ""
                generatedImage = nil
                generatedImageData = nil
                isGeneratingImage = false
                imageError = nil
                hasStartedGeneration = false
            }
            .task(id: viewModel.isShowingGeneration) {
                guard viewModel.isShowingGeneration else { return }
                guard !hasStartedGeneration else { return }
                hasStartedGeneration = true

                // Generate image first, then text
                await generateImage()

                guard !Task.isCancelled else { return }

                await viewModel.mix()
            }
        }
    }

    // MARK: - Scrollable Content

    private var scrollableContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Ingredient chips
                if !viewModel.selectedIngredients.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)

                        FlowLayout(spacing: 8) {
                            ForEach(viewModel.selectedIngredients) { ingredient in
                                HStack(spacing: 4) {
                                    Text(ingredient.emoji)
                                        .font(.caption)
                                    Text(ingredient.label)
                                        .font(.caption2)
                                        .fontWeight(.medium)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color(hex: ingredient.colorHex).opacity(0.15))
                                )
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }

                // Generated image or progress
                if let generatedImage {
                    Image(uiImage: generatedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                } else if isGeneratingImage {
                    imageGeneratingPlaceholder
                }

                // Markdown content
                MarkdownBlocksView(markdown: viewModel.generationService.streamedText)
                    .textSelection(.enabled)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }

    // MARK: - Image Generation Placeholder

    private var imageGeneratingPlaceholder: some View {
        VStack(spacing: 12) {
            ProgressView()
                .controlSize(.large)
            Text("Creating image...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .padding(.horizontal)
        .accessibilityLabel("Generating image for food concept")
    }

    // MARK: - Helpers

    // MARK: - Image Generation

    @MainActor
    private func generateImage() async {
        #if canImport(ImagePlayground)
        isGeneratingImage = true
        imageError = nil
        defer { isGeneratingImage = false }

        do {
            try Task.checkCancellation()
            let creator = try await ImageCreator()

            try Task.checkCancellation()

            // Build concept from selected ingredients (available immediately)
            let ingredientNames = viewModel.selectedIngredients.map(\.label)
            let prompt = "A creative dish combining \(ingredientNames.joined(separator: ", "))"
            let concepts: [ImagePlaygroundConcept] = [
                .text(prompt)
            ]

            let images = creator.images(for: concepts, style: .animation, limit: 1)
            for try await createdImage in images {
                try Task.checkCancellation()
                let uiImage = UIImage(cgImage: createdImage.cgImage)
                withAnimation {
                    generatedImage = uiImage
                }
                generatedImageData = uiImage.jpegData(compressionQuality: 0.8)
                break
            }
        } catch is CancellationError {
            // User dismissed the view — not an error
            return
        } catch let imagePlaygroundError as ImageCreator.Error where imagePlaygroundError == .creationCancelled {
            // Image generation cancelled — not an error
            return
        } catch {
            imageError = error.localizedDescription
        }
        #endif
    }

    // MARK: - Subviews

    private var generatingHeader: some View {
        HStack(spacing: 12) {
            ProgressView()
            Text(isGeneratingImage ? "Creating image..." : "Mixing your creation...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .accessibilityLabel(isGeneratingImage ? "Creating image" : "Generating food concept")
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("Ready to Mix", systemImage: "fork.knife")
        } description: {
            Text("Tap Mix to generate your food concept from the selected ingredients.")
        }
    }

    private func errorView(_ message: String) -> some View {
        ContentUnavailableView {
            Label("Generation Error", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Try Again") {
                hasStartedGeneration = false
            }
        }
    }
}
