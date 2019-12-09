//
//  AppDelegate.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 05..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SideMenuSwift
import UserNotifications

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    
    var window: UIWindow?

    // Local notifications
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    //Google sign in
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        var credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        if let id = userDefault.string(forKey: "tokenId"),
            let access = userDefault.string(forKey: "accessToken"){
            credential = GoogleAuthProvider.credential(withIDToken: id,
                                                           accessToken: access)
        }
    
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            self.userDefault.set(authentication.idToken, forKey: "idToken")
            self.userDefault.set(authentication.accessToken, forKey: "accessToken")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecipesNav") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vc
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
    
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        configureSideMenu()
        
//        UNUserNotificationCenter.current().requestAuthorization(options:
//        [.badge, .sound, .alert]) { granted, error in
//            guard granted else { return }
//            DispatchQueue.main.async {
//                application.registerForRemoteNotifications()
//            }
//        }
        
        return true
    }
    
    private func configureSideMenu() {
        SideMenuController.preferences.basic.menuWidth = 240
        SideMenuController.preferences.basic.defaultCacheKey = "0"
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
}

