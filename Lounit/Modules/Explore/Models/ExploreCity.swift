//
//  ExploreCity.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import Foundation

enum ExploreCityInfoKind: Int, CaseIterable {
    case culture
    case nature
    case food

    var normalImageName: String {
        switch self {
        case .culture:
            return "CityDetailCulture"
        case .nature:
            return "CityDetailNature"
        case .food:
            return "CityDetailFood"
        }
    }

    var selectedImageName: String {
        switch self {
        case .culture:
            return "CityDetailCultureSelected"
        case .nature:
            return "CityDetailNatureSelected"
        case .food:
            return "CityDetailFoodSelected"
        }
    }
}

struct ExploreCityInfo {
    let title: String
    let detail: String
}

struct ExploreCity {
    let name: String
    let subtitle: String
    let rating: String
    let listImageName: String
    let heroImageName: String
    let culture: ExploreCityInfo
    let nature: ExploreCityInfo
    let food: ExploreCityInfo

    func info(for kind: ExploreCityInfoKind) -> ExploreCityInfo {
        switch kind {
        case .culture:
            return culture
        case .nature:
            return nature
        case .food:
            return food
        }
    }
}

enum ExploreCityDataSource {
    static let cities: [ExploreCity] = [
        ExploreCity(
            name: "Florence, Italy",
            subtitle: "Old Renaissance Town",
            rating: "4.8",
            listImageName: "ExploreCityFlorence",
            heroImageName: "ExploreCityFlorence",
            culture: ExploreCityInfo(
                title: "Florence, Italy - Old Renaissance Town",
                detail: """
                The birthplace of the Renaissance, home to masterpieces by Botticelli and Leonardo da Vinci in the Uffizi Gallery; medieval art and architecture abound throughout the city, including the dome of the Florence Cathedral, the Ponte Vecchio, and Piazzale Michelangelo.
                """
            ),
            nature: ExploreCityInfo(
                title: "nature",
                detail: """
                The Arno River flows through the city, and its riverside lawns are popular spots for locals to relax. To the south, the Michelangelo Hill offers panoramic views of the old town with its red roofs. The surrounding Tuscan hills stretch as far as the eye can see, dotted with olive groves and vineyards, and the Chianti wine estates are scattered throughout the mountains. A short drive will take you to pastoral castles and mountain woodlands, where the scenery is gentle and soothing in all four seasons.
                """
            ),
            food: ExploreCityInfo(
                title: "food",
                detail: """
                The local cuisine emphasizes rustic flavors, with the signature Chianina T-bone grilled steak boasting thick, tender meat. Street-side tripe buns are a local specialty, served with braised tripe and spiced bread. Other options include Tuscan vegetable soup, handmade pasta, and almond biscuits dipped in sweet wine for dessert. A variety of fresh fruit and handmade ice creams are available throughout the town, and Chianti red wine is the perfect accompaniment.
                """
            )
        ),
        ExploreCity(
            name: "Santorini, Greece",
            subtitle: "Aegean Sea island",
            rating: "4.8",
            listImageName: "ExploreCitySantorini",
            heroImageName: "ExploreCitySantorini",
            culture: ExploreCityInfo(
                title: "Santorini, Greece (Aegean Sea island)",
                detail: """
                A typical Cycladic island civilization, the iconic white-walled, blue-roofed houses carved into the volcanic rock face are iconic architectural features. The Akrotiri ruins, sealed by volcanic ash, preserve ancient Aegean murals and settlement remains. Monasteries and medieval castles on the island bear witness to the development of Orthodox Christianity, and the inhabitants maintain traditional fishing methods and pottery making, reflecting the island's simple and honest folk customs.
                """
            ),
            nature: ExploreCityInfo(
                title: "nature",
                detail: """
                Tuscany hilly vineyards in the suburbs, rural mountain scenery on the outskirts of the city, a day trip to the winery; the Arno River runs through the city. Volcanic geology has created black and red sand beaches, with cliffs facing the azure Aegean Sea. The cliffside sunset in Oia is world-renowned. Nearby, you can take a boat to the volcanic island for hiking and soak in natural geothermal hot springs. The island's coastline features a stunning combination of blue sea and cliffs, with the sea breeze rustling through the volcanic rock formations, making the island's natural scenery unique, and the riverside green spaces are relaxing.
                """
            ),
            food: ExploreCityInfo(
                title: "food",
                detail: """
                Florence T-bone steak, handmade pasta, Chianti red wine, porcini risotto, and fig dessert.
                """
            )
        ),
        ExploreCity(
            name: "Chiang Mai, Thailand",
            subtitle: "Lanna Kingdom capital",
            rating: "4.8",
            listImageName: "ExploreCityChiangMai",
            heroImageName: "ExploreCityChiangMai",
            culture: ExploreCityInfo(
                title: "Chiang Mai, Thailand",
                detail: """
                Lanna Kingdom capital in Northern Thailand is surrounded by ancient city walls, with hundreds of ancient temples scattered throughout, and golden-domed pagodas visible everywhere. Weekend night markets offer handcrafted silver jewelry, wood carvings, and fabric crafts, while traditional Thai massage preserves a thousand-year-old wellness culture. The area hosts year-round festivals such as Loy Krathong and Songkran, where Lanna costumes and folk dances are a common sight.
                """
            ),
            nature: ExploreCityInfo(
                title: "nature",
                detail: """
                Nestled against Doi Suthep, Wat Phra That Doi Suthep sits halfway up the mountain, offering panoramic views of Chiang Mai from its summit. The surrounding area is covered in lush rainforests, streams, and waterfalls, with vast rice paddies changing colors with the seasons. Visitors can also enjoy trekking deep into the jungle, where verdant vegetation and fresh, moist air abound.
                """
            ),
            food: ExploreCityInfo(
                title: "food",
                detail: """
                Northern Thai curry noodles are a local specialty, known for their rich and unique flavor; Tom Yum soup is tangy and spicy, and mango sticky rice is sweet and soft. Street vendors readily offer stir-fried Thai noodles, grilled pork neck, and refreshing chilled Thai milk tea with a rich fruity aroma. A wide variety of affordable tropical fruits are also available.
                """
            )
        ),
        ExploreCity(
            name: "Lisbon, Portugal",
            subtitle: "A port city of exploration",
            rating: "4.8",
            listImageName: "ExploreCityLisbon",
            heroImageName: "ExploreCityLisbon",
            culture: ExploreCityInfo(
                title: "Lisbon, Portugal",
                detail: """
                Belem, an important port city during the Age of Exploration, boasts both the Belem Tower and the Jeronimos Monastery as UNESCO World Heritage Sites. The entire city is paved with hand-painted colorful tiles, vintage trams weave through the old town's streets, and the Belem district preserves a maritime monument bearing witness to Portugal's history of maritime exploration. Traditional Fado folk song performances are still performed in the old town.
                """
            ),
            nature: ExploreCityInfo(
                title: "nature",
                detail: """
                The city is nestled between mountains and the sea, with the expansive Atlantic Ocean nearby. The surrounding Sintra Mountains are lush and green, with cliffs and coastlines dotted with unique rock formations, and royal gardens flourishing with vegetation. The beaches on the outskirts have fine sand, and the mountains meet the sea, allowing for short trips between forests and seaside towns.
                """
            ),
            food: ExploreCityInfo(
                title: "food",
                detail: """
                The century-old Portuguese egg tarts are creamy and crispy, and the charcoal-grilled sardines are a classic seaside dish. The seafood stew is a collection of fresh seafood such as shrimps and scallops, which is full of meat. It is paired with port wine after the meal, and ham and cheese are also classic Portuguese daily dishes.
                """
            )
        ),
        ExploreCity(
            name: "Vancouver, Canada",
            subtitle: "A diverse immigrant city",
            rating: "4.8",
            listImageName: "ExploreCityVancouver",
            heroImageName: "ExploreCityVancouver",
            culture: ExploreCityInfo(
                title: "Vancouver, Canada",
                detail: """
                Granville Island is a diverse immigrant city that blends European, Asian, and Indigenous cultures. The Granville Island Creative Market brings together artisans and independent galleries, while the Indigenous Art Gallery showcases local totems and sculptures. International cuisines and festivals coexist and thrive here.
                """
            ),
            nature: ExploreCityInfo(
                title: "nature",
                detail: """
                Stanley Park in the city center is bordered by pristine forests on one side and the Pacific coast on the other, with the Capilano Suspension Bridge spanning the rainforest canyon. The surrounding suburbs are nestled against the foothills of the Rocky Mountains, offering stunning views of snow-capped peaks, bays, and pristine rainforests. Outings offer opportunities to observe islands and wild seabirds.
                """
            ),
            food: ExploreCityInfo(
                title: "food",
                detail: """
                West Coast deep-sea salmon is suitable for both smoking and grilling, with tender flesh; maple pancakes are sweet and soft; various seafood soups are made with high-quality ingredients; Canadian ice wine is sweet and mellow; and fusion snacks from various countries are found throughout the city.
                """
            )
        ),
        ExploreCity(
            name: "Busan, South Korea",
            subtitle: "Coastal heritage and markets",
            rating: "4.8",
            listImageName: "ExploreCityBusan",
            heroImageName: "ExploreCityBusan",
            culture: ExploreCityInfo(
                title: "Busan, South Korea",
                detail: """
                Gamcheon is South Korea's second-largest city and a renowned coastal port city with rich cultural heritage. It blends traditional folk customs with modern trends. Haedong Yonggungsa Temple and Beomeosa Temple preserve traditional Korean Buddhist culture and classical architecture. Gamcheon Culture Village, built on the mountainous terrain, features colorful murals and is full of artistic creativity, while also retaining traditional seafood market culture and seaside folk festivals.
                """
            ),
            nature: ExploreCityInfo(
                title: "nature",
                detail: """
                Nestled between mountains and the sea, this coastal city boasts a long and winding coastline. Haeundae and Gwangalli beaches, with their clear waters and soft sand, are popular seaside retreats. Taejongdae coastline features towering cliffs, a picturesque contrast of azure sea and unique rock formations. Surrounded by mountains and forests, the city offers a harmonious blend of nature, dazzling night views, and refreshing, soothing scenery throughout the year.
                """
            ),
            food: ExploreCityInfo(
                title: "food",
                detail: """
                Specializing in fresh seafood dishes, the restaurant offers live octopus hot pot, seafood pancakes, and grilled scallops that are fresh, sweet, and delicious. Their signature Busan fish cake soup is flavorful and aromatic, while the street-style spicy stir-fried rice cakes and seaweed rice rolls are authentically tasted. Korean-style soy-marinated crab and charcoal-grilled meat are rich in flavor, and pairing them with chilled rice wine is a classic local way to enjoy them.
                """
            )
        ),
        ExploreCity(
            name: "Auckland, New Zealand",
            subtitle: "City of Sails",
            rating: "4.8",
            listImageName: "ExploreCityAuckland",
            heroImageName: "ExploreCityAuckland",
            culture: ExploreCityInfo(
                title: "Auckland, New Zealand",
                detail: """
                As New Zealand's largest city, Maori is a quintessential multicultural coastal metropolis, blending European immigrant culture with Maori indigenous culture. Numerous Maori cultural venues showcase ancient tribal totems, songs, dances, and traditional handicrafts. The city's streets exude a relaxed and carefree atmosphere, combining European artistic flair with the rustic charm of Oceania, and boasting a rich outdoor and nautical cultural ambience.
                """
            ),
            nature: ExploreCityInfo(
                title: "nature",
                detail: """
                Renowned as the "City of Sails," the city is surrounded by two major harbors, where volcanic cones, azure seas, and lush meadows blend seamlessly. Mount Eden in the city center offers panoramic views of the city and the seascape. The surrounding suburbs are dotted with black sand beaches, pristine forests, and crystal-clear lakes. With its long, expansive coastline, vast grasslands, and pristine air, the city boasts an exceptional natural environment.
                """
            ),
            food: ExploreCityInfo(
                title: "food",
                detail: """
                The century-old Portuguese egg tarts are creamy and crispy, and the charcoal-grilled sardines are a classic seaside dish. The seafood stew is a collection of fresh seafood such as shrimps and scallops, which is full of meat. It is paired with port wine after the meal, and ham and cheese are also classic Portuguese daily dishes.
                """
            )
        ),
        ExploreCity(
            name: "Barcelona, Spain",
            subtitle: "Catalonia's cultural heartland",
            rating: "4.8",
            listImageName: "ExploreCityBarcelona",
            heroImageName: "ExploreCityBarcelona",
            culture: ExploreCityInfo(
                title: "Barcelona, Spain",
                detail: """
                Catalonia's cultural heartland, home to numerous Gaudi architectural masterpieces, including the Sagrada Familia, Casa Mila, and Casa Batllo, all World Heritage Sites. The Old Town's Gothic Quarter preserves medieval cobblestone streets and ancient Roman ruins, blending a sense of historical grandeur with avant-garde artistic flair. The city also boasts unique Catalan folk customs, flamenco dance performances, and a vibrant street art scene.
                """
            ),
            nature: ExploreCityInfo(
                title: "nature",
                detail: """
                A pearl on the Mediterranean coast, the city is right next to the azure Mediterranean Sea. Barcelona boasts gentle, expansive beaches with stunning scenery. Nearby Montjuic offers panoramic views of the city and the seascape; the mountain is lush with greenery and exquisite gardens, surrounded by a long seaside promenade. With abundant sunshine and a mild climate, the city's mountain and sea scenery is distinctly Southern European.
                """
            ),
            food: ExploreCityInfo(
                title: "food",
                detail: """
                The Mediterranean cuisine is rich and diverse, with the signature paella being a staple of Spain, boasting generous portions of ingredients and a rich aroma. Crispy churros paired with hot chocolate offer a smooth and sweet flavor, while slices of Iberian ham are savory and slightly bitter. Other dishes include gazpacho tomato soup, charcoal-grilled seafood, and local sangria, creating a unique and delicious culinary experience.
                """
            )
        ),
        ExploreCity(
            name: "Da Nang, Vietnam",
            subtitle: "Central Vietnam coastal culture",
            rating: "4.8",
            listImageName: "ExploreCityDaNang",
            heroImageName: "ExploreCityDaNang",
            culture: ExploreCityInfo(
                title: "Da Nang, Vietnam",
                detail: """
                My Khe is a famous coastal city in central Vietnam, blending the culture of the ancient Cham Kingdom with local Vietnamese customs. The French-style fortresses of Ba Na Hills retain the French flair of the colonial era, while the villages around My Khe preserve traditional fishing village life. The Cham Museum displays ancient Cham stone carvings and artifacts, giving the city a unique blend of retro cultural heritage and laid-back, everyday life.
                """
            ),
            nature: ExploreCityInfo(
                title: "nature",
                detail: """
                Boasting a world-class coastline, My Khe Beach is known as "Asia's most beautiful beach" for its fine sand and crystal-clear waters. The Son Cha Peninsula is lush and pristine, while Ba Na Hills is shrouded in mist and clouds, offering cool weather year-round. Hai Van Pass connects mountains and sea, creating a rich tapestry of mountain, water, and seascapes, resulting in stunningly beautiful and refreshing scenery.
                """
            ),
            food: ExploreCityInfo(
                title: "food",
                detail: """
                Vietnamese cuisine is characterized by its light and fresh flavors. The signature Vietnamese rice noodles have a sweet broth and smooth, chewy noodles, while the baguette sandwiches are crispy on the outside and soft on the inside. Fresh lobster, mantis shrimp, and other affordable seafood are grilled to order. Other dishes include Vietnamese spring rolls, drip coffee, and coconut jelly, all refreshing and light, offering a distinctly Southeast Asian culinary experience.
                """
            )
        )
    ]
}
