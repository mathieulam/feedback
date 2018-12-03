//
//  FeedbackPresenter.swift
//  Feedbacks
//
//  Created by Mathieu Lamvohee on 10/31/18.
//  Copyright © 2018 Mathieu Lamvohee. All rights reserved.
//

import Foundation

protocol FeedbackProtocol: class {
    func refreshData()
}

class FeedbackPresenter: NSObject {
    weak var view: FeedbackProtocol?
    private var feedbackListByCountry = [String: [FeedbackModel]]()
    
    init(feedbackView: FeedbackProtocol) {
        super.init()
        self.view = feedbackView
    }
    
    
    func getFeedbacks() {
        ApiManager.shared.getFeedbacks(url: "http://cache.usabilla.com/example/apidemo.json", success: { (result) in
            for data in result {
                if let country = data.country {
                    var arrayAvis = self.feedbackListByCountry[country] ?? [FeedbackModel]()
                    arrayAvis.append(data)
                    self.feedbackListByCountry[country] = arrayAvis
                }
            }
            self.view?.refreshData()
        }) { (error) in
            print(error!.localizedDescription)
        }
    }
    
    func getCountryListSize() -> Int {
        return self.feedbackListByCountry.count
    }
    
    func getCountryList() -> [String] {
        var countries = [String]()
        for key in feedbackListByCountry.keys {
            countries.append(key)
        }
        return countries.sorted(by: compareCountryNames)
    }
    
    func getFeedbackListSize(forCountry: String) -> Int {
        if let feedbacks = feedbackListByCountry[forCountry] {
            return feedbacks.count
        }
        return 0
    }
    
    func getFeedbackList(forCountry: String) -> [FeedbackModel] {
        if let feedbacks = feedbackListByCountry[forCountry] {
            return feedbacks
        }
        return [FeedbackModel]()
    }
    
    func getAverageRating(forCountry: String) -> Double {
        let feedbacks = getFeedbackList(forCountry: forCountry)
        var ratings = [Int]()
        for feedback in feedbacks {
            if let rating = feedback.rating{
                ratings.append(rating)
            }
            
        }
        return average(nums: ratings)
    }
    
    func average(nums: [Int]) -> Double {
        
        var total = 0.0
        for vote in nums{
            
            total += Double(vote)
            
        }
        
        let votesTotal = Double(nums.count)
        let average = total/votesTotal
        return average
    }
    
    func compareCountryNames(name1: String, name2: String) -> Bool {
        return name1 < name2
    }
}
