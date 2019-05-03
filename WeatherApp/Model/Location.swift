//
//  Location.swift
//  WeatherApp
//
//  Created by Ruxandra Ciortea on 13/04/2019.
//  Copyright © 2019 Ruxandra Ciortea. All rights reserved.
//

import UIKit
import CoreLocation
import KeychainSwift

let kLatitudeKey = "latitude"
let kLongitudeKey = "longitude"
let kCityKey = "city"
let kCountryKey = "country"

class Location: NSObject {
    
    var city: String
    var country: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    override init() {
        self.city = ""
        self.country = ""
        self.latitude = 0
        self.longitude = 0
        
        super.init()
    }
    
    init(city: String, country: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.city = ""
        self.country = ""
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func updateLocationWith(city: String, country: String) {
        self.city = city
        self.country = country
    }
    
    static func getLocations() -> [Location] {
        var locationsArray: [Location] = []
        
        let location1 = Location.init(city: "Cluj-Napoca", country: "Romania", latitude: 46.770439, longitude: 23.591423)
        locationsArray.append(location1)
        
        let location2 = Location.init(city: "Bucharest", country: "Romania", latitude: 44.43225, longitude: 26.10626)
        locationsArray.append(location2)

        let location3 = Location.init(city: "London", country: "UK", latitude: 51.509865, longitude: -0.118092)
        locationsArray.append(location3)

        let location4 = Location.init(city: "Berlin", country: "Germany", latitude: 52.520008, longitude: 13.404954)
        locationsArray.append(location4)

        let location5 = Location.init(city: "Oslo", country: "Norway", latitude: 59.911491, longitude: 10.757933)
        locationsArray.append(location5)

        return locationsArray
    }
    
}

extension Location {
    
    static func requestLocationPermission(delegate: CLLocationManagerDelegate) -> CLLocationManager {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = delegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        return locationManager
    }
    
    static func getCityNameFromCoordinates(latidue: CLLocationDegrees, longitude: CLLocationDegrees,
                                           completionHandler: @escaping ((city: String, country: String)?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latidue, longitude: longitude)) { (placeMarks, error) in
            guard error == nil else {
                completionHandler(nil)
                
                return
            }
            
            if let city = placeMarks?.first?.locality,
                let country = placeMarks?.first?.country {
                completionHandler((city, country))
            } else {
                completionHandler(nil)
            }
        }
    }
    
    static func saveLastLocation(location: Location) {
        let keychain = KeychainSwift()
        
        let _ = keychain.set("\(location.latitude)", forKey: kLatitudeKey)
        let _ = keychain.set("\(location.longitude)", forKey: kLongitudeKey)
        let _ = keychain.set(location.city, forKey: kCityKey)
        let _ = keychain.set(location.country, forKey: kCountryKey)
    }
    
    static func getLastLocationFromKeychain() -> Location {
        let keychain = KeychainSwift()
        let location = Location()
        
        if let latitudeString = keychain.get(kLatitudeKey),
            let latitudeAsDouble = Double(latitudeString),
            let longitudeString = keychain.get(kLongitudeKey),
            let longitudeAsDouble = Double(longitudeString),
            let cityFromKey = keychain.get(kCityKey),
            let countryFromKey = keychain.get(kCountryKey) {
            location.latitude = latitudeAsDouble
            location.longitude = longitudeAsDouble
            location.city = cityFromKey
            location.country = countryFromKey
        }
        
        return location
    }
    
    static func deleteLastLocationFromKeychain() {
        let keychain = KeychainSwift()
        
        keychain.delete(kLongitudeKey)
        keychain.delete(kLatitudeKey)
        keychain.delete(kCityKey)
        keychain.delete(kCountryKey)
    }
    
}
