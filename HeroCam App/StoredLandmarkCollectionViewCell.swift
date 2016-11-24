//
//  StoredLandmarkCollectionViewCell.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 10/1/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

typealias StoredLandmarkCollectionViewCellDataSource = TitlePresentable & RemoteImagePresentable

struct StoredLandmarkCollectionViewCellModel: StoredLandmarkCollectionViewCellDataSource {
    var title: String
    var imageURL: String
}

final class StoredLandmarkCollectionViewCell: UICollectionViewCell, TitleLabelPresentable {
 
    @IBOutlet weak var imageView: TAAsyncImageView!
    @IBOutlet weak var titleLabel: UILabel!
    fileprivate var dataSource: StoredLandmarkCollectionViewCellDataSource?
    
    func configure(with dataSource: StoredLandmarkCollectionViewCellDataSource) {
        self.titleLabel.text = dataSource.title
        self.imageView.url = URL(string: dataSource.imageURL)
    }
    
    /**
     Computes the size the cell will need to be to fit within targetSize.
     
     targetSize should be used to pass in a width.
     
     the returned size will have the same width, and the height which is
     calculated by Auto Layout so that the contents of the cell (i.e., text in the label)
     can fit within that width.
     
     */
    func preferredLayoutSizeFittingSize(_ targetSize:CGSize) -> CGSize {
        
        // save original frame and preferredMaxLayoutWidth
        let originalFrame = self.frame
        let originalPreferredMaxLayoutWidth = self.titleLabel.preferredMaxLayoutWidth
        
        // assert: targetSize.width has the required width of the cell
        
        // step1: set the cell.frame to use that width
        var frame = self.frame
        frame.size = targetSize
        self.frame = frame
        
        // step2: layout the cell
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.bounds.size.width
        
        // assert: the label's bounds and preferredMaxLayoutWidth are set to the width required by the cell's width
        
        // step3: compute how tall the cell needs to be
        
        // this causes the cell to compute the height it needs, which it does by asking the
        // label what height it needs to wrap within its current bounds (which we just set).
        let computedSize = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        // assert: computedSize has the needed height for the cell
        
        // Apple: "Only consider the height for cells, because the contentView isn't anchored correctly sometimes."
        let newSize = CGSize(width:targetSize.width ,height:computedSize.height)
        
        // restore old frame and preferredMaxLayoutWidth
        self.frame = originalFrame
        self.titleLabel.preferredMaxLayoutWidth = originalPreferredMaxLayoutWidth
        
        return newSize
    }
}
