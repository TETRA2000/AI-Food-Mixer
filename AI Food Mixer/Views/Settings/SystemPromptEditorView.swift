import SwiftUI
import SwiftData

struct SystemPromptEditorView: View {
    let prompt: SystemPrompt?

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var promptBody: String = ""
    @State private var purpose: PromptPurpose = .generation

    private var isNew: Bool { prompt == nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Prompt Name", text: $name)
                }

                Section("Purpose") {
                    Picker("Purpose", selection: $purpose) {
                        ForEach(PromptPurpose.allCases) { p in
                            Text(p.displayName).tag(p)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Prompt Body") {
                    TextEditor(text: $promptBody)
                        .frame(minHeight: 300)
                        .font(.system(.body, design: .monospaced))
                }
            }
            .navigationTitle(isNew ? "New Prompt" : "Edit Prompt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isNew {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isNew ? "Add" : "Save") {
                        save()
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if let prompt {
                    name = prompt.name
                    promptBody = prompt.body
                    purpose = prompt.purpose
                }
            }
        }
    }

    private func save() {
        if let prompt {
            prompt.name = name
            prompt.body = promptBody
            prompt.purpose = purpose
        } else {
            let newPrompt = SystemPrompt(
                name: name,
                body: promptBody,
                purpose: purpose
            )
            modelContext.insert(newPrompt)
        }
        try? modelContext.save()
    }
}

#Preview {
    SystemPromptEditorView(prompt: nil)
        .modelContainer(for: SystemPrompt.self, inMemory: true)
}
