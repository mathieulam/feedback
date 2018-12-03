//
//  FeedbackDetailsViewController.swift
//  Feedbacks
//
//  Created by Mathieu Lamvohee on 11/6/18.
//  Copyright © 2018 Mathieu Lamvohee. All rights reserved.
//

import UIKit

class FeedbackDetailsViewController: UIViewController {
    @IBOutlet weak var feedbackDescriptionView: UIView!
    
    @IBOutlet weak var feedbackUserEmailView: UIView!
    @IBOutlet weak var feedbackUserCountryView: UIView!
    @IBOutlet weak var feedbackLabelsView: UIView!
    @IBOutlet weak var feedbackBrowserView: UIView!
    
    @IBOutlet weak var feedbackImageView: UIImageView!
    @IBOutlet weak var feedbackDescriptionLabel: UILabel!
    @IBOutlet weak var feedbackCountryLabel: UILabel!
    @IBOutlet weak var feedbackEmailLabel: UILabel!
    @IBOutlet weak var feedbackLabelsLabel: UILabel!
    @IBOutlet weak var feedbackBrowserLabel: UILabel!
    @IBOutlet weak var feedbackRatingLabel: UILabel!
    @IBOutlet weak var feedbackRatingImageView: UIImageView!
    var feedback: FeedbackModel? = nil
    let NO_RECORDS = "No records"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackUserEmailView.layer.cornerRadius = 5
        feedbackUserCountryView.layer.cornerRadius = 5
        feedbackLabelsView.layer.cornerRadius = 5
        feedbackBrowserView.layer.cornerRadius = 5
        
        if let feedback = feedback {
            
            if let email = feedback.emailAddress{
                feedbackEmailLabel.text = !email.isEmpty ? email: NO_RECORDS
            }
            if let comment = feedback.comment{
                feedbackDescriptionLabel.text = !comment.isEmpty ? comment: NO_RECORDS
            }
            if let country = feedback.country{
                feedbackCountryLabel.text = !country.isEmpty ? country : NO_RECORDS
            }
            if let labels = feedback.labels{
                feedbackLabelsLabel.text = !labels.isEmpty ? labels.joined(separator:", ") : NO_RECORDS
            }
            if let rating = feedback.rating {
                feedbackRatingLabel.text = String(format: "%d", rating)
            } else {
                feedbackRatingLabel.isHidden = true
                feedbackRatingImageView.isHidden = true
            }
            if let image = feedback.rating?.toImageRatingReuseID() {
                feedbackImageView.image = UIImage(named: image)
            }
            
            guard
                let computedBrowser = feedback.computedBrowser,
                let browser = computedBrowser.browser,
                let version = computedBrowser.version,
                let platform = computedBrowser.platform
            else {
                feedbackBrowserLabel.text = NO_RECORDS
                return
            }
            
            feedbackBrowserLabel.text = String(format: "From %@ %@ (%@)", browser, version, platform)
        }
    }
}
