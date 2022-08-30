//
//  WordCollectionViewCell.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/29.
//

import UIKit

class WordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // CollectionViewCell
    func adjustCellSize(height: CGFloat, label: String) -> CGSize {
        self.titleLabel.text = label
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width , height:height)
        
        return self.contentView.systemLayoutSizeFitting(targetSize,
                                                        withHorizontalFittingPriority:.fittingSizeLevel,
                                                        verticalFittingPriority:.required)
    }
}
