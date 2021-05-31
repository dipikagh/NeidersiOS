//
//  FilterCell.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 26/04/21.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet weak var lblFilterOption: UILabel!
    
    @IBOutlet weak var imgSelectOption: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
