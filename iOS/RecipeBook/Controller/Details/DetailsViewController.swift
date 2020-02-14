//
//  DetailsViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 18..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import JJFloatingActionButton

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var recipe = Recipe("")
    var ingredientsKeys: [String] = []
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    let actionButton = JJFloatingActionButton()
    let model = RecipeListLogic.shared
    
    @IBOutlet weak var directionsTextView: ContentSizedTextView!
    @IBOutlet weak var ingredientsTable: ContentSizedTableView!
    @IBOutlet weak var cookedButton: UIButton!
    @IBAction func cookedAction(_ sender: Any) {
        model.addOrRemoveCooked(id: recipe.id)
        cookedButton.isEnabled = false
        AlertService.showToast("Added to Cooked list!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTable.delegate = self
        ingredientsTable.dataSource = self
        cookedButton.layer.cornerRadius = 8
        recipe = (tabBarController as! DetailsTabViewController).recipe
        ingredientsKeys = Array(recipe.ingredients.keys)
        print(recipe.id)
        directionsTextView.text = recipe.instruction
        if(model.isCooked(id: recipe.id)){
            cookedButton.isEnabled = false
            cookedButton.titleLabel?.text = "Already added to Cooked!👨‍🍳"
        }
    }
    //MARK: TableView
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTable.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientsTableViewCell
        
        let currentKey = self.ingredientsKeys[indexPath.row]
        cell.nameLabel.text = currentKey
        cell.measureLabel.text = self.recipe.ingredients[currentKey]
        return cell
    }
}
