//
//  FeedbackApiService.swift
//  Feedbacks
//
//  Created by Mathieu Lamvohee on 10/31/18.
//  Copyright © 2018 Mathieu Lamvohee. All rights reserved.
//

import Foundation

class FeedbackApiService {
    
    static func getFeedbacksList(url: String,
                              success: @escaping ((_ result: [FeedbackModel]) -> ()),
                              failure: @escaping (Error?) -> ()) {
        
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {return}
            
            do {
                let feedbackListModel = try JSONDecoder().decode(FeedbackListModel.self, from: data)
                guard let feedbackList = feedbackListModel.feedbackList else {return}
                success(feedbackList)
            } catch let jsonError {
                print("Error serializing json: ", jsonError)
            }
        }.resume()
    }
}
