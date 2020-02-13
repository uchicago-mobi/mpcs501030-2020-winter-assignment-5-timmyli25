//
//  ViewController.swift
//  World
//
//  Created by Timmy Li on 2/11/20.
//  Copyright © 2020 Timmy Li. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    //@IBOutlet var placeDescriptionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        
        var chicagoCoordinate = CLLocationCoordinate2D(latitude: 41.878, longitude: -87.630)
        let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        let chicagoRegion = MKCoordinateRegion(center: chicagoCoordinate, span: span)
        mapView.setRegion(chicagoRegion, animated: true)
        // Do any additional setup after loading the view.
    }


}

