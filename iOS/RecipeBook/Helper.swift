//
//  Helper.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 24..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

//import JJFloatingActionButton
import UIKit

internal struct Helper {
//    static func showAlert(for item: JJActionItem) {
//        showAlert(title: item.titleLabel.text, message: "Item tapped!")
//
//
//    }
    
    static func showTimerAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
                                title: "Dismiss",
                                style: .default,
                                handler: {_ in CountdownTimer.timer.dismissAlarm()
        }))
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    static var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
}
