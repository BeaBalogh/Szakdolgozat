//
//  LoginViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 11..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class MainLoginViewController: UIViewController {

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func onClicked(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().presentingViewController = self

        loginButton.layer.cornerRadius = 4
        signupButton.layer.cornerRadius = 4
        
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        loginButton.layer.masksToBounds = false
        loginButton.layer.shadowRadius = 1.0
        loginButton.layer.shadowOpacity = 0.5
        
        signupButton.layer.shadowColor = UIColor.black.cgColor
        signupButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        signupButton.layer.masksToBounds = false
        signupButton.layer.shadowRadius = 1.0
        signupButton.layer.shadowOpacity = 0.5
        
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
