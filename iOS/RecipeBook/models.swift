//
//  models.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 10..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import Foundation

//enum  Categories {
//    Beef, Breakfast, Chicken, Dessert, Goat, Lamb, Miscellaneous, Pasta, Pork, Seafood, Side,
//    Starter, Vegan, Vegetarian
//}
//
struct Recipe: Codable{
    var id: String = ""
    var name: String = ""
    var imgURL: String = ""
    var ingredients: [String:String] = [:]
    var category: String? = ""
    var instruction: String? = ""
    var comments: [String] = []
    var image: String = ""
}

struct Comment: Codable{
    var id: String = ""
    var userName: String = ""
    var text: String = ""
    var imgURL: String = ""
    var date: String = ""
    var rating: Float = 0
}

struct User: Codable {
    var favorites: [String] = []
    var cooked: [String] = []
    var myRecipes: [String] = []
}
