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
    
    // MARK: - Requests
    
    static func getCurrentForecastFor(_ location: Location,
                                      completionHandlere: @escaping (WeatherConditions?) -> Void) {
        
        let latitudeString = String(location.latitude)
        let longitudeString = String(location.longitude)
        let URL = darkSkyForecastURL +
                  SecretDarkSkyAPIKey.sharedInstance.getKey() + "/" +
                  latitudeString + "," + longitudeString

        Alamofire.request(URL,
                          method: .get,
                          parameters: ["key": key,
                                       "latitude": latitudeString,
                                       "longitude": longitudeString,
                                       "exclude": ["minutely", "alerts", "flags"],
                                       "units": "si"]
            ).responseJSON { (response) in
                guard response.result.error == nil,
                    let json = response.result.value as? [String: Any],
                    let currenly = json["currently"] as? [String: Any] else {
                    completionHandlere(nil)
                        
                    return
                }
                
                if let currentConditions = getCurrentConditions(json: currenly) {
                    completionHandlere(currentConditions)
                } else {
                    completionHandlere(nil)
                }
        }
                                        
    }
    
    static func getHourlyForecastFor(_ location: Location,
                                     completionHandler: @escaping ([HourlyWeatherConditions]?) -> Void) {
        
        let latitudeString = String(location.latitude)
        let longitudeString = String(location.longitude)
        let URL = darkSkyForecastURL +
                  SecretDarkSkyAPIKey.sharedInstance.getKey() + "/" +
                  latitudeString + "," + longitudeString
        
        Alamofire.request(URL, method: .get,
                          parameters: ["key": key,
                                       "latitude": latitudeString,
                                       "longitude": longitudeString,
                                       "exclude": ["minutely", "alerts", "flags"],
                                       "units": "si"]
            ).responseJSON { (response) in
                guard response.result.error == nil,
                    let json = response.result.value as? [String: Any],
                    let hourly = json["hourly"] as? [String: Any] else {
                    completionHandler(nil)
                    
                    return
                }
                
                if let hourlyConditions = getHourlyConditions(json: hourly) {
                    completionHandler(hourlyConditions)
                } else {
                    completionHandler(nil)
                }
        }
        
    }
    
    static func getDailyForecastForLocation(_ location: Location,
                                            completionHandler: @escaping ([DailyWeatherConditions]?) -> Void) {
        
        let latitudeString = String(location.latitude)
        let longitudeString = String(location.longitude)
        let URL = darkSkyForecastURL +
        SecretDarkSkyAPIKey.sharedInstance.getKey() + "/" +
        latitudeString + "," + longitudeString
        
        Alamofire.request(URL, method: .get,
                          parameters: ["key": key,
                                       "latitude": latitudeString,
                                       "longitude": longitudeString,
                                       "exclude": ["minutely", "alerts", "flags"],
                                       "units": "si"]
            ).responseJSON { (response) in
                guard response.result.error == nil,
                    let json = response.result.value as? [String: Any],
                    let daily = json["daily"] as? [String: Any] else {
                    completionHandler(nil)
                    
                    return
                }
                
                if let dailyConditions = getDailyConditions(json: daily) {
                    completionHandler(dailyConditions)
                } else {
                    completionHandler(nil)
                }
        }
        
    }
    
    // MARK: - Private Functions
    
    private static func getCurrentConditions(json: [String: Any]) -> CurrentWeatherConditions? {
        let currentConditions = CurrentWeatherConditions.init()
        
        if let conditions = getConditionsForJson(json) {
            currentConditions.setUpWithWeatherConditions(weatherConditions: conditions)
        } else {
            return nil
        }

        if let temperature = json["temperature"] as? Double,
            let apparentTemperature = json["apparentTemperature"] as? Double {
            currentConditions.temperature = temperature
            currentConditions.apparentTemperature = apparentTemperature
        } else {
            return nil
        }
        
        return currentConditions
    }
    
    private static func getHourlyConditions(json: [String: Any]) -> [HourlyWeatherConditions]? {
        var horlyConditionsArray: [HourlyWeatherConditions] = []
        
        guard let hours = json["data"] as? [[String: Any]] else {
            return nil
        }
        
        for hour in hours {
            if let conditions = getConditionsForJson(hour) {
                let hourlyConditions = HourlyWeatherConditions()
                hourlyConditions.setUpWithWeatherConditions(weatherConditions: conditions)
                
                horlyConditionsArray.append(hourlyConditions)
            } else {
                return nil
            }
        }
        
        return horlyConditionsArray
    }
    
    private static func getDailyConditions(json: [String: Any]) -> [DailyWeatherConditions]? {
        var dailyConditionsArray: [DailyWeatherConditions] = []
        
        guard let days = json["data"] as? [[String: Any]] else {
            return nil
        }
        
        for day in days {
            if let conditions = getConditionsForJson(day) {
                let dailyConditions = DailyWeatherConditions()
                dailyConditions.setUpWithWeatherConditions(weatherConditions: conditions)
                
                if let maxTemperature = json["temperatureMax"] as? Double,
                    let minTemperature = json["temperatureLow"] as? Double,
                    let sunriseTime = json["sunriseTime"] as? Double,
                    let sunsetTime = json["sunsetTime"] as? Double,
                    let moonPhase = json["moonPhase"] as? Double {
                    dailyConditions.maximTemperature = maxTemperature
                    dailyConditions.mainimTemperature = minTemperature
                    dailyConditions.sunriseTime = sunriseTime
                    dailyConditions.sunriseTime = sunsetTime
                    dailyConditions.moonPhase = moonPhase
                }
                
                dailyConditionsArray.append(dailyConditions)
            } else {
                return nil
            }
        }
        
        return dailyConditionsArray
    }
    
    private static func getConditionsForJson(_ json: [String: Any]) -> WeatherConditions? {
        if let precipIntensity = json["precipIntensity"] as? Double,
            let precipProbability = json["precipProbability"] as? Double,
            let humidity = json["humidity"] as? Double,
            let windSpeed = json["windSpeed"] as? Double,
            let cloudCover = json["cloudCover"] as? Double,
            let visibility = json["visibility"] as? Double,
            let time = json["time"] as? Double,
            let summary = json["summary"] as? String,
            let icon = json["icon"] as? String {
            let requestedConditions = WeatherConditions(precipIntensity: precipIntensity,
                                                        precipProbability: precipProbability,
                                                        humidity: humidity,
                                                        windSpeed: windSpeed,
                                                        cloudCover: cloudCover,
                                                        visibility: visibility,
                                                        time: time,
                                                        summary: summary,
                                                        icon: icon)
            return requestedConditions
        } else {
            return nil
        }
    }
    
}
