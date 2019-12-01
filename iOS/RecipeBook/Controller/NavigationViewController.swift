//
//  NavigationViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 29..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import JJFloatingActionButton

class NavigationViewController: UINavigationController {
    private let actionButton = JJFloatingActionButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.buttonColor = .init(red: 252/255, green: 212/255, blue: 72/255, alpha: 1)
        
        actionButton.addItem(title: "Timer", image: #imageLiteral(resourceName: "icons8-alarm-clock-50")) { item in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let timerVC = storyboard.instantiateViewController(withIdentifier: "SetTimer") as! TimerPopUpViewController
            
            self.present(timerVC, animated: true, completion: nil)
        }
        
        actionButton.display(inViewController: self)
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
