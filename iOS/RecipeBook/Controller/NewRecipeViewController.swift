//
//  NewRecipeViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 21..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit

class NewRecipeViewController: UIViewController {

    @IBAction func showMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
