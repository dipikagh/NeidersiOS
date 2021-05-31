//
//  InputTableViewCell.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 21/04/21.
//

import UIKit

class InputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textInputType: UITextField!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var imageInputType: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
