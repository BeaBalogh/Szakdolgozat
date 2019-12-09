//
//  DetailsTabViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 18..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit

class DetailsTabViewController: UITabBarController {
    let model = RecipesModel.shared
    var recipe:Recipe = Recipe("")
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBAction func addFavs(_ sender: Any) {
        model.addOrRemoveFavorite(id: recipe.id)
        if( model.isFavorite(id: recipe.id)){
            favButton.image = #imageLiteral(resourceName: "icons8-heart-30")
        } else {
            favButton.image = #imageLiteral(resourceName: "icons8-heart-outline-30")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = recipe.name
        FirebaseService.shared.loadComments(id: recipe.id) { (comments, error) in
            if(error == nil){
                self.recipe.comments = comments
            }
        }
        if( model.isFavorite(id: recipe.id)){
            favButton.image = #imageLiteral(resourceName: "icons8-heart-90")
        } else {
            favButton.image = #imageLiteral(resourceName: "icons8-heart-outline-30")
        }    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
