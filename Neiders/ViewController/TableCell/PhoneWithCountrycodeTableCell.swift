//
//  PhoneWithCountrycodeTableCell.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 06/07/21.
//

import UIKit

class PhoneWithCountrycodeTableCell: UITableViewCell {

    @IBOutlet weak var textfieldPhoneNumber: UITextField!
    @IBOutlet weak var btnPickerShow: UIButton!
    @IBOutlet weak var textFieldCountryCode: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
