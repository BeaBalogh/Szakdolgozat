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
    
    @IBOutlet weak var directionsTextView: ContentSizedTextView!
    @IBOutlet weak var ingredientsTable: ContentSizedTableView!
    var recipe = Recipe()
    var ingredientsKeys: [String] = []
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    private let actionButton = JJFloatingActionButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTable.delegate = self
        ingredientsTable.dataSource = self
        recipe = (tabBarController as! DetailsTabViewController).recipe
        ingredientsKeys = Array(recipe.ingredients.keys)
        directionsTextView.text = recipe.instruction
        
//        actionButton.buttonColor = .init(red: 252/255, green: 212/255, blue: 72/255, alpha: 1)
//
//        actionButton.addItem(title: "Timer", image: #imageLiteral(resourceName: "icons8-alarm-clock-50")) { item in
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let timerVC = storyboard.instantiateViewController(withIdentifier: "SetTimer") as! TimerPopUpViewController
//
//            self.present(timerVC, animated: true, completion: nil)
//        }
//
//        actionButton.display(inViewController: self)
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
final class ContentSizedTableView: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: frame.width, height: contentSize.height)
    }
}
final class ContentSizedTextView: UITextView {
    
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: frame.width, height: contentSize.height)
    }
}
