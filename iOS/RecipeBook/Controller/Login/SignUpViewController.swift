//
//  SignUpViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 12..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        [emailTextField, passwordTextField, firstnameTextField, lastnameTextField].forEach { (field) in
            field?.addTarget(self,
                             action: #selector(editingChanged(_:)),
                             for: .editingChanged)
        }}
    
    
    
    @objc private func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let email       = emailTextField.text,      isValidRegEx(email, RegEx.email),
            let password    = passwordTextField.text,   isValidRegEx(password, RegEx.password),
            let firstName   = firstnameTextField.text,  isValidRegEx(firstName, RegEx.alphabeticStringFirstLetterCaps),
            let lastName    = lastnameTextField.text,   isValidRegEx(lastName, RegEx.alphabeticStringFirstLetterCaps)
            else {
                loginButton.isEnabled = false
                return
        }
        loginButton.isEnabled = true
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
            // ...
        }
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = firstnameTextField.text! + " " + lastnameTextField.text!
        changeRequest?.commitChanges { (error) in
            // ...
        }

    }
    
    func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
    enum RegEx: String {
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
        case password = "^.{6,15}$" // Password length 6-15
        case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$" // SandsHell
    }

}
