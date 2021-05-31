//
//  SidePanelTableViewCell.swift
//  TCSTransit
//
//  Created by Palash Das, Appsbee LLC on 02/11/20.
//  Copyright © 2020 Intelebee. All rights reserved.
//

import UIKit

class SidePanelTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewOption:UIImageView!
    @IBOutlet weak var lblOptioin:UILabel!
    @IBOutlet weak var constImageHeight:NSLayoutConstraint!
    @IBOutlet weak var constHorizontalGap:NSLayoutConstraint!
    
    typealias ViewModelType = SidePanelViewModelProtocol
    var viewModel: ViewModelType?
    var isHeader:Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
//        if let lang = UserDefaults.standard.value(forKey: "LANG") {
//                  if lang as? String == "ENG" {
//                      Bundle.setLanguage("en")
//                  }else {
//                      Bundle.setLanguage("es")
//                  }
//              }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureFrom(_ modelView: ViewModelType?, indexPath:IndexPath) {
        if let lang = UserDefaults.standard.value(forKey: "LANG") {
            if lang as? String == "ENG" {
                Bundle.setLanguage("en")
            }else {
                Bundle.setLanguage("es")
            }
        }
        self.viewModel = modelView
        
        let modelRow = modelView?.arrDisplayContent[indexPath.section].rows[indexPath.row]

        self.imgViewOption.image = modelRow?.imgLogo
        
        self.lblOptioin.text = modelRow?.title
     //   self.lblOptioin.textColor = UIColor(named: "CustomOrange")
      //  self.lblOptioin.font = UIFont.setLatoFont(name: .latoRegular, size: 12)
    }
    
//    func configureFrom(header modelView: ViewModelType?, section: Int) {
//        self.viewModel = modelView
//
//       // let modelSection = modelView?.arrDisplayContent[section]
//
//        self.constImageHeight.constant = 0
//        self.constHorizontalGap.constant = 0
//        self.lblOptioin.text = modelSection?.sectionName.uppercased()
//        self.lblOptioin.textColor = .black
////        self.lblOptioin.font = UIFont.setLatoFont(name: .latoBlack, size: 14)
//    }
    
//    func loginCellExists(_ modelView: ViewModelType?, indexPath:IndexPath) -> Bool {
//        self.viewModel = modelView
//
//        if modelView?.arrDisplayContent[indexPath.section].rows.count == 1 {
//            return true
//        }
//        else {
//            return false
//        }
//    }
    

}
