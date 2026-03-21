import SwiftUI
import SwiftData

struct CategoryEditorView: View {
    var editingCategory: CustomCategory? = nil

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = SettingsViewModel()

    @State private var displayName = ""
    @State private var emoji = ""
    @State private var colorHex = "#FF922B"
    @State private var secondaryColorHex = "#FFB66E"

    private var isNew: Bool { editingCategory == nil }

    private let colorOptions = [
        "#FF6B6B", "#51CF66", "#D4A574", "#E03131",
        "#F08C5A", "#FF922B", "#FCC419", "#F06595",
        "#845EF7", "#868E96", "#ADB5BD", "#2D3436",
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Category Info") {
                    TextField("Name", text: $displayName)
                    TextField("Emoji (single character)", text: $emoji)
                        .onChange(of: emoji) { _, newValue in
                            // Limit to one emoji/character cluster
                            if newValue.count > 1 {
                                emoji = String(newValue.prefix(1))
                            }
                        }
                }

                Section("Primary Color") {
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

                Section("Secondary Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                        ForEach(colorOptions, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: secondaryColorHex == hex ? 3 : 0)
                                )
                                .onTapGesture { secondaryColorHex = hex }
                        }
                    }
                }

                // Preview
                Section("Preview") {
                    HStack(spacing: 12) {
                        Text(emoji.isEmpty ? "?" : emoji)
                            .font(.title)
                            .frame(width: 48, height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: colorHex), Color(hex: secondaryColorHex)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                        Text(displayName.isEmpty ? "Category Name" : displayName)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle(isNew ? "New Category" : "Edit Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isNew ? "Add" : "Save") {
                        save()
                        dismiss()
                    }
                    .disabled(displayName.trimmingCharacters(in: .whitespaces).isEmpty || emoji.isEmpty)
                }
            }
            .onAppear {
                if let cat = editingCategory {
                    displayName = cat.displayName
                    emoji = cat.emoji
                    colorHex = cat.colorHex
                    secondaryColorHex = cat.secondaryColorHex
                }
            }
        }
    }

    private func save() {
        if let cat = editingCategory {
            cat.displayName = displayName
            cat.emoji = emoji
            cat.colorHex = colorHex
            cat.secondaryColorHex = secondaryColorHex
        } else {
            viewModel.addCategory(
                displayName: displayName,
                emoji: emoji,
                colorHex: colorHex,
                secondaryColorHex: secondaryColorHex,
                modelContext: modelContext
            )
        }
        try? modelContext.save()
    }
}

#Preview {
    CategoryEditorView()
        .modelContainer(for: CustomCategory.self, inMemory: true)
}
