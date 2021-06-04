//
//  SidePanelViewController.swift
//  TCSTransit
//
//  Created by Palash Das, Appsbee LLC on 02/11/20.
//  Copyright © 2020 Intelebee. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit



enum MenuOptions {
    case loggedIn
    case new
}

protocol SidePanelDelegate:class {
    func didDisplayMenu(status:Bool)
    func showLanguagePopUP(status:Bool)
    
}

class SidePanelViewController: UIViewController,AlertDisplayer {
    
    // MARK: - Properties
    @IBOutlet weak var viewContainer:UIView!
    @IBOutlet weak var tblSidePanel:UITableView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserName2: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    
    @IBOutlet weak var lblHello: UILabel!
    
    
    static let `default` = SidePanelViewController()
    var delegate: SidePanelDelegate?
    var viewModelSidePanel: SidePanelViewModelProtocol?
    var isloggedin:Bool = false
    var isSelectLogOut:Bool = false
    
    var arrDefaultContents = [["Home".localized(),"home_icon"],["Edit Password".localized(),"edit_password_icon"],["Language".localized(),"translate"],["Log out".localized(),"logout_icon"]]

    override func viewDidLoad() {
        super.viewDidLoad()
//        if let lang = UserDefaults.standard.value(forKey: "LANG") {
//            if lang as? String == "ENG" {
//                Bundle.setLanguage("en")
//            }else {
//                Bundle.setLanguage("fr")
//            }
//
//        }
        
        viewModelSidePanel = SidePanelViewModel()
       
        
        tblSidePanel.delegate = self
        tblSidePanel.dataSource = self
        tblSidePanel.register(SidePanelTableViewCell.self)
       
        
       
       // viewContainer.addShadow(offset: CGSize(width: 3, height: 0), color: .black, radius: 5, opacity: 0.5)
      

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        if let lang = UserDefaults.standard.value(forKey: "LANG") {
            if lang as? String == "ENG" {
                Bundle.setLanguage("en")
            }else {
                Bundle.setLanguage("fr")
            }
          
        }
        //tblSidePanel.reloadData()
        lblHello.text = "Hello".localized()
        arrDefaultContents = [["Home".localized(),"home_icon"],["Edit Password".localized(),"edit_password_icon"],["Language".localized(),"translate"],["Log out".localized(),"logout_icon"]]
        if let username = UserDefaults.standard.string(forKey: "NAME") {
            lblUserName.text = username
        }
        if let email = UserDefaults.standard.string(forKey: "EMAIL")  {
            lblUserEmail.text = email
        }
        if let userType = UserDefaults.standard.string(forKey: "LOGINTYPE")  {
            lblUserName2.text = userType
        }
       
        
       
       
        SidePanelViewController.default.reloadMenu(for: .new)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tblSidePanel.reloadData()
    }
    
    
   
    
    @IBAction func btnRightTapped(_ sender:UIButton) {
        hide()
    }
    
    func reloadMenu(for type: MenuOptions) {
        switch type {
        case .new:
            viewModelSidePanel?.initiateMenuForFirstTimeUser()
            isloggedin = false
        case .loggedIn:
            viewModelSidePanel?.initiateMenuForLoggedInUser()
            isloggedin = true
        }
        
    }
    func show(on parent:UIViewController) {
        
        self.view.frame.origin.x = 0
        parent.addChild(self)
        
        // Left To Right Animation
        CATransaction.begin()
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
        transition.delegate = self
        self.view.layer.add(transition, forKey: nil)
        
        parent.view.addSubview(self.view)
        self.didMove(toParent: parent)
        CATransaction.commit()
        if let lang = UserDefaults.standard.value(forKey: "LANG") {
            if lang as? String == "ENG" {
                Bundle.setLanguage("en")
            }else {
                Bundle.setLanguage("fr")
            }
          
        }
    }
    
    
    func hide(handler: ((Bool) -> Void)? = nil) {
        delegate?.didDisplayMenu(status: false)
        self.view.backgroundColor = .clear
        
        // Right To Left Animation
        #if swift(>=5.3)
        //print("Swift 5.3")
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn) {

            self.view.frame.origin.x -= UIScreen.main.bounds.width

        } completion: { (success) in
            self.willMove(toParent: nil)
            self.removeFromParent()
            self.view.removeFromSuperview()
            handler?(success)
        }
        // Xcode 11.3.1 = Swift version 5.1.3
        // https://en.wikipedia.org/wiki/Xcode#Xcode_7.0_-_12.x_(since_Free_On-Device_Development)
        #elseif swift(<5.3)
        //print("Prior Swift of 5.3")
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            var rect:CGRect = self.view.frame
            rect.origin.x -= UIScreen.main.bounds.width
            self.view.frame = rect
        }) { (success) in
            self.willMove(toParent: nil)
            self.removeFromParent()
            self.view.removeFromSuperview()
            handler?(success)
        }
        #endif
    }
}

extension SidePanelViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDefaultContents.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  String(describing: SidePanelTableViewCell.self), for: indexPath) as! SidePanelTableViewCell
        //cell.configureFrom(viewModelSidePanel, indexPath: indexPath)
        cell.lblOptioin.text = arrDefaultContents[indexPath.row][0]
            
        cell.imgViewOption.image = UIImage(named: arrDefaultContents[indexPath.row][1])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
                   if let homeVC = UIApplication.getTopMostViewController()?.navigationController?.ifExitsOnStack(vc: HomeVC.self) {
                                            UIApplication.getTopMostViewController()?.navigationController?.popToViewController(homeVC, animated: true)
                    
                   }
                   else {
                       let myCartVC = HomeVC(nibName: "HomeVC", bundle: nil)
                       UIApplication.getTopMostViewController()?.navigationController?.pushViewController(myCartVC, animated: true)
               }
        }else if (indexPath.row == 1){
        
            if let myCartVC = UIApplication.getTopMostViewController()?.navigationController?.ifExitsOnStack(vc: EditPasswordVC.self) {
                                   UIApplication.getTopMostViewController()?.navigationController?.popToViewController(myCartVC, animated: true)
                               }
                               else {
                                   let myCartVC = EditPasswordVC(nibName: "EditPasswordVC", bundle: nil)
                                   UIApplication.getTopMostViewController()?.navigationController?.pushViewController(myCartVC, animated: true)
                           }
        }
        else if (indexPath.row == 2){
        
            if let myCartVC = UIApplication.getTopMostViewController()?.navigationController?.ifExitsOnStack(vc: HomeVC.self) {
                                   UIApplication.getTopMostViewController()?.navigationController?.popToViewController(myCartVC, animated: true)
                               }
                               else {
                                let myCartVC = HomeVC(nibName: "HomeVC", bundle: nil)
                                UIApplication.getTopMostViewController()?.navigationController?.pushViewController(myCartVC, animated: true)
                               
                           }
            delegate?.showLanguagePopUP(status: true)
        }
        else{
            

            logout()
        }
        hide()

}
                   
       // }
        // hide { (status) in
//        if self.isloggedin{
//            switch indexPath.section {
//            case 0:
//                switch indexPath.row {
//                case 0:
//                    let myTicketVC = MyTicketViewController(nibName: "MyTicketViewController", bundle: nil)
//
//                    if let tempVC = UIApplication.getTopMostViewController(), !tempVC.isKind(of: MyTicketViewController.self) {
//                        UIApplication.getTopMostViewController()?.navigationController?.pushViewController(myTicketVC, animated: true)
//                    }
//                    hide()
//                case 1:
//                    if (Reachability.isConnectedToNetwork()) {
//                    let notificationVC = NotificationViewController(nibName: "NotificationViewController", bundle: nil)
//                    UIApplication.getTopMostViewController()?.navigationController?.pushViewController(notificationVC, animated: true)
//                    hide()
//                    }else {
//                        showAlertWith(message: TCSNetworkError.offLine.localizedDescription)
//                    }
//                    break
//                case 2:
//                    if (Reachability.isConnectedToNetwork()) {
//                    if let myCartVC = UIApplication.getTopMostViewController()?.navigationController?.ifExitsOnStack(vc: MyCartViewController.self) {
//                        UIApplication.getTopMostViewController()?.navigationController?.popToViewController(myCartVC, animated: true)
//                    }
//                    else {
//                        let myCartVC = MyCartViewController(nibName: "MyCartViewController", bundle: nil)
//                        UIApplication.getTopMostViewController()?.navigationController?.pushViewController(myCartVC, animated: true)
//                    }
//                    hide()
//                    }else {
//                        showAlertWith(message: TCSNetworkError.offLine.localizedDescription)
//                    }
//                default:
//                    break
//                }
//            case 1:
//                switch indexPath.row {
//                case 0:
//                    if (Reachability.isConnectedToNetwork()) {
//                    guard let cell = tableView.cellForRow(at: indexPath) as? SidePanelTableViewCell  else {
//                        return
//                    }
//                    if cell.loginCellExists(self.viewModelSidePanel, indexPath: indexPath) {
//                        UIApplication.getTopMostViewController()?.navigationController?.popToRootViewController(animated: true)
//                    }
//                    else {
//                        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
//                        UIApplication.getTopMostViewController()?.navigationController?.pushViewController(profileVC, animated: true)
//                    }
//                    hide()
//                    }else {
//                        showAlertWith(message: TCSNetworkError.offLine.localizedDescription)
//                    }
//
//                    break
//                case 1:
//                    //                    let myTicketVC = MyTicketViewController(nibName: "MyTicketViewController", bundle: nil)
//                    //
//                    //                    if let tempVC = UIApplication.getTopMostViewController(), !tempVC.isKind(of: MyTicketViewController.self) {
//                    //                        myTicketVC.logout()
//                    //                        UIApplication.getTopMostViewController()?.navigationController?.pushViewController(myTicketVC, animated: true)
//                    //                    }
//                    self.isSelectLogOut = true
//                    self.logout()
//
//
//
//                default:
//                    hide()
//                    break
//                }
//            case 2:
//                switch indexPath.row {
//
//                case 0:
//                 //let contactVC = ContactUsViewController(nibName: "ContactUsViewController", bundle: nil)
//                 //UIApplication.getTopMostViewController()?.navigationController?.pushViewController(contactVC, animated: true)
//                 break
//                 case 1:
//                 break
//                 case 2:
//                 break
//                 case 3:
//                let termsVC = TermsAndConditionViewController(nibName: "TermsAndConditionViewController", bundle: nil)
//                    UIApplication.getTopMostViewController()?.navigationController?.pushViewController(termsVC, animated: true)
//                    hide()
//                 break
//                 case 4:
//                 break
//                default:
//                    hide()
//                    break
//                }
//            default:
//                hide()
//                break
//            }
//        }else {
//            switch indexPath.section {
//
//            case 0:
//                switch indexPath.row {
//                case 0:
//
//                    UIApplication.getTopMostViewController()?.navigationController?.popToRootViewController(animated: true)
//                    hide()
//
//
//                    break
//                case 1:
//
//                    UIApplication.getTopMostViewController()?.navigationController?.popToRootViewController(animated: true)
//                    hide()
//                default:
//                    break
//                }
//            case 1:
//                switch indexPath.row {
//                case 0:
//                 //let contactVC = ContactUsViewController(nibName: "ContactUsViewController", bundle: nil)
//                 //UIApplication.getTopMostViewController()?.navigationController?.pushViewController(contactVC, animated: true)
//                 break
//                 case 1:
//                 break
//                 case 2:
//                 break
//                 case 3:
//                    let termsVC = TermsAndConditionViewController(nibName: "TermsAndConditionViewController", bundle: nil)
//                    UIApplication.getTopMostViewController()?.navigationController?.pushViewController(termsVC, animated: true)
//                    hide()
//                 break
//                 case 4:
//                 break
//                default:
//                    hide()
//                    break
//                }
//            default:
//                hide()
//                break
//            }
//        }
        //}
        
   
    
//}
    
    
    
    
    
    func logout() {
       
        if let lang = UserDefaults.standard.value(forKey: "LANG") {
            if lang as? String == "ENG" {
                Bundle.setLanguage("en")
            }else {
                Bundle.setLanguage("fr")
            }
          
        }
       
        
        let alertOkAction = UIAlertAction(title: "YES".localized(), style: .default) { (_) in
          
            let defaults = UserDefaults.standard
            defaults.synchronize()
            defaults.removeObject(forKey: "ID")
            defaults.removeObject(forKey: "EMAIL")
            defaults.removeObject(forKey: "NAME")
            if let appDomain = Bundle.main.bundleIdentifier {
           UserDefaults.standard.removePersistentDomain(forName: appDomain)
            }
           // UserDefaults.standard.synchronize()
            let manager = LoginManager()
             manager.logOut()
            if let editpassVC = UIApplication.getTopMostViewController()?.navigationController?.ifExitsOnStack(vc: LogInVC.self) {
                    UIApplication.getTopMostViewController()?.navigationController?.popToViewController(editpassVC, animated: true)

            }else {
                let myCartVC = LogInVC(nibName: "LogInVC", bundle: nil)
                UIApplication.getTopMostViewController()?.navigationController?.pushViewController(myCartVC, animated: true)
            }
            self.hide()
           
            
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL".localized(), style: .default) { (_) in
            self.hide()
            
        }
        self.showAlertWith(message: "Are you sure you want to logout?".localized(), type: .custom(actions: [cancelAction,alertOkAction]))
        
        
    }
}

extension SidePanelViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            self.view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.6)
            delegate?.didDisplayMenu(status: true)
        }
    }
}

