//
//  MapViewController.swift
//  World
//
//  Created by Timmy Li on 2/11/20.
//  Copyright © 2020 Timmy Li. All rights reserved.
//

import UIKit
import MapKit

//protocol MKMapViewDelegate: class {
//  /// Function is not implemented in protocol...only defined
//  func receivedTap(sender: MKMapView)
//}

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var placeName: UILabel!
    @IBOutlet var placeDescription: UILabel!
    @IBOutlet var favoriteStar: UIButton!
    @IBAction func favoriteStarPress(_ sender: Any) {
        let place = placeName.text!
        if place == ""{
            return
        }
        let keyExist = DataManager.sharedInstance.favoritePlaces[place] != nil
        if keyExist{
            DataManager.sharedInstance.deleteFavorite(placeName: place)
            favoriteStar.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            DataManager.sharedInstance.addFavorite(placeName: place)
            favoriteStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    
    @IBOutlet var detailView: UIView!
    @IBOutlet var favoriteButtonView: UIButton!
    @IBAction func favoriteButtonPress(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        placeDescription.contentMode = .scaleToFill
        placeDescription.numberOfLines = 0
        placeName.contentMode = .scaleToFill
        placeName.numberOfLines = 0
        DataManager.sharedInstance.loadAnnotationFromPlist(filename: "Data")
        for (_,place) in DataManager.sharedInstance.placeAnnotations{
            mapView.addAnnotation(place)
        }
        // Set regions.
        mapView.delegate = self
        let chicagoCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: DataManager.sharedInstance.region[0]), longitude: CLLocationDegrees(truncating: DataManager.sharedInstance.region[1]))
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(truncating: DataManager.sharedInstance.region[2]), longitudeDelta:  CLLocationDegrees(truncating: DataManager.sharedInstance.region[3]))
        let chicagoRegion = MKCoordinateRegion(center: chicagoCoordinate, span: span)
        mapView.setRegion(chicagoRegion, animated: true)
        
        // Set display aesthetics.
        detailView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        placeName.textColor = .white
        placeDescription.textColor = .gray
        favoriteStar.tintColor = .systemYellow
        favoriteButtonView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        favoriteButtonView.setTitleColor(.systemYellow, for: .normal)
    }
}

extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        let placeView = view as! PlaceMarkerView
        placeName.text = placeView.name
        placeDescription.text = placeView.longDescription
        let keyExist = DataManager.sharedInstance.favoritePlaces[placeView.name!] != nil
        if keyExist{
            favoriteStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteStar.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        guard let annotation = annotation as? Place else {return nil}
        let identifier = "placeMarker"
        var view: PlaceMarkerView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? PlaceMarkerView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {
          view = PlaceMarkerView(annotation: annotation, reuseIdentifier: identifier)
          view.canShowCallout = true
          view.calloutOffset = CGPoint(x: -5, y: 5)
          view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        view.name = annotation.name
        view.longDescription = annotation.longDescription
        return view
    }
}

extension MapViewController: PlacesFavoritesDelegate{
    
    func favoritePlace(name: String) {
        let place = DataManager.sharedInstance.placeAnnotations[name]!
        let placeCoordinate = place.coordinate
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(truncating: DataManager.sharedInstance.region[2]), longitudeDelta:  CLLocationDegrees(truncating: DataManager.sharedInstance.region[3]))
        let placeRegion = MKCoordinateRegion(center: placeCoordinate, span: span)
        mapView.setRegion(placeRegion, animated: true)
        placeName.text = place.name
        placeDescription.text = place.longDescription
        favoriteStar.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let receiver = segue.destination as? FavoritesViewController{
            receiver.delegate = self
        }
    }
}

