//
//  DetailsTabViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 18..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit

class DetailsTabViewController: UITabBarController {

    var recipe:Recipe = Recipe()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = recipe.name
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
