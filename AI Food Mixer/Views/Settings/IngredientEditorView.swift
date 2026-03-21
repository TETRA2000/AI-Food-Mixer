import SwiftUI
import SwiftData

struct IngredientEditorView: View {
    let categoryId: String
    let defaultColorHex: String

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = SettingsViewModel()

    @State private var emoji = ""
    @State private var label = ""
    @State private var colorHex = ""

    private let colorOptions = [
        "#FF6B6B", "#51CF66", "#D4A574", "#E03131",
        "#F08C5A", "#FF922B", "#FCC419", "#F06595",
        "#845EF7", "#868E96", "#ADB5BD", "#2D3436",
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Ingredient Info") {
                    TextField("Emoji", text: $emoji)
                        .onChange(of: emoji) { _, newValue in
                            if newValue.count > 1 {
                                emoji = String(newValue.prefix(1))
                            }
                        }
                    TextField("Label", text: $label)
                }

                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                        ForEach(colorOptions, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: colorHex == hex ? 3 : 0)
                                )
                                .onTapGesture { colorHex = hex }
                        }
                    }
                }

                // Preview
                Section("Preview") {
                    HStack(spacing: 12) {
                        Text(emoji.isEmpty ? "?" : emoji)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: colorHex.isEmpty ? defaultColorHex : colorHex).opacity(0.3))
                            )
                        Text(label.isEmpty ? "Ingredient Name" : label)
                            .font(.body)
                    }
                }
            }
            .navigationTitle("New Ingredient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        save()
                        dismiss()
                    }
                    .disabled(emoji.isEmpty || label.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                colorHex = defaultColorHex
            }
        }
    }

    private func save() {
        viewModel.addIngredient(
            emoji: emoji,
            label: label,
            categoryId: categoryId,
            colorHex: colorHex.isEmpty ? defaultColorHex : colorHex,
            modelContext: modelContext
        )
    }
}

#Preview {
    IngredientEditorView(categoryId: "fruits", defaultColorHex: "#FF6B6B")
        .modelContainer(for: CustomIngredient.self, inMemory: true)
}
