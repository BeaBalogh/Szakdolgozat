//
//  ListsViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 12. 06..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit

class FavoritesViewController: RecipesWithoutSearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        // Do any additional setup after loading the view.
    }
 
    override func observeModel() {
        self.observers = [
            model.observe(\RecipeListLogic.savedRecipes, options: [.initial]) { (model, change) in
                var list: [Recipe] = []
                for item in model.savedRecipes{
                    if(self.model.isFavorite(id: item.id)){
                        list.append(item)
                    }
                }
                self.dataSource = list
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        ]
    }
}
class CookedViewController: RecipesWithoutSearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cooked"
        // Do any additional setup after loading the view.
    }
    override func observeModel() {
        self.observers = [
            model.observe(\RecipeListLogic.savedRecipes, options: [.initial]) { (model, change) in
                var list: [Recipe] = []
                for item in model.savedRecipes{
                    if(self.model.isCooked(id: item.id)){
                        list.append(item)
                    }
                }
                self.dataSource = list
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        ]
    }
}

class MyRecipesViewController: RecipesWithoutSearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Recipes"
        // Do any additional setup after loading the view.
    }
    override func observeModel() {
        self.observers = [
            model.observe(\RecipeListLogic.savedRecipes, options: [.initial]) { (model, change) in
                var list: [Recipe] = []
                for item in model.savedRecipes{
                    if(self.model.isMyRecipe(id: item.id)){
                        list.append(item)
                    }
                }
                self.dataSource = list
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        ]
    }
}
