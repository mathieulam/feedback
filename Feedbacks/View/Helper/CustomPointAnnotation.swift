//
//  CustomPointAnnotation.swift
//  Feedbacks
//
//  Created by Mathieu Lamvohee on 11/6/18.
//  Copyright © 2018 Mathieu Lamvohee. All rights reserved.
//

import Foundation
import Mapbox

class CustomPointAnnotation: NSObject, MGLAnnotation {
    enum TypeAnnotation {
        case Feedback(feedback: FeedbackModel)

        func getImage() -> UIImage? {
            var imageBase : UIImage = UIImage()
            
            switch self {
                
            case .Feedback(let feedbackCurrent):
                if let image = feedbackCurrent.rating?.toImageRatingReuseID(){
                    imageBase = UIImage(named: image)!
                }
            }
            
            let size = CGSize(width: 40, height: 40)
            UIGraphicsBeginImageContext(size)
            imageBase.draw(in: CGRect(x: 0, y: 0, width: 40, height: 40))
            
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return resizedImage!
        }
        
        func getReuseIdentifier() -> String? {
            
            switch self {
                
            case .Feedback(let feedbackCurrent):
                return (feedbackCurrent.rating ?? 0).toImageRatingReuseID()
            }
        }
    }
    
    // As a reimplementation of the MGLAnnotation protocol, we have to add mutable coordinate and (sub)title properties ourselves.
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type : TypeAnnotation = TypeAnnotation.Feedback(feedback: FeedbackModel())
    
    // Custom properties that we will use to customize the annotation's image.
    var image: UIImage? {
        
        return self.type.getImage()
        
    }
    var reuseIdentifier: String?  {
        
        return self.type.getReuseIdentifier()
        
    }
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    static func drawImage(profileImage : UIImage, withBadge : UIImage) -> UIImage {
        
        let largeur = profileImage.size.width
        
        UIGraphicsBeginImageContextWithOptions(profileImage.size, false, 0)
        profileImage.draw(in: CGRect(x: 0, y: 0, width: largeur, height: largeur))
        
        withBadge.draw(in: CGRect(x: largeur*0.30, y: largeur*0.15, width: largeur*0.5, height: largeur*0.5))
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
        
    }
    
    
    static func drawOnImage(startingImage: UIImage, color : UIColor) -> UIImage {
        
        // Create a context of the starting image size and set it as the current one
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        
        // Draw a transparent green Circle
        context.setFillColor(color.cgColor)
        context.setLineWidth(0.0)
        context.addEllipse(in: CGRect(x: 15, y: 8, width: 17, height: 17))
        context.drawPath(using: .fillStroke) // or .fillStroke if need filling
        
        // Save the context as a new UIImage
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return myImage!
    }
}

// MGLPolyline subclass
class CustomPolyline: MGLPolyline {
    // Because this is a subclass of MGLPolyline, there is no need to redeclare its properties.
    
    // Custom property that we will use when drawing the polyline.
    var color: UIColor?
}
