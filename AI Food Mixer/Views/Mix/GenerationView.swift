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
    @State private var showImagePlayground = false
    @State private var imageError: String?
    @State private var generationTrigger = UUID()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.generationService.error == nil, viewModel.generationService.isGenerating {
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
                    if !viewModel.generationService.streamedText.isEmpty && !viewModel.generationService.isGenerating {
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
                } else {
                    ShareSheetView(activityItems: [viewModel.generationService.streamedText])
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
                showImagePlayground = false
                imageError = nil
                hasStartedGeneration = false
            }
            .task(id: generationTrigger) {
                guard viewModel.isShowingGeneration else { return }
                guard !hasStartedGeneration else { return }
                hasStartedGeneration = true

                // Generate the text concept; the image is created on demand by the
                // user via the Image Playground sheet once the concept is ready.
                await viewModel.mix()
            }
            #if canImport(ImagePlayground)
            .imagePlaygroundSheet(
                isPresented: $showImagePlayground,
                concept: viewModel.generationService.streamedText.imagePlaygroundConcept
            ) { url in
                loadGeneratedImage(from: url)
            }
            #endif
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

                // Generated image, or an affordance to create one
                if let generatedImage {
                    Image(uiImage: generatedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                } else {
                    imageGenerationButton
                }

                if let imageError {
                    Text(imageError)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                        )
                        .padding(.horizontal)
                }

                // Markdown content
                MarkdownBlocksView(markdown: viewModel.generationService.streamedText)
                    .textSelection(.enabled)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }

    // MARK: - Image Generation Button

    /// Button that presents the system Image Playground sheet, shown once the
    /// text concept is ready and only where image generation is supported.
    @ViewBuilder
    private var imageGenerationButton: some View {
        #if canImport(ImagePlayground)
        if ImagePlaygroundViewController.isAvailable,
           !viewModel.generationService.streamedText.isEmpty,
           !viewModel.generationService.isGenerating {
            Button {
                showImagePlayground = true
            } label: {
                Label("Generate Image", systemImage: "wand.and.stars")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal)
            .accessibilityLabel("Generate an image for this food concept")
        }
        #endif
    }

    // MARK: - Image Generation

    /// Loads the image the Image Playground sheet wrote to `url` and stores it
    /// for display and for saving with the project.
    private func loadGeneratedImage(from url: URL) {
        guard let result = ImageImportService.loadImage(from: url) else {
            imageError = "Couldn't load the generated image."
            return
        }
        imageError = nil
        withAnimation {
            generatedImage = result.image
        }
        generatedImageData = result.data
    }

    // MARK: - Subviews

    private var generatingHeader: some View {
        HStack(spacing: 12) {
            ProgressView()
            Text("Mixing your creation...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .accessibilityLabel("Generating food concept")
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("Ready to Mix", systemImage: "fork.knife")
        } description: {
            Text("Tap Mix to generate your food concept from the selected ingredients.")
        }
    }

    private func errorView(_ message: String) -> some View {
        Group {
            if !viewModel.generationService.isAvailable {
                ContentUnavailableView {
                    Label("Apple Intelligence Required", systemImage: "apple.intelligence")
                } description: {
                    Text(message)
                } actions: {
                    Button("Close") {
                        dismiss()
                    }
                }
            } else {
                ContentUnavailableView {
                    Label("Generation Error", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(message)
                } actions: {
                    Button("Try Again") {
                        viewModel.generationService.error = nil
                        generatedImage = nil
                        generatedImageData = nil
                        imageError = nil
                        hasStartedGeneration = false
                        generationTrigger = UUID()
                    }
                }
            }
        }
    }
}
