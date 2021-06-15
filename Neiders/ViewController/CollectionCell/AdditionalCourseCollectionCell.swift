//
//  AdditionalCourseCollectionCell.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 29/04/21.
//

import UIKit

class AdditionalCourseCollectionCell: UICollectionViewCell {

    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var imageAdditionalCourse: UIImageView!
    
    @IBOutlet weak var lblCourseName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewShadow.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.gray, radius: 3.0, opacity: 0.6)
        // Initialization code
    }

}
