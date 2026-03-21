import SwiftUI
import SwiftData

struct SystemPromptListView: View {
    @Query(sort: \SystemPrompt.name) private var prompts: [SystemPrompt]
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = SettingsViewModel()
    @State private var showAddPrompt = false

    var body: some View {
        List {
            ForEach(PromptPurpose.allCases) { purpose in
                Section(purpose.displayName) {
                    let filtered = prompts.filter { $0.purpose == purpose }
                    ForEach(filtered) { prompt in
                        NavigationLink {
                            SystemPromptEditorView(prompt: prompt)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(prompt.name)
                                        .font(.headline)
                                    if prompt.isDefault {
                                        Text("Default")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Capsule().fill(.quaternary))
                                    }
                                }
                                Text(prompt.body.prefix(80) + "...")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }
                    }
                    .onDelete { offsets in
                        for index in offsets {
                            let prompt = filtered[index]
                            if !prompt.isDefault {
                                viewModel.deletePrompt(prompt, modelContext: modelContext)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("System Prompts")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddPrompt = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddPrompt) {
            SystemPromptEditorView(prompt: nil)
        }
        .onAppear {
            viewModel.seedDefaultPrompts(modelContext: modelContext)
        }
    }
}

#Preview {
    NavigationStack {
        SystemPromptListView()
    }
    .modelContainer(for: SystemPrompt.self, inMemory: true)
}
