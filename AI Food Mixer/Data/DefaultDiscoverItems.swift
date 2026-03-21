import Foundation

enum DefaultDiscoverItems {
    static let all: [DiscoverItem] = [
        curryLavaPizzaCake,
        sushiTacoFusion,
        breakfastRamenBowl,
        dessertBurger,
        mediterraneanDumpling,
    ]

    // MARK: - Items

    static let curryLavaPizzaCake = DiscoverItem(
        title: "Curry Lava Pizza Cake",
        description: "A three-layered savory-sweet masterpiece combining pizza, curry, and cake",
        ingredients: [
            DefaultIngredients.preparedDishes.first { $0.id == "preparedDishes_pizza" }!,
            DefaultIngredients.preparedDishes.first { $0.id == "preparedDishes_curryRice" }!,
            DefaultIngredients.desserts.first { $0.id == "desserts_shortcake" }!,
        ],
        conceptPreview: """
        # Curry Lava Pizza Cake

        ## Concept
        A three-layered savory-sweet masterpiece with a pizza crust base, curry lava filling \
        with melted mozzarella, and a savory cake glaze topped with whipped mashed potato \
        "icing," pepperoni, basil, and curry drizzle. Cutting in releases warm, gooey curry \
        and cheese like a lava cake.

        ## Structure

        ### Layer 1: Pizza Crust Foundation
        - Thick, golden pizza dough forms the sturdy base
        - Topped with a thin layer of tomato sauce and mozzarella 🍕

        ### Layer 2: Curry Lava Core
        - Rich Japanese curry fills the center cavity
        - Blended with melted cheese for that signature lava flow 🍛

        ### Layer 3: Savory Cake Crown
        - Light, fluffy savory cake layer on top
        - Decorated with mashed potato "frosting" and curry drizzle 🍰

        ## Flavor Profile
        A bold fusion of Italian comfort and Japanese warmth — umami-rich curry meets \
        tangy tomato and stretchy mozzarella, with the cake layer adding an unexpected \
        pillowy sweetness that ties everything together.

        ## Serving Suggestion
        Serve on a wooden board, sliced like a birthday cake. Each cut releases a dramatic \
        flow of molten curry-cheese from the center. Garnish with fresh basil and a dusting \
        of curry powder.

        ## Pairings
        - 🍺 Cold lager to cut through the richness
        - 🥗 Light cucumber salad for contrast
        - 🍵 Hot green tea for a Japanese touch
        """
    )

    static let sushiTacoFusion = DiscoverItem(
        title: "Sushi Taco Fusion",
        description: "Nori-wrapped taco shells filled with fresh sashimi and creamy avocado",
        ingredients: [
            DefaultIngredients.preparedDishes.first { $0.id == "preparedDishes_sushi" }!,
            DefaultIngredients.fastFood.first { $0.id == "fastFood_taco" }!,
            DefaultIngredients.vegetables.first { $0.id == "vegetables_avocado" }!,
        ],
        conceptPreview: """
        # Sushi Taco Fusion

        ## Concept
        Crispy nori-wrapped taco shells cradling fresh sashimi-grade fish, creamy avocado, \
        and sushi rice — a handheld collision of Japanese precision and Mexican boldness.

        ## Structure

        ### Layer 1: Nori Taco Shell
        - Toasted nori sheets pressed into taco shape with a thin tempura crunch 🌮

        ### Layer 2: Sushi Rice Bed
        - Seasoned sushi rice lines the shell for authentic flavor 🍣

        ### Layer 3: Avocado & Fish Crown
        - Sliced avocado fans and fresh sashimi draped on top 🥑

        ## Flavor Profile
        Clean, oceanic freshness meets creamy richness, with the nori adding \
        a toasty umami backbone and wasabi providing a gentle heat.

        ## Serving Suggestion
        Arranged on a slate plate like a taco stand, with tiny bowls of soy sauce, \
        pickled ginger, and wasabi on the side. Eat with hands for the full taco experience.

        ## Pairings
        - 🍶 Chilled sake for a classic pairing
        - 🍋 Yuzu sparkling water for brightness
        """
    )

    static let breakfastRamenBowl = DiscoverItem(
        title: "Breakfast Ramen Bowl",
        description: "Pancake noodles swimming in maple-miso broth with crispy bacon",
        ingredients: [
            DefaultIngredients.grains.first { $0.id == "grains_pancakes" }!,
            DefaultIngredients.preparedDishes.first { $0.id == "preparedDishes_steamingBowl" }!,
            DefaultIngredients.protein.first { $0.id == "protein_bacon" }!,
            DefaultIngredients.protein.first { $0.id == "protein_egg" }!,
        ],
        conceptPreview: """
        # Breakfast Ramen Bowl

        ## Concept
        Morning meets evening in this cozy bowl where thin pancake strips serve as \
        noodles, swimming in a sweet maple-miso broth topped with crispy bacon and \
        a perfect soft-boiled egg.

        ## Structure

        ### Layer 1: Maple-Miso Broth
        - Rich dashi base sweetened with real maple syrup 🍜

        ### Layer 2: Pancake Noodles
        - Thin pancake strips cut into ramen-width ribbons 🥞

        ### Layer 3: Breakfast Toppings
        - Crispy bacon crumbles scattered throughout 🥓
        - Jammy soft-boiled egg halved on top 🥚

        ## Flavor Profile
        Sweet maple and savory miso create an addictive umami-sweet broth, \
        while smoky bacon and rich egg yolk add depth and comfort.

        ## Serving Suggestion
        Served in a traditional ramen bowl with chopsticks and a deep spoon. \
        Break the egg yolk into the broth for a golden, silky finish.

        ## Pairings
        - ☕ Strong black coffee
        - 🧃 Fresh orange juice for brightness
        """
    )

    static let dessertBurger = DiscoverItem(
        title: "Dessert Burger",
        description: "Doughnut buns sandwiching an ice cream patty drizzled with chocolate",
        ingredients: [
            DefaultIngredients.fastFood.first { $0.id == "fastFood_hamburger" }!,
            DefaultIngredients.desserts.first { $0.id == "desserts_doughnut" }!,
            DefaultIngredients.desserts.first { $0.id == "desserts_softIceCream" }!,
            DefaultIngredients.desserts.first { $0.id == "desserts_chocolateBar" }!,
        ],
        conceptPreview: """
        # Dessert Burger

        ## Concept
        A sweet indulgence shaped like a classic burger — glazed doughnut halves \
        embrace a thick ice cream patty drizzled with melted chocolate, proving that \
        burgers belong at dessert too.

        ## Structure

        ### Layer 1: Doughnut Bun
        - Glazed doughnut split in half as top and bottom bun 🍩

        ### Layer 2: Ice Cream Patty
        - Thick disc of vanilla ice cream shaped like a burger patty 🍦

        ### Layer 3: Chocolate Sauce
        - Warm melted chocolate drizzled over like ketchup and mustard 🍫

        ### Layer 4: Burger Assembly
        - Stacked and served in a mini burger box 🍔

        ## Flavor Profile
        Decadent sweetness from the glazed doughnut, creamy vanilla ice cream, \
        and rich dark chocolate — balanced by a pinch of sea salt on top.

        ## Serving Suggestion
        Presented in a miniature burger box with parchment paper. Serve quickly \
        before the ice cream melts — the race to eat it is part of the fun!

        ## Pairings
        - 🥤 Thick milkshake on the side
        - ☕ Espresso shot to cut the sweetness
        """
    )

    static let mediterraneanDumpling = DiscoverItem(
        title: "Mediterranean Dumpling",
        description: "Olive oil-infused wrappers with falafel filling and fresh salad",
        ingredients: [
            DefaultIngredients.preparedDishes.first { $0.id == "preparedDishes_dumpling" }!,
            DefaultIngredients.vegetables.first { $0.id == "vegetables_olive" }!,
            DefaultIngredients.preparedDishes.first { $0.id == "preparedDishes_falafel" }!,
            DefaultIngredients.preparedDishes.first { $0.id == "preparedDishes_greenSalad" }!,
        ],
        conceptPreview: """
        # Mediterranean Dumpling

        ## Concept
        East meets West in these delicate dumplings — olive oil-infused wrappers \
        encase a spiced falafel filling, served on a bed of bright Mediterranean salad \
        with tahini dipping sauce.

        ## Structure

        ### Layer 1: Olive Oil Wrapper
        - Thin dumpling dough enriched with extra virgin olive oil 🫒

        ### Layer 2: Falafel Filling
        - Spiced chickpea and herb mixture as the filling 🧆

        ### Layer 3: Dumpling Form
        - Pleated into classic dumpling shapes, then pan-fried 🥟

        ### Layer 4: Salad Bed
        - Crisp mixed greens, cherry tomatoes, and cucumber underneath 🥗

        ## Flavor Profile
        Herbaceous and earthy from the falafel spices, with the olive oil wrapper \
        adding fruity richness and the fresh salad providing a cool, crunchy contrast.

        ## Serving Suggestion
        Arranged in a circle on a large Mediterranean platter, surrounding a bowl \
        of creamy tahini sauce. Drizzle with olive oil and sprinkle with za'atar.

        ## Pairings
        - 🍷 Crisp white wine
        - 🍵 Fresh mint tea
        """
    )
}
