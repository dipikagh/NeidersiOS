//
//  Routing.swift
//  TCSTransit
//
//  Created by Palash Das, Appsbee LLC on 02/11/20.
//  Copyright © 2020 Intelebee LLC. All rights reserved.
//

import UIKit


final class Routing {
    
    class func decideInitialViewController(window:UIWindow?) {
    
//        if SessionManager.shared.credentialsManager.hasValid() {
//            DispatchQueue.main.async {
//                let myTicketVC = MyTicketViewController(nibName: "MyTicketViewController", bundle: nil)
//                let navigationController = UINavigationController(rootViewController: myTicketVC)
//                navigationController.navigationBar.isHidden = true
//                navigationController.setNeedsStatusBarAppearanceUpdate()
//                window?.rootViewController = navigationController
//                window?.makeKeyAndVisible()
//            }
//
//            SessionManager.shared.renewAuth { (error) in
//                if error != nil {
//
//                }
//            }
//        }
//        else {
//            DispatchQueue.main.async {
//                initiateLoginScreen(window:window)
//            }
//        }
    }
    
    class func initiateLoginScreen(window:UIWindow?) {
        let startVC = LogInVC(nibName: "LogInVC", bundle: nil)
        let navigationController = UINavigationController(rootViewController: startVC)
        navigationController.navigationBar.isHidden = true
        navigationController.setNeedsStatusBarAppearanceUpdate()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
