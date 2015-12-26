//
//  Point.swift
//  KGDevTest
//
//  Created by Nisal Perera on 2015-12-24.
//  Copyright © 2015 Nisal Perera. All rights reserved.
//

import Foundation
import MapKit

class Point: NSObject, MKAnnotation {
    let title: String?
    var pointDescription: String?
    
    // rest api endpoint to thumb and image
    var thumbUrl: String?
    var imageUrl: String?
    
    //cordinates used by mapview 
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, thumbUrl: String, imageUrl: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.pointDescription = locationName
        self.thumbUrl = thumbUrl
        self.imageUrl = imageUrl
        self.coordinate = coordinate
        
        super.init()
    }
}



