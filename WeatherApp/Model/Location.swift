//
//  Location.swift
//  WeatherApp
//
//  Created by Ruxandra Ciortea on 13/04/2019.
//  Copyright © 2019 Ruxandra Ciortea. All rights reserved.
//

import UIKit
import CoreLocation

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
    }
    
    init(city: String, country: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
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
