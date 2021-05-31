//
//  UnitCollectionViewCell.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 29/04/21.
//

import UIKit

class UnitCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var lblUnitName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBorder.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.gray, radius: 1.0, opacity: 0.4)
        // Initialization code
    }

}
