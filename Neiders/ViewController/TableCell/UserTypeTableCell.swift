//
//  UserTypeTableCell.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 21/04/21.
//

import UIKit

class UserTypeTableCell: UITableViewCell {

    @IBOutlet weak var imageViewStudent: UIImageView!
    @IBOutlet weak var imageViewTeacher: UIImageView!
    
    @IBOutlet weak var btnStudent: UIButton!
    @IBOutlet weak var btnTeacher: UIButton!
    @IBOutlet weak var imgTeacher: UIImageView!
    
    @IBOutlet weak var lblStrudent: UILabel!
    @IBOutlet weak var imageStudent: UIImageView!
    
    @IBOutlet weak var lblIam: UILabel!
    @IBOutlet weak var lblTeacher: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblIam.text = "I am".localized()
        lblTeacher.text = "Teacher".localized()
        lblStrudent.text = "Student".localized()
       
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
