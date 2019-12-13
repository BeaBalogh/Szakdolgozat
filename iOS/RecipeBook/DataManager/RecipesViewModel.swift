//
//  ViewModel.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 12. 03..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import Foundation
import Reachability

class RecipesViewModel: NSObject{
    static public let shared = RecipesViewModel()
    @objc dynamic var randomRecipes: [Recipe] = []
    @objc dynamic var searchRecipes: [Recipe] = []
    @objc dynamic var savedRecipes: [Recipe] = []
    @objc dynamic var user: User? = nil
    
    let firebase = FirebaseService.shared

    override private init() {
        super.init()
        getUser()
    }
    
    func isFavorite(id: String) -> Bool {
        return user?.favorites.contains(id) ?? false
    }
    func addOrRemoveFavorite(id: String){
        if(isFavorite(id: id)){
            user?.favorites.remove(at: (user?.favorites.firstIndex(of: id))!)
        }else{
            user?.favorites.append(id)
        }
        firebase.updateUserList(list: user!.favorites, listName: "favorites")
    }
    func isCooked(id: String) -> Bool {
        return user?.cooked.contains(id) ?? false
    }
    func addOrRemoveCooked(id: String){
        if(isCooked(id: id)){
            user?.cooked.remove(at: (user?.cooked.firstIndex(of: id))!)
        }else{
            user?.cooked.append(id)
        }
        firebase.updateUserList(list: user!.cooked, listName: "cooked")
    }
    func isMyRecipe(id: String) -> Bool {
        return user?.myRecipes.contains(id) ?? false
    }
    func addOrRemoveMyRecipe(id: String){
        if(isMyRecipe(id: id)){
            user?.myRecipes.remove(at: (user?.myRecipes.firstIndex(of: id))!)
        }else{
            user?.myRecipes.append(id)
        }
        firebase.updateUserList(list: user!.myRecipes, listName: "myRecipes")
    }
    func getUser(){
        firebase.getUserData { (user, error) in
            if(error == nil){
                self.user = user!
                self.getSaved()
            }
        }
    }
    
    func getSaved(){
        let reachability = try! Reachability()
        if(reachability.connection != .unavailable){
            firebase.getRecipes(){ recipeArray, error in
                if (error != nil) {
                    
                    return
                }
                for recipe in recipeArray{
                    if(self.isMyRecipe(id: recipe.id) || self.isFavorite(id: recipe.id) || self.isCooked(id: recipe.id)){
                        if(recipe.imgURL.contains("http")){
                            recipe.image =  try? Data(contentsOf: URL(string: recipe.imgURL)!)}
                        PersistentService.shared.writePlist(namePlist: "Recipes", key: recipe.id, data: recipe.getDictionary() as AnyObject)
                    }
                }
                self.savedRecipes = self.readSaved()
            }
        }
        else{ savedRecipes = readSaved() }
    }

    func readSaved() -> [Recipe]{
        let data = PersistentService.shared.readAll(namePlist: "Recipes") as! [String: Any]
        var list: [Recipe] = []
        for item in data {
            let recipe = Recipe(dictionary: item.value as! [String: Any])
            list.append(recipe)
        }
        return list
    }
    func getFavs()-> [Recipe]{
        var list: [Recipe] = []
        for recipe in savedRecipes {
            if(isFavorite(id: recipe.id)){
                list.append(recipe)
            }
        }
        return list
    }
    func getCooked()-> [Recipe]{
        var list: [Recipe] = []
        for recipe in savedRecipes {
            if(isCooked(id: recipe.id)){
                list.append(recipe)
            }
        }
        return list
    }
    func getMyRecipes()-> [Recipe]{
        var list: [Recipe] = []
        for recipe in savedRecipes {
            if(isMyRecipe(id: recipe.id)){
                list.append(recipe)
            }
        }
        return list
    }
    
    func getRandom(){
        let session = URLSession.shared
        let url = URL(string: "https://www.themealdb.com/api/json/v2/1/randomselection.php")!
        
        session.dataTask(with: url) { data, _, error in
            var list:[Recipe]=[]
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Array<Any>] {
                for case let kaja as [String:Any] in json["meals"]! {
                    let meal = Meal(json: kaja)
                    list.append(meal.toRecipe())
                }
            }
            self.randomRecipes = list
            }.resume()

    }
    
    func search(name: String){
        let session = URLSession.shared
        let url = URL(string: "https://www.themealdb.com/api/json/v2/1/search.php?s=" + name)!
        
        session.dataTask(with: url) { data, _, error in
            var list:[Recipe]=[]
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Array<Any>] {
                for case let kaja as [String:Any] in json["meals"]! {
                    let meal = Meal(json: kaja)
                    list.append(meal.toRecipe())
                }
            }
            self.searchRecipes = list
        }.resume()
    }
}
  
