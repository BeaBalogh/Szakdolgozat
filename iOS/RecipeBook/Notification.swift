//
//  Notification.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 30..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import Foundation
import UserNotifications


class NotificationHelper{
    
    static var notiHelper = NotificationHelper()
 
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func removeAllDeliveredNotifications(){
        userNotificationCenter.removeAllDeliveredNotifications()
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
   
    func sendNotification(request: UNNotificationRequest) {
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
