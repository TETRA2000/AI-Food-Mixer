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
                if viewModel.generationService.isGenerating {
                    generatingHeader
                }

                if let error = viewModel.generationService.error {
                    errorView(error)
                } else if viewModel.generationService.streamedText.isEmpty && !viewModel.generationService.isGenerating {
                    emptyState
                } else {
                    scrollableContent
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
                            showSaveConfirmation = true
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                        }
                    }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                if let url = ExportService.markdownFileURL(
                    title: viewModel.projectTitle.isEmpty ? "FoodConcept" : viewModel.projectTitle,
                    content: viewModel.generationService.streamedText
                ) {
                    ShareSheetView(activityItems: shareItems(fileURL: url))
                }
            }
            .alert("Save Creation", isPresented: $showSaveConfirmation) {
                TextField("Creation Name", text: $viewModel.projectTitle)
                Button("Save") {
                    viewModel.saveProject(modelContext: modelContext, imageData: generatedImageData)
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Give your creation a name.")
            }
            .task {
                guard !hasStartedGeneration else { return }
                hasStartedGeneration = true

                let settingsVM = SettingsViewModel()
                let prompt = settingsVM.activeGenerationPrompt(modelContext: modelContext)

                // Run text generation and image generation concurrently
                async let textGeneration: Void = viewModel.mix(systemPrompt: prompt)
                async let imageGeneration: Void = generateImage()
                _ = await (textGeneration, imageGeneration)
            }
        }
    }

    // MARK: - Scrollable Content

    private var scrollableContent: some View {
        ScrollView {
            VStack(spacing: 16) {
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
                Text(AttributedString(fullMarkdown: viewModel.generationService.streamedText))
                    .font(.body)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
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

    private func shareItems(fileURL: URL) -> [Any] {
        if let generatedImage {
            return [generatedImage, fileURL]
        }
        return [fileURL]
    }

    // MARK: - Image Generation

    @MainActor
    private func generateImage() async {
        #if canImport(ImagePlayground)
        isGeneratingImage = true
        imageError = nil

        do {
            let creator = try await ImageCreator()

            // Build concept from selected ingredients (available immediately)
            let ingredientNames = viewModel.selectedIngredients.map(\.label)
            let prompt = "A creative dish combining \(ingredientNames.joined(separator: ", "))"
            let concepts: [ImagePlaygroundConcept] = [
                .text(prompt)
            ]

            let images = creator.images(for: concepts, style: .illustration, limit: 1)
            for try await createdImage in images {
                let uiImage = UIImage(cgImage: createdImage.cgImage)
                withAnimation {
                    generatedImage = uiImage
                }
                generatedImageData = uiImage.jpegData(compressionQuality: 0.8)
                break
            }
        } catch {
            imageError = error.localizedDescription
        }

        isGeneratingImage = false
        #endif
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
