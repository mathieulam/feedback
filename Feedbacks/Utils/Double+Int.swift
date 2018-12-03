//
//  Double+extensions.swift
//  Feedbacks
//
//  Created by Mathieu Lamvohee on 11/6/18.
//  Copyright © 2018 Mathieu Lamvohee. All rights reserved.
//

import UIKit

extension Double {
    public func toImageRatingReuseID() -> String? {
        switch (self) {
        case 0..<2:
            return "sad_user"
        case 2..<4:
            return "medium_happy_user"
        default:
            return "happy_user"
        }
    }
}

extension Int {
    public func toImageRatingReuseID() -> String? {
        return Double(self).toImageRatingReuseID()
    }
}
