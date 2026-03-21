import Foundation

enum DefaultIngredients {
    static let all: [IngredientData] =
        fruits + vegetables + grains + protein + seafood +
        preparedDishes + fastFood + desserts + drinks + condiments

    static func ingredients(for categoryId: String) -> [IngredientData] {
        all.filter { $0.categoryId == categoryId }
    }

    // MARK: - Fruits (19)

    static let fruits: [IngredientData] = [
        IngredientData(id: "fruits_grapes", emoji: "🍇", label: "Grapes", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_melon", emoji: "🍈", label: "Melon", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_watermelon", emoji: "🍉", label: "Watermelon", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_tangerine", emoji: "🍊", label: "Tangerine", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_lemon", emoji: "🍋", label: "Lemon", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_lime", emoji: "🍋‍🟩", label: "Lime", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_banana", emoji: "🍌", label: "Banana", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_pineapple", emoji: "🍍", label: "Pineapple", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_mango", emoji: "🥭", label: "Mango", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_redApple", emoji: "🍎", label: "Red Apple", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_greenApple", emoji: "🍏", label: "Green Apple", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_pear", emoji: "🍐", label: "Pear", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_peach", emoji: "🍑", label: "Peach", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_cherries", emoji: "🍒", label: "Cherries", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_strawberry", emoji: "🍓", label: "Strawberry", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_blueberries", emoji: "🫐", label: "Blueberries", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_kiwi", emoji: "🥝", label: "Kiwi", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_tomato", emoji: "🍅", label: "Tomato", categoryId: "fruits", colorHex: "#FF6B6B"),
        IngredientData(id: "fruits_coconut", emoji: "🥥", label: "Coconut", categoryId: "fruits", colorHex: "#FF6B6B"),
    ]

    // MARK: - Vegetables (18)

    static let vegetables: [IngredientData] = [
        IngredientData(id: "vegetables_avocado", emoji: "🥑", label: "Avocado", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_eggplant", emoji: "🍆", label: "Eggplant", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_potato", emoji: "🥔", label: "Potato", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_carrot", emoji: "🥕", label: "Carrot", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_corn", emoji: "🌽", label: "Corn", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_hotPepper", emoji: "🌶️", label: "Hot Pepper", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_bellPepper", emoji: "🫑", label: "Bell Pepper", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_cucumber", emoji: "🥒", label: "Cucumber", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_leafyGreen", emoji: "🥬", label: "Leafy Green", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_broccoli", emoji: "🥦", label: "Broccoli", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_garlic", emoji: "🧄", label: "Garlic", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_onion", emoji: "🧅", label: "Onion", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_mushroom", emoji: "🍄", label: "Mushroom", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_peaPod", emoji: "🫛", label: "Pea Pod", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_ginger", emoji: "🫚", label: "Ginger", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_peanuts", emoji: "🥜", label: "Peanuts", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_beans", emoji: "🫘", label: "Beans", categoryId: "vegetables", colorHex: "#51CF66"),
        IngredientData(id: "vegetables_olive", emoji: "🫒", label: "Olive", categoryId: "vegetables", colorHex: "#51CF66"),
    ]

    // MARK: - Grains & Bread (8)

    static let grains: [IngredientData] = [
        IngredientData(id: "grains_bread", emoji: "🍞", label: "Bread", categoryId: "grains", colorHex: "#D4A574"),
        IngredientData(id: "grains_baguette", emoji: "🥖", label: "Baguette", categoryId: "grains", colorHex: "#D4A574"),
        IngredientData(id: "grains_flatbread", emoji: "🫓", label: "Flatbread", categoryId: "grains", colorHex: "#D4A574"),
        IngredientData(id: "grains_pretzel", emoji: "🥨", label: "Pretzel", categoryId: "grains", colorHex: "#D4A574"),
        IngredientData(id: "grains_bagel", emoji: "🥯", label: "Bagel", categoryId: "grains", colorHex: "#D4A574"),
        IngredientData(id: "grains_pancakes", emoji: "🥞", label: "Pancakes", categoryId: "grains", colorHex: "#D4A574"),
        IngredientData(id: "grains_waffle", emoji: "🧇", label: "Waffle", categoryId: "grains", colorHex: "#D4A574"),
        IngredientData(id: "grains_rice", emoji: "🍚", label: "Rice", categoryId: "grains", colorHex: "#D4A574"),
    ]

    // MARK: - Protein & Meat (5)

    static let protein: [IngredientData] = [
        IngredientData(id: "protein_cutOfMeat", emoji: "🥩", label: "Cut of Meat", categoryId: "protein", colorHex: "#E03131"),
        IngredientData(id: "protein_meatOnBone", emoji: "🍖", label: "Meat on Bone", categoryId: "protein", colorHex: "#E03131"),
        IngredientData(id: "protein_poultryLeg", emoji: "🍗", label: "Poultry Leg", categoryId: "protein", colorHex: "#E03131"),
        IngredientData(id: "protein_bacon", emoji: "🥓", label: "Bacon", categoryId: "protein", colorHex: "#E03131"),
        IngredientData(id: "protein_egg", emoji: "🥚", label: "Egg", categoryId: "protein", colorHex: "#E03131"),
    ]

    // MARK: - Seafood (7)

    static let seafood: [IngredientData] = [
        IngredientData(id: "seafood_shrimp", emoji: "🦐", label: "Shrimp", categoryId: "seafood", colorHex: "#F08C5A"),
        IngredientData(id: "seafood_lobster", emoji: "🦞", label: "Lobster", categoryId: "seafood", colorHex: "#F08C5A"),
        IngredientData(id: "seafood_crab", emoji: "🦀", label: "Crab", categoryId: "seafood", colorHex: "#F08C5A"),
        IngredientData(id: "seafood_squid", emoji: "🦑", label: "Squid", categoryId: "seafood", colorHex: "#F08C5A"),
        IngredientData(id: "seafood_oyster", emoji: "🦪", label: "Oyster", categoryId: "seafood", colorHex: "#F08C5A"),
        IngredientData(id: "seafood_fish", emoji: "🐟", label: "Fish", categoryId: "seafood", colorHex: "#F08C5A"),
        IngredientData(id: "seafood_friedShrimp", emoji: "🍤", label: "Fried Shrimp", categoryId: "seafood", colorHex: "#F08C5A"),
    ]

    // MARK: - Prepared Dishes (18)

    static let preparedDishes: [IngredientData] = [
        IngredientData(id: "preparedDishes_pizza", emoji: "🍕", label: "Pizza", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_spaghetti", emoji: "🍝", label: "Spaghetti", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_steamingBowl", emoji: "🍜", label: "Steaming Bowl", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_potOfFood", emoji: "🍲", label: "Pot of Food", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_curryRice", emoji: "🍛", label: "Curry Rice", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_sushi", emoji: "🍣", label: "Sushi", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_bentoBox", emoji: "🍱", label: "Bento Box", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_dumpling", emoji: "🥟", label: "Dumpling", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_riceCracker", emoji: "🍘", label: "Rice Cracker", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_riceBall", emoji: "🍙", label: "Rice Ball", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_fishCake", emoji: "🍥", label: "Fish Cake", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_fortuneCookie", emoji: "🥠", label: "Fortune Cookie", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_takeoutBox", emoji: "🥡", label: "Takeout Box", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_greenSalad", emoji: "🥗", label: "Green Salad", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_bowlWithSpoon", emoji: "🥣", label: "Bowl with Spoon", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_fondue", emoji: "🫕", label: "Fondue", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_shallowPan", emoji: "🥘", label: "Shallow Pan of Food", categoryId: "preparedDishes", colorHex: "#FF922B"),
        IngredientData(id: "preparedDishes_falafel", emoji: "🧆", label: "Falafel", categoryId: "preparedDishes", colorHex: "#FF922B"),
    ]

    // MARK: - Fast Food & Snacks (10)

    static let fastFood: [IngredientData] = [
        IngredientData(id: "fastFood_hamburger", emoji: "🍔", label: "Hamburger", categoryId: "fastFood", colorHex: "#FCC419"),
        IngredientData(id: "fastFood_frenchFries", emoji: "🍟", label: "French Fries", categoryId: "fastFood", colorHex: "#FCC419"),
        IngredientData(id: "fastFood_hotDog", emoji: "🌭", label: "Hot Dog", categoryId: "fastFood", colorHex: "#FCC419"),
        IngredientData(id: "fastFood_taco", emoji: "🌮", label: "Taco", categoryId: "fastFood", colorHex: "#FCC419"),
        IngredientData(id: "fastFood_burrito", emoji: "🌯", label: "Burrito", categoryId: "fastFood", colorHex: "#FCC419"),
        IngredientData(id: "fastFood_tamale", emoji: "🫔", label: "Tamale", categoryId: "fastFood", colorHex: "#FCC419"),
        IngredientData(id: "fastFood_stuffedFlatbread", emoji: "🥙", label: "Stuffed Flatbread", categoryId: "fastFood", colorHex: "#FCC419"),
        IngredientData(id: "fastFood_sandwich", emoji: "🥪", label: "Sandwich", categoryId: "fastFood", colorHex: "#FCC419"),
        IngredientData(id: "fastFood_popcorn", emoji: "🍿", label: "Popcorn", categoryId: "fastFood", colorHex: "#FCC419"),
        IngredientData(id: "fastFood_salt", emoji: "🧂", label: "Salt", categoryId: "fastFood", colorHex: "#FCC419"),
    ]

    // MARK: - Desserts & Sweets (13)

    static let desserts: [IngredientData] = [
        IngredientData(id: "desserts_shortcake", emoji: "🍰", label: "Shortcake", categoryId: "desserts", colorHex: "#F06595"),
        IngredientData(id: "desserts_birthdayCake", emoji: "🎂", label: "Birthday Cake", categoryId: "desserts", colorHex: "#F06595"),
        IngredientData(id: "desserts_cupcake", emoji: "🧁", label: "Cupcake", categoryId: "desserts", colorHex: "#F06595"),
        IngredientData(id: "desserts_pie", emoji: "🥧", label: "Pie", categoryId: "desserts", colorHex: "#F06595"),
        IngredientData(id: "desserts_chocolateBar", emoji: "🍫", label: "Chocolate Bar", categoryId: "desserts", colorHex: "#F06595"),
        IngredientData(id: "desserts_candy", emoji: "🍬", label: "Candy", categoryId: "desserts", colorHex: "#F06595"),
        IngredientData(id: "desserts_lollipop", emoji: "🍭", label: "Lollipop", categoryId: "desserts", colorHex: "#F06595"),
        IngredientData(id: "desserts_custard", emoji: "🍮", label: "Custard", categoryId: "desserts", colorHex: "#F06595"),
        IngredientData(id: "desserts_doughnut", emoji: "🍩", label: "Doughnut", categoryId: "desserts", colorHex: "#F06595"),
        IngredientData(id: "desserts_cookie", emoji: "🍪", label: "Cookie", categoryId: "desserts", colorHex: "#F06595"),
        IngredientData(id: "desserts_softIceCream", emoji: "🍦", label: "Soft Ice Cream", categoryId: "desserts", colorHex: "#F06595"),
        IngredientData(id: "desserts_shavedIce", emoji: "🍧", label: "Shaved Ice", categoryId: "desserts", colorHex: "#F06595"),
        IngredientData(id: "desserts_iceCream", emoji: "🍨", label: "Ice Cream", categoryId: "desserts", colorHex: "#F06595"),
    ]

    // MARK: - Drinks & Beverages (16)

    static let drinks: [IngredientData] = [
        IngredientData(id: "drinks_hotBeverage", emoji: "☕", label: "Hot Beverage", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_teacup", emoji: "🍵", label: "Teacup", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_teapot", emoji: "🫖", label: "Teapot", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_sake", emoji: "🍶", label: "Sake", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_bottleWithPoppingCork", emoji: "🍾", label: "Bottle with Popping Cork", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_wineGlass", emoji: "🍷", label: "Wine Glass", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_cocktailGlass", emoji: "🍸", label: "Cocktail Glass", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_tropicalDrink", emoji: "🍹", label: "Tropical Drink", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_beerMug", emoji: "🍺", label: "Beer Mug", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_clinkingBeerMugs", emoji: "🍻", label: "Clinking Beer Mugs", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_clinkingGlasses", emoji: "🥂", label: "Clinking Glasses", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_tumblerGlass", emoji: "🥃", label: "Tumbler Glass", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_beverageBox", emoji: "🧃", label: "Beverage Box", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_cupWithStraw", emoji: "🥤", label: "Cup with Straw", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_bubbleTea", emoji: "🧋", label: "Bubble Tea", categoryId: "drinks", colorHex: "#845EF7"),
        IngredientData(id: "drinks_pouringLiquid", emoji: "🫗", label: "Pouring Liquid", categoryId: "drinks", colorHex: "#845EF7"),
    ]

    // MARK: - Condiments & Extras (6)

    static let condiments: [IngredientData] = [
        IngredientData(id: "condiments_butter", emoji: "🧈", label: "Butter", categoryId: "condiments", colorHex: "#868E96"),
        IngredientData(id: "condiments_cannedFood", emoji: "🥫", label: "Canned Food", categoryId: "condiments", colorHex: "#868E96"),
        IngredientData(id: "condiments_jar", emoji: "🫙", label: "Jar", categoryId: "condiments", colorHex: "#868E96"),
        IngredientData(id: "condiments_honeyPot", emoji: "🍯", label: "Honey Pot", categoryId: "condiments", colorHex: "#868E96"),
        IngredientData(id: "condiments_spoon", emoji: "🥄", label: "Spoon", categoryId: "condiments", colorHex: "#868E96"),
        IngredientData(id: "condiments_ice", emoji: "🧊", label: "Ice", categoryId: "condiments", colorHex: "#868E96"),
    ]
}
