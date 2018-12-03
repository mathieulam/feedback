//
//  ApiManager.swift
//  Feedbacks
//
//  Created by Mathieu Lamvohee on 10/31/18.
//  Copyright © 2018 Mathieu Lamvohee. All rights reserved.
//

import Foundation

class ApiManager {
    
    static let shared = ApiManager()
    
    private init(){
        
    }
    
    func getFeedbacks(url:String,
                      success: @escaping ([FeedbackModel]) -> (),
                      failure: @escaping (Error?) -> ()) {
        FeedbackApiService.getFeedbacksList(url: url, success: success, failure: failure)
    }
}
