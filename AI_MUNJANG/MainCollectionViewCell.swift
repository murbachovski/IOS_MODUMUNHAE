//
//  MainCollectionViewCell.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/09/21.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imgViewInContentView: UIImageView!
    
    @IBOutlet var lockImg: UIImageView!
    
    @IBOutlet var labelInContentView: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lockImg.image = nil
    }
}
