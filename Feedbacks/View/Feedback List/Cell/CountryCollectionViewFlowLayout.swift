//
//  CountryCollectionViewFlowLayout.swift
//  Feedbacks
//
//  Created by Mathieu Lamvohee on 11/5/18.
//  Copyright © 2018 Mathieu Lamvohee. All rights reserved.
//

import UIKit

class CountryCollectionViewFlowLayout: UICollectionViewFlowLayout {
    let cellSize = CGSize(
        width: 320,
        height: 82
    )
    
    var contentInsetLeft: CGFloat = 0.0
    
    var contentInsetRight: CGFloat = 0.0
    
    required override init() {
        super.init()
        
        self.scrollDirection = .horizontal
        self.itemSize = self.cellSize
        self.minimumInteritemSpacing = 0.0
        self.minimumLineSpacing = 10.0
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        if let collectionView = collectionView {
            
            let frameSize = collectionView.bounds.width
            
            self.contentInsetLeft = frameSize / 2 - self.cellSize.width / 2
            self.contentInsetRight = frameSize / 2 - self.cellSize.width / 2
            
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
            collectionView.contentInset = UIEdgeInsets(top: 0, left: contentInsetLeft, bottom: 0, right: contentInsetRight)
        }
    }
    
    // MARK: - Layout Attributes
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes = super.layoutAttributesForElements(in: rect)
        
        attributes?.forEach { itemAttributes in
            
            let frame = itemAttributes.frame
            
            let minScale: CGFloat = 0.9
            
            let distance = abs(collectionView!.contentOffset.x + self.contentInsetLeft - frame.origin.x)
            
            let scale = 1.0 * min(max(1 - distance / (collectionView!.bounds.width), minScale), 1)
            
            itemAttributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var newOffset: CGPoint = CGPoint.zero
        
        let width = cellSize.width + self.minimumLineSpacing
        
        var offset = proposedContentOffset.x + self.contentInsetLeft
        
        if velocity.x > 0 {
            offset = width * ceil(offset / width)
        } else if velocity.x == 0 {
            offset = width * round(offset / width)
        } else if velocity.x < 0 {
            offset = width * floor(offset / width)
        }
        
        newOffset.x = offset - self.contentInsetLeft
        newOffset.y = proposedContentOffset.y
        
        return newOffset
    }
}
