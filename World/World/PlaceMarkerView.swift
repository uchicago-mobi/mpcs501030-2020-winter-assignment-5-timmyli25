//
//  PlaceMarkerView.swift
//  World
//
//  Created by Timmy Li on 2/11/20.
//  Copyright © 2020 Timmy Li. All rights reserved.
//

import UIKit
import MapKit

class PlaceMarkerView: MKMarkerAnnotationView {
    
    var name:String?
    var longDescription: String?
    
    override var annotation: MKAnnotation?{
        willSet {
            clusteringIdentifier = "Place"
            displayPriority = .defaultLow
            markerTintColor = .systemRed
            glyphImage = UIImage(systemName: "pin.fill")
        }
    }
}
