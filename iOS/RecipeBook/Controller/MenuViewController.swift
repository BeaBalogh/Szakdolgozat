//
//  MenuViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 20..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import SideMenuSwift

class MenuViewController: UIViewController {
    let userDefault = UserDefaults.standard

    @IBOutlet weak var pofileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet var HomeTap: UITapGestureRecognizer!
    @IBOutlet var CookedTap: UITapGestureRecognizer!
    @IBOutlet var FavTap: UITapGestureRecognizer!
    @IBOutlet var NewTap: UITapGestureRecognizer!
    @IBOutlet var MyRecipesTap: UITapGestureRecognizer!
    @IBAction func homeTap(_ sender: Any) {
        
        sideMenuController?.setContentViewController(with: "0", animated: false)
        sideMenuController?.hideMenu()
        
        if let identifier = sideMenuController?.currentCacheIdentifier() {
            print("[Example] View Controller Cache Identifier: \(identifier)")
        }
    }
    @IBAction func favTap(_ sender: UITapGestureRecognizer!) {
        
        sideMenuController?.setContentViewController(with: "1", animated: false)
        sideMenuController?.hideMenu()
        
        if let identifier = sideMenuController?.currentCacheIdentifier() {
            print("[Example] View Controller Cache Identifier: \(identifier)")
        }
    }
    @IBAction func cookedTap(_ sender: UITapGestureRecognizer!) {
        
        sideMenuController?.setContentViewController(with: "2", animated: false)
        sideMenuController?.hideMenu()
        
        if let identifier = sideMenuController?.currentCacheIdentifier() {
            print("[Example] View Controller Cache Identifier: \(identifier)")
        }
    }
    @IBAction func myRecipesTap(_ sender: UITapGestureRecognizer!) {
        
        sideMenuController?.setContentViewController(with: "3", animated: false)
        sideMenuController?.hideMenu()
        
        if let identifier = sideMenuController?.currentCacheIdentifier() {
            print("[Example] View Controller Cache Identifier: \(identifier)")
        }
    }
    @IBAction func newTap(_ sender: Any) {

        sideMenuController?.setContentViewController(with: "4", animated: false)
        sideMenuController?.hideMenu()
        
        if let identifier = sideMenuController?.currentCacheIdentifier() {
            print("[Example] View Controller Cache Identifier: \(identifier)")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        FavTap.name = "Favorites"
        CookedTap.name = "Cooked"
        MyRecipesTap.name = "My Recipes"
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "FavNavController")
        }, with: "1")
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "CookedNavController")
        }, with: "2")
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "MyRecipesNavController")
        }, with: "3")
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "NewNavController")
        }, with: "4")
        
        sideMenuController?.delegate = self
        let currentuser = Auth.auth().currentUser
        usernameLabel.text = currentuser?.displayName
        emailLabel.text = currentuser?.email
        if let cachedImage = userDefault.value(forKey: "profilePhoto") as? Data{
            pofileImageView.image = UIImage(data: cachedImage)
        } else {
            let url = URL(string: "http://www.seedcoworking.com/wp-content/uploads/2018/06/placeholder.jpg")!
            let data = try? Data(contentsOf: currentuser?.photoURL ?? url)
            if (data != nil) {
                pofileImageView.image = UIImage(data: data!)
//                imageCache.setObject(pofileImageView.image!, forKey: "profilePhoto")
                userDefault.set(pofileImageView.image?.jpegData(compressionQuality: 1), forKey: "profilePhoto")
            }else{
                pofileImageView.image = #imageLiteral(resourceName: "placeholder")
            }
        }
    }
    private func configureView() {
        SideMenuController.preferences.basic.menuWidth = 240
        SideMenuController.preferences.basic.statusBarBehavior = .hideOnMenu
        SideMenuController.preferences.basic.position = .under
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.enablePanGesture = true
        SideMenuController.preferences.basic.supportedOrientations = .portrait
        SideMenuController.preferences.basic.shouldRespectLanguageDirection = true

    }
}

extension MenuViewController: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController,
                            animationControllerFrom fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
    }

    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller will show [\(viewController)]")
    }

    func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller did show [\(viewController)]")
    }

    func sideMenuControllerWillHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will hide")
    }

    func sideMenuControllerDidHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did hide.")
    }

    func sideMenuControllerWillRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will reveal.")
    }

    func sideMenuControllerDidRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did reveal.")
    }
}
