import SwiftUI
import SwiftData

struct GenerationView: View {
    @Bindable var viewModel: MixViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var showShareSheet = false
    @State private var showSaveConfirmation = false
    @State private var hasStartedGeneration = false

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
                    MarkdownView(markdown: viewModel.generationService.streamedText)
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
                    ShareSheetView(activityItems: [url])
                }
            }
            .alert("Save Creation", isPresented: $showSaveConfirmation) {
                TextField("Creation Name", text: $viewModel.projectTitle)
                Button("Save") {
                    viewModel.saveProject(modelContext: modelContext)
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
                await viewModel.mix(systemPrompt: prompt)
            }
        }
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
