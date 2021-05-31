//
//  AlertDisplayer.swift
//  TCS Transit
//
//  Created by Palash Das, Appsbee LLC on 22/10/20.
//  Copyright © 2020 Intelebee LLC. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Alerts

enum DisplayType {
    case custom(actions: [UIAlertAction]) /// provide an array of custom `UIAlertActions`
    case `default`
}

protocol AlertDisplayer {
    ///  Display an `UIAlertController` with `alert` type
    /// - Parameters:
    ///  - title: A title of  `UIAlertController` of `String` type
    ///  - message:  A message of  `UIAlertController` of `String` type
    func showAlertWith(title:String, message:String, type:DisplayType)
}

extension AlertDisplayer where Self: UIViewController {
    
    func showAlertWith(title:String = AppConstant.appTitle, message:String, type:DisplayType = .default) {
        let alert = UIAlertController(title:title,message:message,preferredStyle: .alert)
        
        let titleFont = [NSAttributedString.Key.font: UIFont.setLatoFont(name: .latoBold, size: 18)]
        let messageFont = [NSAttributedString.Key.font: UIFont.setLatoFont(name: .latoRegular, size: 14)]
        
        let titleAttrString = NSAttributedString(string: title, attributes: titleFont)
        let messageAttrString = NSAttributedString(string: message, attributes: messageFont)
        
        alert.setValue(titleAttrString, forKey: "attributedTitle")
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        
        switch type {
        case.custom (let actions):
            actions.forEach { action in
                alert.addAction(action)
                
            }
        default:
            let actionOK = UIAlertAction(title:"OK",style:.default, handler: nil)
            alert.addAction(actionOK)
        }
        
        alert.view.backgroundColor = UIColor(red: 241/255, green: 242/255, blue: 242/255, alpha: 1)
        alert.view.tintColor = UIColor(named: "CustomOrange")
        alert.view.layer.cornerRadius = 0
        present(alert,animated: true)
        
    }
}
