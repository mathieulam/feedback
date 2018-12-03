//
//  FeedbackTableViewCell.swift
//  Feedbacks
//
//  Created by Mathieu Lamvohee on 11/5/18.
//  Copyright © 2018 Mathieu Lamvohee. All rights reserved.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {
    static let reuseId = "feedbackCell"
    
    @IBOutlet weak var feedbackImageView: UIImageView!
    @IBOutlet weak var feedbackDateLabel: UILabel!
    @IBOutlet weak var feedbackDescriptionLabel: UILabel!
    @IBOutlet weak var cellView: UIView! {
        didSet {
            cellView.layer.cornerRadius = 5.0
            cellView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        cellView.layer.borderWidth = selected ? 3 : 0
        cellView.layer.borderColor = selected ? UIColor(red: 70/255, green: 158/255, blue: 229/255, alpha: 255/255).cgColor : UIColor.clear.cgColor
    }
    
    func configureCell(feedback:FeedbackModel) {
        
        feedbackImageView.image =  UIImage(named: (feedback.rating?.toImageRatingReuseID())!)
        
        guard
            let computedBrowser = feedback.computedBrowser,
            let browser = computedBrowser.browser,
            let platform = computedBrowser.platform,
            let version = computedBrowser.version
            else {
                feedbackDateLabel.text = ""
                return
        }
        
        feedbackDescriptionLabel.text = feedback.comment ?? ""
        feedbackDateLabel.text = String(format: "From %@ %@ (%@)", browser, version, platform)
        
    }
    
}
