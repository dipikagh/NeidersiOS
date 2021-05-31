//
//  SidePanelViewModel.swift
//  TCSTransit
//
//  Created by Palash Das, Appsbee LLC on 02/11/20.
//  Copyright © 2020 Intelebee. All rights reserved.
//

import Foundation

protocol SidePanelViewModelProtocol:class {
    var arrDisplayContent:[SidePanelModel] { get }
    func initiateMenuForFirstTimeUser()
    func initiateMenuForLoggedInUser()
}

class SidePanelViewModel: SidePanelViewModelProtocol {
   // var arrDefaultContents: Array<String> = []
    var arrContents:Array<Dictionary<String,Array<Dictionary<String,String>>>> = [["":[["Home".localized():"home_icon"],["Edit Password".localized():"edit_password_icon"],["Language".localized():"translate"],["Log out".localized():"logout_icon"]]]]
    
   // var arrDefaultContents: Array<Any>
    
    private(set) var arrDisplayContent = [SidePanelModel]()
    
//    private let arrDefaultContents: Array<Dictionary<String,Array<Dictionary<String,String>>>> = [["Services": [["My Ticket": "ticket_menu_icon"], ["Notification": "notification_icon"], ["My Cart": "my_cart_icon"]]], ["User": [["Login": "login_icon"]]], ["Others": [["Contact Us": "contact_us_icon"], ["FAQ": "faq_icon"], ["About This App": "about_us_icon"], ["Terms & Conditions": "terms_condition_icon"], ["Share App": "share_icon"]]]]
    
//    var arrDefaultContents:Array = [["Home",""],["Edit Password",""],["Log out",""]]
    
//    private let arrLoggedInContents: Array<Dictionary<String,Array<Dictionary<String,String>>>> = [["Services": [["My Tickets".localized(): "ticket_menu_icon"], ["Notification".localized(): "notification_icon"], ["My Cart": "my_cart_icon"]]], ["User": [["Profile": "profile_icon"], ["Logout": "log_out_icon"]]], ["Others": [["contactUs".localized(): "contact_us_icon"], ["FAQ".localized(): "faq_icon"], ["aboutThisApp".localized(): "about_us_icon"], ["termsAndCondition".localized(): "terms_condition_icon"], ["shareApp".localized(): "share_icon"]]]]
    
    required init() {
       
     initiateMenuForFirstTimeUser()
        initiateMenuForLoggedInUser()
    }
    
    func initiateMenuForFirstTimeUser() {
        arrDisplayContent.removeAll()
        arrContents.forEach({ (content) in
            let arrElements = content[content.keys.first!]

            var arrTempRow = [SidePanelRow]()
            arrElements?.forEach({ (element) in
                let modelRow = SidePanelRow(title: element.keys.first!, imageName: element[element.keys.first!]!)
                arrTempRow.append(modelRow)
            })

            let model = SidePanelModel(sectionName: content.keys.first!, rows: arrTempRow)
            arrDisplayContent.append(model)
        })
    }
    
    func initiateMenuForLoggedInUser() {
        arrDisplayContent.removeAll()
        arrContents.forEach({ (content) in
            let arrElements = content[content.keys.first!]

            var arrTempRow = [SidePanelRow]()
            arrElements?.forEach({ (element) in
                let modelRow = SidePanelRow(title: element.keys.first!, imageName: element[element.keys.first!]!)
                arrTempRow.append(modelRow)
            })

            let model = SidePanelModel(sectionName: content.keys.first!, rows: arrTempRow)
            arrDisplayContent.append(model)
        })
    }
    
    
}
