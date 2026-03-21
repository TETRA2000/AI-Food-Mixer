import Foundation

enum DefaultCategories {
    static let all: [CategoryData] = [
        CategoryData(
            id: "fruits",
            displayName: "Fruits",
            emoji: "🍎",
            colorHex: "#FF6B6B",
            secondaryColorHex: "#FFA8A8",
            sortOrder: 0
        ),
        CategoryData(
            id: "vegetables",
            displayName: "Vegetables",
            emoji: "🥦",
            colorHex: "#51CF66",
            secondaryColorHex: "#8CE99A",
            sortOrder: 1
        ),
        CategoryData(
            id: "grains",
            displayName: "Grains & Bread",
            emoji: "🍞",
            colorHex: "#D4A574",
            secondaryColorHex: "#E8C9A0",
            sortOrder: 2
        ),
        CategoryData(
            id: "protein",
            displayName: "Protein & Meat",
            emoji: "🥩",
            colorHex: "#E03131",
            secondaryColorHex: "#F06060",
            sortOrder: 3
        ),
        CategoryData(
            id: "seafood",
            displayName: "Seafood",
            emoji: "🦐",
            colorHex: "#F08C5A",
            secondaryColorHex: "#F4B183",
            sortOrder: 4
        ),
        CategoryData(
            id: "preparedDishes",
            displayName: "Prepared Dishes",
            emoji: "🍛",
            colorHex: "#FF922B",
            secondaryColorHex: "#FFB66E",
            sortOrder: 5
        ),
        CategoryData(
            id: "fastFood",
            displayName: "Fast Food & Snacks",
            emoji: "🍔",
            colorHex: "#FCC419",
            secondaryColorHex: "#FFD95C",
            sortOrder: 6
        ),
        CategoryData(
            id: "desserts",
            displayName: "Desserts & Sweets",
            emoji: "🍰",
            colorHex: "#F06595",
            secondaryColorHex: "#F591B2",
            sortOrder: 7
        ),
        CategoryData(
            id: "drinks",
            displayName: "Drinks & Beverages",
            emoji: "🍹",
            colorHex: "#845EF7",
            secondaryColorHex: "#A98AFA",
            sortOrder: 8
        ),
        CategoryData(
            id: "condiments",
            displayName: "Condiments & Extras",
            emoji: "🧂",
            colorHex: "#868E96",
            secondaryColorHex: "#ADB5BD",
            sortOrder: 9
        ),
    ]

    static func category(for id: String) -> CategoryData? {
        all.first { $0.id == id }
    }
}
