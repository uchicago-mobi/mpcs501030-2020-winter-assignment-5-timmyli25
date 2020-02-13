
import UIKit
import MapKit
import Foundation

public class DataManager{
    
    var placeAnnotations = [String:Place]()
    var region = [NSNumber]()
    var favoritePlaces = [String : Int]()
    let saveSpace = UserDefaults.standard
    public static let sharedInstance = DataManager()
    
    fileprivate init(){}
    func loadAnnotationFromPlist(filename: String){
        var loadedRegionandPlaces: NSDictionary?
        if let path = Bundle.main.path(forResource: filename, ofType: "plist") {
           loadedRegionandPlaces = NSDictionary(contentsOfFile: path)!
        }
        region = loadedRegionandPlaces?["region"] as! [NSNumber]
        let places = loadedRegionandPlaces?["places"] as! [NSDictionary]
        for place in places{
            let placeAnnotation = Place()
            let latitude = place["lat"] as! NSNumber
            let longitude = place["long"] as! NSNumber
            let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude), longitude: CLLocationDegrees(truncating: longitude))
            placeAnnotation.name = place["name"] as? String
            placeAnnotation.longDescription = place["description"] as? String
            placeAnnotation.coordinate = coordinates
            placeAnnotations[placeAnnotation.name!] = placeAnnotation
        }
    }
    func saveFavorites(){
        saveSpace.set(favoritePlaces, forKey: "favorites")
    }
    func loadFavorites(){
        favoritePlaces = saveSpace.object(forKey: "favorites") as? [String : Int] ?? [String:Int]()
    }
    func addFavorite(placeName: String){
        favoritePlaces[placeName] = 1
        saveFavorites()
    }
    
    func deleteFavorite(placeName: String){
        favoritePlaces.removeValue(forKey: placeName)
        saveFavorites()
    }
    
    func listFavorites()->[String]{
        var userFavorites = [String]()
        for (placeName, _) in favoritePlaces{
            userFavorites.append(placeName)
        }
        return userFavorites
    }
}
