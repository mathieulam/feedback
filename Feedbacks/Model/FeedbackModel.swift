//
//  FeedbackModel.swift
//  Feedbacks
//
//  Created by Mathieu Lamvohee on 10/31/18.
//  Copyright © 2018 Mathieu Lamvohee. All rights reserved.
//

import Foundation

struct FeedbackListModel: Codable {
    var feedbackList: [FeedbackModel]?

    enum FeedbackListModelKeys: String, CodingKey {
        case feedbackList = "items"
    }
    
    init(feedbackList:[FeedbackModel]?) {
        self.feedbackList = feedbackList
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FeedbackListModelKeys.self)
        let feedbackList = try container.decodeIfPresent([FeedbackModel].self, forKey: .feedbackList)
        self.init(feedbackList: feedbackList)
    }
    
}

struct FeedbackModel: Codable {
    var comment: String?
    var country: String?
    var computedBrowser: BrowserModel?
    var emailAddress: String?
    var geoLocation: GeoModel?
    var rating: Int?
    var labels:[String]?
    
    init() {
    }
    
    init(comment: String?, country: String?, computedBrowser: BrowserModel?, emailAddress: String?, geoLocation: GeoModel?, rating: Int?, labels: [String]?) {
        self.comment = comment
        self.country = country
        self.computedBrowser = computedBrowser
        self.emailAddress = emailAddress
        self.geoLocation = geoLocation
        self.rating = rating
        self.labels = labels
    }
    
    enum FeedbackModelKeys: String, CodingKey {
        case comment = "comment"
        case country = "computed_location"
        case computedBrowser = "computed_browser"
        case emailAddress = "email"
        case geoLocation = "geo"
        case rating = "rating"
        case labels = "labels"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FeedbackModelKeys.self)
        let comment = try container.decodeIfPresent(String.self, forKey: .comment)
        let country = try container.decodeIfPresent(String.self, forKey: .country)
        let computedBrowser = try container.decodeIfPresent(BrowserModel.self, forKey: .computedBrowser)
        let emailAddress = try container.decodeIfPresent(String.self, forKey: .emailAddress)
        let geoLocation = try container.decodeIfPresent(GeoModel.self, forKey: .geoLocation)
        let rating = try container.decodeIfPresent(Int.self, forKey: .rating)
        let labels = try container.decodeIfPresent([String].self, forKey: .labels)
        self.init(comment: comment, country: country, computedBrowser: computedBrowser, emailAddress: emailAddress, geoLocation: geoLocation, rating: rating, labels: labels)
    }
}

struct BrowserModel: Codable {
    var browser: String?
    var version: String?
    var platform: String?
    
    enum BrowserModelKeys: String, CodingKey {
        case browser = "Browser"
        case version = "Version"
        case platform = "Platform"
    }
    
    init(browser: String?, version: String?, platform: String?) {
        self.browser = browser
        self.version = version
        self.platform = platform
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BrowserModelKeys.self)
        let browser = try container.decodeIfPresent(String.self, forKey: .browser)
        let version = try container.decodeIfPresent(String.self, forKey: .version)
        let platform = try container.decodeIfPresent(String.self, forKey: .platform)
        self.init(browser: browser, version: version, platform: platform)
    }
}

struct GeoModel: Codable {
    var country: String?
    var region: String?
    var city: String?
    var latitude: Double?
    var longitude: Double?
    
    enum GeoModelKeys: String, CodingKey {
        case country = "country"
        case region = "region"
        case city = "city"
        case latitude = "lat"
        case longitude = "lon"
    }
    
    init(country: String?, region: String?, city: String?, latitude: Double?, longitude: Double?) {
        self.country = country
        self.region = region
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GeoModelKeys.self)
        let country = try container.decodeIfPresent(String.self, forKey: .country)
        let region = try container.decodeIfPresent(String.self, forKey: .region)
        let city = try container.decodeIfPresent(String.self, forKey: .city)
        let latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        let longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        self.init(country: country, region: region, city: city, latitude: latitude, longitude: longitude)
    }
}
