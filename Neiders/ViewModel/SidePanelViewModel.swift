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
   
    var arrContents:Array<Dictionary<String,Array<Dictionary<String,String>>>> = [["":[["Home".localized():"home_icon"],["Edit Password".localized():"edit_password_icon"],["Language".localized():"translate"],["Log out".localized():"logout_icon"]]]]
    
  var arrDefaultContents = [["Home".localized(),"home_icon"],["Language".localized(),"translate"]]
    
    private(set) var arrDisplayContent = [SidePanelModel]()
    
    
    
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
