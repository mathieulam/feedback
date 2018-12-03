//
//  CountryCollectionViewCell.swift
//  Feedbacks
//
//  Created by Mathieu Lamvohee on 11/5/18.
//  Copyright © 2018 Mathieu Lamvohee. All rights reserved.
//

import UIKit

class CountryCollectionViewCell: UICollectionViewCell {
    static let reuseId = "countryCell"
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryRatingLabel: UILabel!
    @IBOutlet weak var countryStatusImageView: UIImageView!
    @IBOutlet weak var countryView: UIView! {
        didSet {
            countryView.layer.cornerRadius = 5.0
            countryView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(countryName: String, totalRating: Int, averageRating: Double) {
        countryNameLabel.text = countryName
        countryRatingLabel.text = String(format: "%d feedbacks", totalRating)
        
        countryImageView.image = UIImage(named: averageRating.toImageRatingReuseID()!)
    }

}
