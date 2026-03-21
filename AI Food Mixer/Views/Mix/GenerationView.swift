import SwiftUI
import SwiftData

#if canImport(ImagePlayground)
import ImagePlayground
#endif

struct GenerationView: View {
    @Bindable var viewModel: MixViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    #if canImport(ImagePlayground)
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    #endif

    @State private var showShareSheet = false
    @State private var showSaveConfirmation = false
    @State private var hasStartedGeneration = false
    @State private var showImagePlayground = false
    @State private var generatedImage: UIImage?
    @State private var generatedImageData: Data?

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
            #if canImport(ImagePlayground)
            .imagePlaygroundSheet(
                isPresented: $showImagePlayground,
                concept: viewModel.generationService.streamedText.imagePlaygroundConcept
            ) { url in
                handleImagePlaygroundResult(url: url)
            }
            #endif
            .task {
                guard !hasStartedGeneration else { return }
                hasStartedGeneration = true

                let settingsVM = SettingsViewModel()
                let prompt = settingsVM.activeGenerationPrompt(modelContext: modelContext)
                await viewModel.mix(systemPrompt: prompt)
            }
        }
    }

    // MARK: - Scrollable Content

    private var scrollableContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Generated image
                if let generatedImage {
                    Image(uiImage: generatedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }

                // "Create Image" button
                #if canImport(ImagePlayground)
                if !viewModel.generationService.isGenerating
                    && !viewModel.generationService.streamedText.isEmpty
                    && supportsImagePlayground
                    && generatedImage == nil {
                    generateImageButton
                }
                #endif

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

    // MARK: - Generate Image Button

    #if canImport(ImagePlayground)
    private var generateImageButton: some View {
        Button {
            showImagePlayground = true
        } label: {
            Label("Create Image", systemImage: "wand.and.stars")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                )
        }
        .padding(.horizontal)
        .accessibilityLabel("Create an image of this food concept")
    }
    #endif

    // MARK: - Helpers

    private func shareItems(fileURL: URL) -> [Any] {
        if let generatedImage {
            return [generatedImage, fileURL]
        }
        return [fileURL]
    }

    // MARK: - Image Playground Handler

    private func handleImagePlaygroundResult(url: URL) {
        guard let data = try? Data(contentsOf: url) else { return }
        guard let uiImage = UIImage(data: data) else { return }

        withAnimation {
            generatedImage = uiImage
        }
        generatedImageData = uiImage.jpegData(compressionQuality: 0.8)
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
