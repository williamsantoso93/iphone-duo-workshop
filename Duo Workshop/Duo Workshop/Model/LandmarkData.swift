//
//  File.swift
//  Duo Workshop
//
//  Created by William Santoso on 12/11/26.
//

import Foundation

// Photos courtesy of Unsplash (https://unsplash.com), used under the Unsplash License.

nonisolated extension Landmark {
    static let exampleData: [Landmark] = [
        // MARK: Africa
        Landmark(
            id: 1001,
            name: "Pyramids of Giza",
            continent: .africa,
            description: "Three monumental tombs on the edge of Cairo, built for the pharaohs of Egypt's Fourth Dynasty more than 4,500 years ago and guarded by the Great Sphinx.",
            latitude: 29.9792,
            longitude: 31.1342,
            span: 0.03,
            placeID: nil,
            imageURL: .unsplash("1600520611035-84157ad4084d")
        ),
        Landmark(
            id: 1002,
            name: "Table Mountain",
            continent: .africa,
            description: "A flat-topped sandstone mountain rising above Cape Town, often draped in a 'tablecloth' of cloud and home to thousands of endemic plant species.",
            latitude: -33.9628,
            longitude: 18.4098,
            span: 0.1,
            placeID: nil,
            imageURL: .unsplash("1765706729877-cf69f724921b")
        ),
        Landmark(
            id: 1003,
            name: "Serengeti",
            continent: .africa,
            description: "Endless grassland plains in Tanzania that host the Great Migration, when millions of wildebeest and zebra follow the rains across rivers and savanna.",
            latitude: -2.3333,
            longitude: 34.8333,
            span: 3.0,
            placeID: nil,
            imageURL: .unsplash("1564101160531-4838e8a5f4e7")
        ),

        // MARK: Antarctica
        Landmark(
            id: 1004,
            name: "Antarctic Peninsula",
            continent: .antarctica,
            description: "The continent's northernmost arm, a dramatic coastline of glaciers, icebergs, and penguin colonies that serves as the gateway for most Antarctic voyages.",
            latitude: -64.7743,
            longitude: -62.8000,
            span: 6.0,
            placeID: nil,
            imageURL: .unsplash("1632347562052-83f2d630ac03")
        ),

        // MARK: Asia
        Landmark(
            id: 1005,
            name: "Petra",
            continent: .asia,
            description: "A rose-red city carved into sandstone cliffs in southern Jordan by the Nabataeans, reached through the narrow winding gorge of the Siq.",
            latitude: 30.3285,
            longitude: 35.4444,
            span: 0.04,
            placeID: nil,
            imageURL: .unsplash("1580834341580-8c17a3a630ca")
        ),
        Landmark(
            id: 1006,
            name: "Taj Mahal",
            continent: .asia,
            description: "A white marble mausoleum in Agra commissioned by Emperor Shah Jahan, celebrated for its symmetry, inlaid stonework, and reflecting pools.",
            latitude: 27.1751,
            longitude: 78.0421,
            span: 0.02,
            placeID: nil,
            imageURL: .unsplash("1564507592333-c60657eea523")
        ),
        Landmark(
            id: 1007,
            name: "Ha Long Bay",
            continent: .asia,
            description: "Thousands of limestone karsts and islets rise from emerald water in northern Vietnam, hiding caves, floating villages, and quiet lagoons.",
            latitude: 20.9101,
            longitude: 107.1839,
            span: 0.5,
            placeID: nil,
            imageURL: .unsplash("1643029891412-92f9a81a8c16")
        ),
        Landmark(
            id: 1008,
            name: "Mount Bromo",
            continent: .asia,
            description: "An active volcano in East Java's Tengger caldera, famous for sunrise views over a sea of volcanic sand and its steadily smoking crater.",
            latitude: -7.9425,
            longitude: 112.9530,
            span: 0.1,
            placeID: nil,
            imageURL: .unsplash("1781813377841-a3a25348ed17")
        ),
        Landmark(
            id: 1009,
            name: "Angkor Wat",
            continent: .asia,
            description: "The largest religious monument in the world, a 12th-century Khmer temple complex in Cambodia surrounded by a vast moat.",
            latitude: 13.4125,
            longitude: 103.8670,
            span: 0.05,
            placeID: nil,
            imageURL: .unsplash("1599283787923-51b965a58b05")
        ),

        // MARK: Australia/Oceania
        Landmark(
            id: 1010,
            name: "Sydney Opera House",
            continent: .australiaOceania,
            description: "A performing arts center on Sydney Harbour whose sail-like shells have made it one of the most recognizable buildings of the 20th century.",
            latitude: -33.8568,
            longitude: 151.2153,
            span: 0.02,
            placeID: nil,
            imageURL: .unsplash("1624138784614-87fd1b6528f8")
        ),
        Landmark(
            id: 1011,
            name: "Bora Bora",
            continent: .australiaOceania,
            description: "A volcanic island in French Polynesia encircled by a turquoise lagoon and coral reef, crowned by the jagged peak of Mount Otemanu.",
            latitude: -16.5004,
            longitude: -151.7415,
            span: 0.2,
            placeID: nil,
            imageURL: .unsplash("1706461168280-da6986cd91ec")
        ),
        Landmark(
            id: 1012,
            name: "Twelve Apostles",
            continent: .australiaOceania,
            description: "Limestone sea stacks standing off the Great Ocean Road in Victoria, sculpted by the Southern Ocean and glowing gold at sunset.",
            latitude: -38.6662,
            longitude: 143.1050,
            span: 0.05,
            placeID: nil,
            imageURL: .unsplash("1596430222039-4a2d7b4cd767")
        ),

        // MARK: Europe
        Landmark(
            id: 1013,
            name: "Eiffel Tower",
            continent: .europe,
            description: "A wrought-iron lattice tower on the Champ de Mars, built for the 1889 World's Fair and now the enduring symbol of Paris.",
            latitude: 48.8584,
            longitude: 2.2945,
            span: 0.02,
            placeID: nil,
            imageURL: .unsplash("1511739001486-6bfe10ce785f")
        ),
        Landmark(
            id: 1014,
            name: "Santorini",
            continent: .europe,
            description: "A crescent-shaped Greek island formed by a volcanic eruption, where whitewashed villages with blue domes cling to the caldera cliffs.",
            latitude: 36.4618,
            longitude: 25.3753,
            span: 0.15,
            placeID: nil,
            imageURL: .unsplash("1783442828255-cd8ea1f13750")
        ),
        Landmark(
            id: 1015,
            name: "Neuschwanstein Castle",
            continent: .europe,
            description: "A 19th-century Romanesque Revival palace on a rugged Bavarian hill, built for King Ludwig II and the inspiration for many fairy-tale castles.",
            latitude: 47.5576,
            longitude: 10.7498,
            span: 0.03,
            placeID: nil,
            imageURL: .unsplash("1449452198679-05c7fd30f416")
        ),
        Landmark(
            id: 1016,
            name: "Cliffs of Moher",
            continent: .europe,
            description: "Sheer sea cliffs on Ireland's west coast that rise more than 200 meters above the Atlantic and shelter thousands of nesting seabirds.",
            latitude: 52.9715,
            longitude: -9.4309,
            span: 0.08,
            placeID: nil,
            imageURL: .unsplash("1787304530389-89f07fedb990")
        ),

        // MARK: North America
        Landmark(
            id: 1017,
            name: "Niagara Falls",
            continent: .northAmerica,
            description: "Three powerful waterfalls on the border of Canada and the United States, where boats sail into the mist at the base of Horseshoe Falls.",
            latitude: 43.0828,
            longitude: -79.0742,
            span: 0.05,
            placeID: nil,
            imageURL: .unsplash("1763877506868-636dc8550fb2")
        ),
        Landmark(
            id: 1018,
            name: "Golden Gate Bridge",
            continent: .northAmerica,
            description: "A suspension bridge spanning the strait into San Francisco Bay, painted International Orange and frequently wrapped in rolling fog.",
            latitude: 37.8199,
            longitude: -122.4783,
            span: 0.05,
            placeID: nil,
            imageURL: .unsplash("1501594907352-04cda38ebc29")
        ),
        Landmark(
            id: 1019,
            name: "Moraine Lake",
            continent: .northAmerica,
            description: "A glacier-fed lake in Banff National Park whose vivid turquoise water sits beneath the jagged Valley of the Ten Peaks.",
            latitude: 51.3217,
            longitude: -116.1860,
            span: 0.05,
            placeID: nil,
            imageURL: .unsplash("1781210455404-12fd427f21ea")
        ),

        // MARK: South America
        Landmark(
            id: 1020,
            name: "Iguazu Falls",
            continent: .southAmerica,
            description: "Hundreds of cascades along the Iguazu River on the Argentina–Brazil border, including the thundering horseshoe of the Devil's Throat.",
            latitude: -25.6953,
            longitude: -54.4367,
            span: 0.1,
            placeID: nil,
            imageURL: .unsplash("1538703012804-b74999aa11b9")
        ),
        Landmark(
            id: 1021,
            name: "Christ the Redeemer",
            continent: .southAmerica,
            description: "An Art Deco statue atop Corcovado mountain with arms outstretched over Rio de Janeiro, its bays, and Sugarloaf Mountain.",
            latitude: -22.9519,
            longitude: -43.2105,
            span: 0.03,
            placeID: nil,
            imageURL: .unsplash("1683331404237-64c763c70f5b")
        ),
        Landmark(
            id: 1022,
            name: "Perito Moreno Glacier",
            continent: .southAmerica,
            description: "A massive glacier in Argentina's Los Glaciares National Park whose 70-meter ice wall regularly calves towering blocks into Lago Argentino.",
            latitude: -50.4967,
            longitude: -73.1377,
            span: 0.2,
            placeID: nil,
            imageURL: .unsplash("1552751753-0fc84ae5b6c8")
        ),
    ]
}
