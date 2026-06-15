import SwiftUI
import SwiftData

struct IngredientManagerView: View {
    @Query(sort: \CustomCategory.sortOrder) private var customCategories: [CustomCategory]
    @Query private var customIngredients: [CustomIngredient]
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = SettingsViewModel()
    @State private var showAddCategory = false
    @State private var categoryPendingDeletion: CustomCategory?

    var body: some View {
        List {
            // Default categories (read-only)
            Section("Built-in Categories") {
                ForEach(DefaultCategories.all) { category in
                    NavigationLink {
                        CategoryIngredientsView(
                            category: category,
                            defaultIngredients: DefaultIngredients.ingredients(for: category.id),
                            customIngredients: customIngredients.filter { $0.categoryId == category.id }
                        )
                    } label: {
                        CategoryRowLabel(category: category, isDefault: true)
                    }
                }
            }

            // Custom categories (editable)
            Section("Custom Categories") {
                if customCategories.isEmpty {
                    Text("No custom categories yet.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(customCategories) { category in
                        let categoryData = CategoryData(from: category)
                        NavigationLink {
                            CategoryIngredientsView(
                                category: categoryData,
                                defaultIngredients: [],
                                customIngredients: customIngredients.filter { $0.categoryId == category.categoryId }
                            )
                        } label: {
                            CategoryRowLabel(category: categoryData, isDefault: false)
                        }
                    }
                    .onDelete { offsets in
                        if let index = offsets.first {
                            categoryPendingDeletion = customCategories[index]
                        }
                    }
                }
            }
        }
        .modifier(
            DeleteCategoryConfirmation(category: $categoryPendingDeletion) { category in
                viewModel.deleteCategory(category, modelContext: modelContext)
            }
        )
        .navigationTitle("Ingredient Categories")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddCategory = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddCategory) {
            CategoryEditorView()
        }
    }
}

// MARK: - Delete Category Confirmation (iOS 27 item binding)

/// Confirms deletion of a custom category before removing it and its custom
/// ingredients. The optional `category` is the single source of truth: it drives
/// the iOS 27 `confirmationDialog(_:item:)` overload directly, and on earlier OS
/// versions (deployment target is 26.4) the `isPresented:`/`presenting:` fallback
/// derives its presentation flag from the same optional.
struct DeleteCategoryConfirmation: ViewModifier {
    @Binding var category: CustomCategory?
    let onDelete: (CustomCategory) -> Void

    func body(content: Content) -> some View {
        if #available(iOS 27.0, *) {
            content.confirmationDialog(
                "Delete Category",
                item: $category,
                titleVisibility: .visible
            ) { category in
                deleteButton(for: category)
            } message: { category in
                message(for: category)
            }
        } else {
            let isPresented = Binding(
                get: { category != nil },
                set: { if !$0 { category = nil } }
            )
            content.confirmationDialog(
                "Delete Category",
                isPresented: isPresented,
                titleVisibility: .visible,
                presenting: category
            ) { category in
                deleteButton(for: category)
            } message: { category in
                message(for: category)
            }
        }
    }

    @ViewBuilder
    private func deleteButton(for category: CustomCategory) -> some View {
        Button("Delete \(category.displayName)", role: .destructive) {
            onDelete(category)
        }
    }

    private func message(for category: CustomCategory) -> Text {
        Text("Deleting \"\(category.displayName)\" also removes its custom ingredients. This can't be undone.")
    }
}

// MARK: - Category Row Label

struct CategoryRowLabel: View {
    let category: CategoryData
    let isDefault: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(category.emoji)
                .font(.title2)
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: category.colorHex).opacity(0.2))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(category.displayName)
                    .font(.body)
                if isDefault {
                    Text("Built-in")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - Category Ingredients View

struct CategoryIngredientsView: View {
    let category: CategoryData
    let defaultIngredients: [IngredientData]
    let customIngredients: [CustomIngredient]
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = SettingsViewModel()
    @State private var showAddIngredient = false

    var body: some View {
        List {
            if !defaultIngredients.isEmpty {
                Section("Built-in Ingredients") {
                    ForEach(defaultIngredients) { ingredient in
                        IngredientRowLabel(ingredient: ingredient)
                    }
                }
            }

            Section("Custom Ingredients") {
                if customIngredients.isEmpty {
                    Text("No custom ingredients in this category.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(customIngredients) { ingredient in
                        IngredientRowLabel(ingredient: IngredientData(from: ingredient))
                    }
                    .onDelete { offsets in
                        for index in offsets {
                            viewModel.deleteIngredient(customIngredients[index], modelContext: modelContext)
                        }
                    }
                }
            }
        }
        .navigationTitle("\(category.emoji) \(category.displayName)")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddIngredient = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddIngredient) {
            IngredientEditorView(categoryId: category.id, defaultColorHex: category.colorHex)
        }
    }
}

// MARK: - Ingredient Row Label

struct IngredientRowLabel: View {
    let ingredient: IngredientData

    var body: some View {
        HStack(spacing: 12) {
            Text(ingredient.emoji)
                .font(.title3)
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: ingredient.colorHex).opacity(0.2))
                )

            Text(ingredient.label)
                .font(.body)

            if ingredient.isCustom {
                Spacer()
                Text("Custom")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        IngredientManagerView()
    }
    .modelContainer(for: [CustomCategory.self, CustomIngredient.self], inMemory: true)
}
