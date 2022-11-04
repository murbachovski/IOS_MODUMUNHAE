//
//  MunjangEightDetailCollectionViewCell.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/04.
//

import UIKit

class MunjangEightDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var border: UIView!
    
    @IBOutlet weak var numberTitle: UILabel!
    
    @IBOutlet weak var isDoneImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let sublayers = self.layer.sublayers else{return}
        for i in sublayers{
            if type(of: i) == CAGradientLayer.self {
                i.removeFromSuperlayer()
                self.numberTitle.textColor = .black
                self.border.backgroundColor = .lightGray
            }
        }
    }
    
}
