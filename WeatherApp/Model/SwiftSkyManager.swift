//
//  SwiftSkyManager.swift
//  WeatherApp
//
//  Created by Ruxandra Ciortea on 18/04/2019.
//  Copyright © 2019 Ruxandra Ciortea. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

private let key = SecretDarkSkyAPIKey.sharedInstance.getKey()
let darkSkyForecastURL = "https://api.darksky.net/forecast/"

class SwiftSkyManager: NSObject {
    
    static func getForecastForRegion(latitude: CLLocationDegrees,
                                     longitude: CLLocationDegrees) -> [WeatherConditions] {
        
        let latitudeString = String(latitude)
        let longitudeString = String(longitude)
        let URL = darkSkyForecastURL +
                  SecretDarkSkyAPIKey.sharedInstance.getKey() + "/" +
                  latitudeString + "," + longitudeString
        var forecastsArray: [WeatherConditions] = []

        Alamofire.request(URL,
                          method: .get,
                          parameters: ["key": key,
                                       "latitude": latitudeString,
                                       "longitude": longitudeString,
                                       "exclude": ["minutely", "alerts", "flags"]]
            ).responseJSON { (response) in

                guard response.result.error == nil else {
                    print("ERROR")
                    
                    return
                }
                
                guard let result = response.result.value else {
                    print("ERROR2")
                    
                    return
                }
                
                guard let json = result as? [String: Any] else {
                    print("ERROR3")
                    
                    return
                }
                
                print(json)
        }
                                        
        return forecastsArray
    }
    
}
