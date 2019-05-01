//
//  PlaceAnnotation.swift
//  QueroConhecer
//
//  Created by Mauro Augusto Diniz on 01/05/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    
    enum placeType {
        case place
        case pointOfInterest
    }
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type: placeType
    var address: String?
    
    init(_ coordinate: CLLocationCoordinate2D, type: placeType) {
        self.coordinate = coordinate
        self.type = type
    }
    
}
