//
//  LaunchViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 12..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import SideMenuSwift

class LaunchViewController: UIViewController {

    override func viewDidLoad() {

//        GIDSignIn.sharedInstance().presentingViewController = self
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Login") as! MainLoginViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vc
        }
        else{
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "RecipesNav") as! UINavigationController
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = vc
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let contentViewController = storyboard.instantiateViewController(withIdentifier: "RecipesNav") as! UINavigationController
            let menuViewController = storyboard.instantiateViewController(withIdentifier: "Menu") 
            let vc = SideMenuController(contentViewController: contentViewController,
                                        menuViewController: menuViewController)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vc
        
        }
        
        super.viewDidLoad()

        
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
