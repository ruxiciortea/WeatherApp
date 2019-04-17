//
//  Location.swift
//  WeatherApp
//
//  Created by Ruxandra Ciortea on 13/04/2019.
//  Copyright © 2019 Ruxandra Ciortea. All rights reserved.
//

import UIKit

class Location: NSObject {
    
    var city: String
    var country: String
    
    override init() {
        self.city = ""
        self.country = ""
    }
    
    init(city: String, country: String) {
        self.city = city
        self.country = country
    }
    
    static func getLocations() -> [Location] {
        var locationsArray: [Location] = []
        
        let location1 = Location.init(city: "Cluj", country: "Romania")
        locationsArray.append(location1)
        
        let location2 = Location.init(city: "Bucharest", country: "Romania")
        locationsArray.append(location2)

        let location3 = Location.init(city: "London", country: "UK")
        locationsArray.append(location3)

        let location4 = Location.init(city: "Berlin", country: "Germany")
        locationsArray.append(location4)

        let location5 = Location.init(city: "Oslo", country: "Norway")
        locationsArray.append(location5)

        return locationsArray
    }
    
}
