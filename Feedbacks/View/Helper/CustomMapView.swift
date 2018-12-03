//
//  CustomMapView.swift
//  Feedbacks
//
//  Created by Mathieu Lamvohee on 11/6/18.
//  Copyright © 2018 Mathieu Lamvohee. All rights reserved.
//

import Foundation
import Mapbox

protocol CustomMapViewDelegate : AnyObject {
    
    func CustomMapView(_ mapView: MGLMapView, didDeselect annotation: CustomPointAnnotation)
    
    func CustomMapView(_ mapView: MGLMapView, didSelect annotation: CustomPointAnnotation)
    
}


class CustomMapView: MGLMapView{
    
    var addStopWhenUserScroll = true
    var loadingAnnotation = false
    var feedbackList = [FeedbackModel]()
    var isConfugured = false
    var annotationList = [MGLAnnotation]()
    weak var CustomMapViewDelegate : CustomMapViewDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.styleURL = URL(string: "mapbox://styles/mapbox/streets-v10")!
        self.delegate = self
        self.showsUserLocation = true
    }
    
    func configureIsNeeded(){
        
        if isConfugured {
            return
        }
        
        self.removeAnnotations(annotationList)
        
        self.annotationList = feedbackList.compactMap({ (feedbackModel) -> CustomPointAnnotation? in
            
            guard
                let geoloc = feedbackModel.geoLocation,
                let latitude = geoloc.latitude,
                let longitude = geoloc.longitude
                else{
                    print("Not supposed to happen")
                    return nil
            }
            
            let annotation = CustomPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: feedbackModel.comment, subtitle: "" )
            
            annotation.type = CustomPointAnnotation.TypeAnnotation.Feedback(feedback: feedbackModel)
            
            return annotation
        })
        
        self.addAnnotations(self.annotationList)
        
        isConfugured = !feedbackList.isEmpty
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension CustomMapView : MGLMapViewDelegate {
    // MARK: - MGLMapViewDelegate methods
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        if let point = annotation as? CustomPointAnnotation,
            let image = point.image,
            let reuseIdentifier = point.reuseIdentifier {
            
            if let annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: reuseIdentifier) {
                // The annotatation image has already been cached, just reuse it.
                return annotationImage
                
            } else {
                // Create a new annotation image.
                return MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
            }
            
        }
        
        // Fallback to the default marker image.
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        
        if let annotation = annotation as? CustomPolyline {
            // Return orange if the polyline does not have a custom color.
            return annotation.color ?? UIColor.red
        }
        
        // Fallback to the default tint color.
        return mapView.tintColor
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        
        if let point = annotation as? CustomPointAnnotation {
            CustomMapViewDelegate?.CustomMapView(self, didDeselect: point)
        }
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        
        if let point = annotation as? CustomPointAnnotation {
            CustomMapViewDelegate?.CustomMapView(self, didSelect: point)
        }
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 1
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        return 5.0
    }
}
