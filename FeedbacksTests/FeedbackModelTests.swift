//
//  FeedbackModelTests.swift
//  FeedbacksTests
//
//  Created by Mathieu Lamvohee on 11/1/18.
//  Copyright © 2018 Mathieu Lamvohee. All rights reserved.
//

import XCTest

class FeedbackModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testFeedbackListModelMapsData() throws {
        guard let url = URL(string: "http://cache.usabilla.com/example/apidemo.json") else { return }
        URLSession.shared.dataTask(with: url) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                
                let feedbackList = try JSONDecoder().decode(FeedbackListModel.self, from: data)
                
                XCTAssertNotNil(feedbackList)
                XCTAssertNotNil(feedbackList.feedbackList)
                
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
    func testFeedbackModelMapsData() throws {
        guard let url = URL(string: "http://cache.usabilla.com/example/apidemo.json") else { return }
        URLSession.shared.dataTask(with: url) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                
                let feedbackList = try JSONDecoder().decode(FeedbackListModel.self, from: data)
                
                XCTAssertNotNil(feedbackList)
                XCTAssertNotNil(feedbackList.feedbackList)
                XCTAssertEqual(feedbackList.feedbackList![0].rating, 5)
                
                
            } catch let err {
                print("Err", err)
            }
            }.resume()
    }
}
