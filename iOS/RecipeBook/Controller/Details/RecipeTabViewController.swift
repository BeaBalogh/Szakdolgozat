//
//  RecipeTabViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 12..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class RecipeSplitViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "exit"), style: .done, target: self, action: #selector(self.action(sender:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func action(sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            if Auth.auth().currentUser == nil {
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Login") as! MainLoginViewController
                present(vc, animated: true, completion: nil)
            }
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
