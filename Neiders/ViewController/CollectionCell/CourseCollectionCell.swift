//
//  CourseCollectionCell.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 23/04/21.
//

import UIKit

class CourseCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageCourse: UIImageView!
    @IBOutlet weak var lblCourseName: UILabel!
    
    @IBOutlet weak var viewHomePAge: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewHomePAge.layer.cornerRadius = 10
        viewHomePAge.addShadow(offset: CGSize.init(width: 1, height: 3), color: UIColor.gray, radius: 3.0, opacity: 0.6)
        // Initialization code
    }

}
