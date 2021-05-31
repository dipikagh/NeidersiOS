//
//  SignUPViewModel.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 05/05/21.
//


import Foundation
import UIKit.UIImage

struct SidePanelModel {
    let sectionName:String
    let rows:[SidePanelRow]
    
    init(sectionName:String, rows:[SidePanelRow]) {
        self.sectionName = sectionName
        self.rows = rows
    }
}

struct SidePanelRow {
    let title:String
    let imgLogo:UIImage!
    
    init(title:String, imageName: String) {
        self.title = title
        self.imgLogo = UIImage(named: imageName)
    }
}
