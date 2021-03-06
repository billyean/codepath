//
//  Filters.swift
//  Yelp
//
//  Created by Yan, Tristan on 4/5/17.
//  Copyright © Tristan Yan. All rights reserved.
//

import Foundation

class Filters {
    let distancesArray: [[String: String]] = [["name" : "Auto", "value": "-1"],
                          ["name" : "0.3 miles", "value": "0.3"],
                          ["name" : "1 mile", "value": "1"],
                          ["name" : "5 miles", "value": "5"],
                          ["name" : "20 miles", "value": "20"]]
    
    let sortByArray: [[String: String]] = [["name" : "Best Match", "value": "0"],
                       ["name" : "Distance", "value": "1"],
                       ["name" : "Rating", "value": "2"],
                       ["name" : "Most Reviewed", "value": "3"]]
    
    var categoriesArray: [[String: String]] = [["name" : "Afghan", "code": "afghani", "selected": "false"],
                      ["name" : "African", "code": "african", "selected": "false"],
                      ["name" : "American, New", "code": "newamerican", "selected": "false"],
                      ["name" : "American, Traditional", "code": "tradamerican", "selected": "false"],
                      ["name" : "Arabian", "code": "arabian", "selected": "false"],
                      ["name" : "Argentine", "code": "argentine", "selected": "false"],
                      ["name" : "Armenian", "code": "armenian", "selected": "false"],
                      ["name" : "Asian Fusion", "code": "asianfusion", "selected": "false"],
                      ["name" : "Asturian", "code": "asturian", "selected": "false"],
                      ["name" : "Australian", "code": "australian", "selected": "false"],
                      ["name" : "Austrian", "code": "austrian", "selected": "false"],
                      ["name" : "Baguettes", "code": "baguettes", "selected": "false"],
                      ["name" : "Bangladeshi", "code": "bangladeshi", "selected": "false"],
                      ["name" : "Barbeque", "code": "bbq", "selected": "false"],
                      ["name" : "Basque", "code": "basque", "selected": "false"],
                      ["name" : "Bavarian", "code": "bavarian", "selected": "false"],
                      ["name" : "Beer Garden", "code": "beergarden", "selected": "false"],
                      ["name" : "Beer Hall", "code": "beerhall", "selected": "false"],
                      ["name" : "Beisl", "code": "beisl", "selected": "false"],
                      ["name" : "Belgian", "code": "belgian", "selected": "false"],
                      ["name" : "Bistros", "code": "bistros", "selected": "false"],
                      ["name" : "Black Sea", "code": "blacksea", "selected": "false"],
                      ["name" : "Brasseries", "code": "brasseries", "selected": "false"],
                      ["name" : "Brazilian", "code": "brazilian", "selected": "false"],
                      ["name" : "Breakfast & Brunch", "code": "breakfast_brunch", "selected": "false"],
                      ["name" : "British", "code": "british", "selected": "false"],
                      ["name" : "Buffets", "code": "buffets", "selected": "false"],
                      ["name" : "Bulgarian", "code": "bulgarian", "selected": "false"],
                      ["name" : "Burgers", "code": "burgers", "selected": "false"],
                      ["name" : "Burmese", "code": "burmese", "selected": "false"],
                      ["name" : "Cafes", "code": "cafes", "selected": "false"],
                      ["name" : "Cafeteria", "code": "cafeteria", "selected": "false"],
                      ["name" : "Cajun/Creole", "code": "cajun", "selected": "false"],
                      ["name" : "Cambodian", "code": "cambodian", "selected": "false"],
                      ["name" : "Canadian", "code": "New)", "selected": "false"],
                      ["name" : "Canteen", "code": "canteen", "selected": "false"],
                      ["name" : "Caribbean", "code": "caribbean", "selected": "false"],
                      ["name" : "Catalan", "code": "catalan", "selected": "false"],
                      ["name" : "Chech", "code": "chech", "selected": "false"],
                      ["name" : "Cheesesteaks", "code": "cheesesteaks", "selected": "false"],
                      ["name" : "Chicken Shop", "code": "chickenshop", "selected": "false"],
                      ["name" : "Chicken Wings", "code": "chicken_wings", "selected": "false"],
                      ["name" : "Chilean", "code": "chilean", "selected": "false"],
                      ["name" : "Chinese", "code": "chinese", "selected": "false"],
                      ["name" : "Comfort Food", "code": "comfortfood", "selected": "false"],
                      ["name" : "Corsican", "code": "corsican", "selected": "false"],
                      ["name" : "Creperies", "code": "creperies", "selected": "false"],
                      ["name" : "Cuban", "code": "cuban", "selected": "false"],
                      ["name" : "Curry Sausage", "code": "currysausage", "selected": "false"],
                      ["name" : "Cypriot", "code": "cypriot", "selected": "false"],
                      ["name" : "Czech", "code": "czech", "selected": "false"],
                      ["name" : "Czech/Slovakian", "code": "czechslovakian", "selected": "false"],
                      ["name" : "Danish", "code": "danish", "selected": "false"],
                      ["name" : "Delis", "code": "delis", "selected": "false"],
                      ["name" : "Diners", "code": "diners", "selected": "false"],
                      ["name" : "Dumplings", "code": "dumplings", "selected": "false"],
                      ["name" : "Eastern European", "code": "eastern_european", "selected": "false"],
                      ["name" : "Ethiopian", "code": "ethiopian", "selected": "false"],
                      ["name" : "Fast Food", "code": "hotdogs", "selected": "false"],
                      ["name" : "Filipino", "code": "filipino", "selected": "false"],
                      ["name" : "Fish & Chips", "code": "fishnchips", "selected": "false"],
                      ["name" : "Fondue", "code": "fondue", "selected": "false"],
                      ["name" : "Food Court", "code": "food_court", "selected": "false"],
                      ["name" : "Food Stands", "code": "foodstands", "selected": "false"],
                      ["name" : "French", "code": "french", "selected": "false"],
                      ["name" : "French Southwest", "code": "sud_ouest", "selected": "false"],
                      ["name" : "Galician", "code": "galician", "selected": "false"],
                      ["name" : "Gastropubs", "code": "gastropubs", "selected": "false"],
                      ["name" : "Georgian", "code": "georgian", "selected": "false"],
                      ["name" : "German", "code": "german", "selected": "false"],
                      ["name" : "Giblets", "code": "giblets", "selected": "false"],
                      ["name" : "Gluten-Free", "code": "gluten_free", "selected": "false"],
                      ["name" : "Greek", "code": "greek", "selected": "false"],
                      ["name" : "Halal", "code": "halal", "selected": "false"],
                      ["name" : "Hawaiian", "code": "hawaiian", "selected": "false"],
                      ["name" : "Heuriger", "code": "heuriger", "selected": "false"],
                      ["name" : "Himalayan/Nepalese", "code": "himalayan", "selected": "false"],
                      ["name" : "Hong Kong Style Cafe", "code": "hkcafe", "selected": "false"],
                      ["name" : "Hot Dogs", "code": "hotdog", "selected": "false"],
                      ["name" : "Hot Pot", "code": "hotpot", "selected": "false"],
                      ["name" : "Hungarian", "code": "hungarian", "selected": "false"],
                      ["name" : "Iberian", "code": "iberian", "selected": "false"],
                      ["name" : "Indian", "code": "indpak", "selected": "false"],
                      ["name" : "Indonesian", "code": "indonesian", "selected": "false"],
                      ["name" : "International", "code": "international", "selected": "false"],
                      ["name" : "Irish", "code": "irish", "selected": "false"],
                      ["name" : "Island Pub", "code": "island_pub", "selected": "false"],
                      ["name" : "Israeli", "code": "israeli", "selected": "false"],
                      ["name" : "Italian", "code": "italian", "selected": "false"],
                      ["name" : "Japanese", "code": "japanese", "selected": "false"],
                      ["name" : "Jewish", "code": "jewish", "selected": "false"],
                      ["name" : "Kebab", "code": "kebab", "selected": "false"],
                      ["name" : "Korean", "code": "korean", "selected": "false"],
                      ["name" : "Kosher", "code": "kosher", "selected": "false"],
                      ["name" : "Kurdish", "code": "kurdish", "selected": "false"],
                      ["name" : "Laos", "code": "laos", "selected": "false"],
                      ["name" : "Laotian", "code": "laotian", "selected": "false"],
                      ["name" : "Latin American", "code": "latin", "selected": "false"],
                      ["name" : "Live/Raw Food", "code": "raw_food", "selected": "false"],
                      ["name" : "Lyonnais", "code": "lyonnais", "selected": "false"],
                      ["name" : "Malaysian", "code": "malaysian", "selected": "false"],
                      ["name" : "Meatballs", "code": "meatballs", "selected": "false"],
                      ["name" : "Mediterranean", "code": "mediterranean", "selected": "false"],
                      ["name" : "Mexican", "code": "mexican", "selected": "false"],
                      ["name" : "Middle Eastern", "code": "mideastern", "selected": "false"],
                      ["name" : "Milk Bars", "code": "milkbars", "selected": "false"],
                      ["name" : "Modern Australian", "code": "modern_australian", "selected": "false"],
                      ["name" : "Modern European", "code": "modern_european", "selected": "false"],
                      ["name" : "Mongolian", "code": "mongolian", "selected": "false"],
                      ["name" : "Moroccan", "code": "moroccan", "selected": "false"],
                      ["name" : "New Zealand", "code": "newzealand", "selected": "false"],
                      ["name" : "Night Food", "code": "nightfood", "selected": "false"],
                      ["name" : "Norcinerie", "code": "norcinerie", "selected": "false"],
                      ["name" : "Open Sandwiches", "code": "opensandwiches", "selected": "false"],
                      ["name" : "Oriental", "code": "oriental", "selected": "false"],
                      ["name" : "Pakistani", "code": "pakistani", "selected": "false"],
                      ["name" : "Parent Cafes", "code": "eltern_cafes", "selected": "false"],
                      ["name" : "Parma", "code": "parma", "selected": "false"],
                      ["name" : "Persian/Iranian", "code": "persian", "selected": "false"],
                      ["name" : "Peruvian", "code": "peruvian", "selected": "false"],
                      ["name" : "Pita", "code": "pita", "selected": "false"],
                      ["name" : "Pizza", "code": "pizza", "selected": "false"],
                      ["name" : "Polish", "code": "polish", "selected": "false"],
                      ["name" : "Portuguese", "code": "portuguese", "selected": "false"],
                      ["name" : "Potatoes", "code": "potatoes", "selected": "false"],
                      ["name" : "Poutineries", "code": "poutineries", "selected": "false"],
                      ["name" : "Pub Food", "code": "pubfood", "selected": "false"],
                      ["name" : "Rice", "code": "riceshop", "selected": "false"],
                      ["name" : "Romanian", "code": "romanian", "selected": "false"],
                      ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken", "selected": "false"],
                      ["name" : "Rumanian", "code": "rumanian", "selected": "false"],
                      ["name" : "Russian", "code": "russian", "selected": "false"],
                      ["name" : "Salad", "code": "salad", "selected": "false"],
                      ["name" : "Sandwiches", "code": "sandwiches", "selected": "false"],
                      ["name" : "Scandinavian", "code": "scandinavian", "selected": "false"],
                      ["name" : "Scottish", "code": "scottish", "selected": "false"],
                      ["name" : "Seafood", "code": "seafood", "selected": "false"],
                      ["name" : "Serbo Croatian", "code": "serbocroatian", "selected": "false"],
                      ["name" : "Signature Cuisine", "code": "signature_cuisine", "selected": "false"],
                      ["name" : "Singaporean", "code": "singaporean", "selected": "false"],
                      ["name" : "Slovakian", "code": "slovakian", "selected": "false"],
                      ["name" : "Soul Food", "code": "soulfood", "selected": "false"],
                      ["name" : "Soup", "code": "soup", "selected": "false"],
                      ["name" : "Southern", "code": "southern", "selected": "false"],
                      ["name" : "Spanish", "code": "spanish", "selected": "false"],
                      ["name" : "Steakhouses", "code": "steak", "selected": "false"],
                      ["name" : "Sushi Bars", "code": "sushi", "selected": "false"],
                      ["name" : "Swabian", "code": "swabian", "selected": "false"],
                      ["name" : "Swedish", "code": "swedish", "selected": "false"],
                      ["name" : "Swiss Food", "code": "swissfood", "selected": "false"],
                      ["name" : "Tabernas", "code": "tabernas", "selected": "false"],
                      ["name" : "Taiwanese", "code": "taiwanese", "selected": "false"],
                      ["name" : "Tapas Bars", "code": "tapas", "selected": "false"],
                      ["name" : "Tapas/Small Plates", "code": "tapasmallplates", "selected": "false"],
                      ["name" : "Tex-Mex", "code": "tex-mex", "selected": "false"],
                      ["name" : "Thai", "code": "thai", "selected": "false"],
                      ["name" : "Traditional Norwegian", "code": "norwegian", "selected": "false"],
                      ["name" : "Traditional Swedish", "code": "traditional_swedish", "selected": "false"],
                      ["name" : "Trattorie", "code": "trattorie", "selected": "false"],
                      ["name" : "Turkish", "code": "turkish", "selected": "false"],
                      ["name" : "Ukrainian", "code": "ukrainian", "selected": "false"],
                      ["name" : "Uzbek", "code": "uzbek", "selected": "false"],
                      ["name" : "Vegan", "code": "vegan", "selected": "false"],
                      ["name" : "Vegetarian", "code": "vegetarian", "selected": "false"],
                      ["name" : "Venison", "code": "venison", "selected": "false"],
                      ["name" : "Vietnamese", "code": "vietnamese", "selected": "false"],
                      ["name" : "Wok", "code": "wok", "selected": "false"],
                      ["name" : "Wraps", "code": "wraps", "selected": "false"],
                      ["name" : "Yugoslav", "code": "yugoslav", "selected": "false"]]
    
    var offeringADeal: [[String: String]] = [["name": "Offering A Deal", "selected": "false"]]
    
    var distances: Int = 0
    
    var sortBy: Int = 0
    
    var sort: YelpSortMode? {
        get {
            switch sortBy {
            case 0:
                return YelpSortMode.bestMatched
            case 1:
                return YelpSortMode.distance
            case 2:
                return YelpSortMode.highestRated
            default:
                return nil
            }
        }
        set (newSort) {
            sortBy = (newSort?.rawValue)!
        }
    }
    
    var deal: Bool? {
        get {
            return "true" == offeringADeal[0]["selected"]!
        }
        set (newDeal) {
            print("\(newDeal!)")
            offeringADeal[0]["selected"] = "\(newDeal!)"
        }
    }
    
    var radius: Double? {
        get {
            switch distances {
            case 0:
                return nil
            default:
                return Double(distancesArray[distances]["value"]!)! * 1600
            }
        }
        set (newRadius) {
            let km = Int(newRadius! / 160)
            switch km {
            case 3:
                distances = 1
            case 10:
                distances = 2
            case 50:
                distances = 3
            case 200:
                distances = 4
            default:
                distances = 0
            }
        }
    }
    
    var categories: [String]? {
        get {
            let selectedCategories = categoriesArray.filter({row in
                return row["selected"]! == "true"
            })
            let categoriesCodes = selectedCategories.map(){ return $0["code"]!}
            return categoriesCodes
        }
        
        set (newCategories) {
            for index in 0..<categoriesArray.count {
                let category = categoriesArray[index]["code"]!
                if (newCategories?.contains(category))! {
                    categoriesArray[index]["selected"] = "true"
                } else {
                    categoriesArray[index]["selected"] = "false"
                }
            }
        }
    }

    init() {

    }
}
