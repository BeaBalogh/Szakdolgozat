//
//  Responses.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 12. 02..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import Foundation


class Meal{
    init(json: [String : Any]){
        self.idMeal = json["idMeal"] as? String ?? ""
        self.strMeal = json["strMeal"] as? String ?? ""
        self.strCategory = json["strCategory"] as? String ?? ""
        self.strInstructions = json["strInstructions"] as? String ?? ""
        self.strMealThumb = json["strMealThumb"] as? String ?? ""
        self.strIngredient1 = json["strIngredient1"] as? String ?? ""
        self.strIngredient2 = json["strIngredient2"] as? String ?? ""
        self.strIngredient3 = json["strIngredient3"] as? String ?? ""
        self.strIngredient4 = json["strIngredient4"] as? String ?? ""
        self.strIngredient5 = json["strIngredient5"] as? String ?? ""
        self.strIngredient6 = json["strIngredient6"] as? String ?? ""
        self.strIngredient7 = json["strIngredient7"] as? String ?? ""
        self.strIngredient8 = json["strIngredient8"] as? String ?? ""
        self.strIngredient9 = json["strIngredient9"] as? String ?? ""
        self.strIngredient10 = json["strIngredient10"] as? String ?? ""
        self.strIngredient11 = json["strIngredient11"] as? String ?? ""
        self.strIngredient12 = json["strIngredient12"] as? String ?? ""
        self.strIngredient13 = json["strIngredient13"] as? String ?? ""
        self.strIngredient14 = json["strIngredient14"] as? String ?? ""
        self.strIngredient15 = json["strIngredient15"] as? String ?? ""
        self.strIngredient16 = json["strIngredient16"] as? String ?? ""
        self.strIngredient17 = json["strIngredient17"] as? String ?? ""
        self.strIngredient18 = json["strIngredient18"] as? String ?? ""
        self.strIngredient19 = json["strIngredient19"] as? String ?? ""
        self.strIngredient20 = json["strIngredient20"] as? String ?? ""
        self.strMeasure1 = json["strMeasure1"] as? String ?? ""
        self.strMeasure2 = json["strMeasure2"] as? String ?? ""
        self.strMeasure3 = json["strMeasure3"] as? String ?? ""
        self.strMeasure4 = json["strMeasure4"] as? String ?? ""
        self.strMeasure5 = json["strMeasure5"] as? String ?? ""
        self.strMeasure6 = json["strMeasure6"] as? String ?? ""
        self.strMeasure7 = json["strMeasure7"] as? String ?? ""
        self.strMeasure8 = json["strMeasure8"] as? String ?? ""
        self.strMeasure9 = json["strMeasure9"] as? String ?? ""
        self.strMeasure10 = json["strMeasure10"] as? String ?? ""
        self.strMeasure11 = json["strMeasure11"] as? String ?? ""
        self.strMeasure12 = json["strMeasure12"] as? String ?? ""
        self.strMeasure13 = json["strMeasure13"] as? String ?? ""
        self.strMeasure14 = json["strMeasure14"] as? String ?? ""
        self.strMeasure15 = json["strMeasure15"] as? String ?? ""
        self.strMeasure16 = json["strMeasure16"] as? String ?? ""
        self.strMeasure17 = json["strMeasure17"] as? String ?? ""
        self.strMeasure18 = json["strMeasure18"] as? String ?? ""
        self.strMeasure19 = json["strMeasure19"] as? String ?? ""
        self.strMeasure20 = json["strMeasure20"] as? String ?? ""
        
    }
    
    let idMeal: String 
    let strMeal: String
    let strCategory : String
    let strInstructions : String
    let strMealThumb : String
    let strIngredient1 : String
    let strIngredient2 : String
    let strIngredient3 : String
    let strIngredient4 : String
    let strIngredient5 : String
    let strIngredient6 : String
    let strIngredient7 : String
    let strIngredient8 : String
    let strIngredient9 : String
    let strIngredient10 : String
    let strIngredient11 : String
    let strIngredient12 : String
    let strIngredient13 : String
    let strIngredient14 : String
    let strIngredient15 : String
    let strIngredient16 : String
    let strIngredient17 : String
    let strIngredient18 : String
    let strIngredient19 : String
    let strIngredient20 : String
    let strMeasure1 : String
    let strMeasure2 : String
    let strMeasure3 : String
    let strMeasure4 : String
    let strMeasure5 : String
    let strMeasure6 : String
    let strMeasure7 : String
    let strMeasure8 : String
    let strMeasure9 : String
    let strMeasure10 : String
    let strMeasure11 : String
    let strMeasure12 : String
    let strMeasure13 : String
    let strMeasure14 : String
    let strMeasure15 : String
    let strMeasure16 : String
    let strMeasure17 : String
    let strMeasure18 : String
    let strMeasure19 : String
    let strMeasure20 : String
    
    
    
    func toRecipe() ->Recipe{
        
        var ingredients : [String:String] = [:]
        ingredients[self.strIngredient1] = self.strMeasure1
        ingredients[self.strIngredient2] = self.strMeasure2
        ingredients[self.strIngredient3] = self.strMeasure3
        ingredients[self.strIngredient4] = self.strMeasure4
        ingredients[self.strIngredient5] = self.strMeasure5
        ingredients[self.strIngredient6] = self.strMeasure6
        ingredients[self.strIngredient7] = self.strMeasure7
        ingredients[self.strIngredient8] = self.strMeasure8
        ingredients[self.strIngredient9] = self.strMeasure9
        ingredients[self.strIngredient10] = self.strMeasure10
        ingredients[self.strIngredient11] = self.strMeasure11
        ingredients[self.strIngredient12] = self.strMeasure12
        ingredients[self.strIngredient13] = self.strMeasure13
        ingredients[self.strIngredient14] = self.strMeasure14
        ingredients[self.strIngredient15] = self.strMeasure15
        ingredients[self.strIngredient16] = self.strMeasure16
        ingredients[self.strIngredient17] = self.strMeasure17
        ingredients[self.strIngredient18] = self.strMeasure18
        ingredients[self.strIngredient19] = self.strMeasure19
        ingredients[self.strIngredient20] = self.strMeasure20
        ingredients.removeValue(forKey: "")
        
        return Recipe(id: self.idMeal, name: self.strMeal, imgURL: self.strMealThumb, ingredients: ingredients, category: self.strCategory, instruction: self.strInstructions, comments: [], image: nil)
    }
}



