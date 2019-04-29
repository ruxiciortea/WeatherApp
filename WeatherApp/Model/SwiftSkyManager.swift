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

fileprivate enum ConditionsRequestType {
    case currently
    case hourly
    case daily
}

typealias RequestCompletionBlock = (CurrentWeatherConditions?, [HourlyWeatherConditions]?, [DailyWeatherConditions]?) -> Void

class SwiftSkyManager: NSObject {
    
    private let key = SecretDarkSkyAPIKey.sharedInstance.getKey()
    private let darkSkyForecastURL = "https://api.darksky.net/forecast/"
    private let queue = DispatchQueue.init(label: "backroung queue",
                                           qos: .background,
                                           attributes: .concurrent)
    
    private lazy var requestTypeStatusDictionary: [ConditionsRequestType: Bool] = [ConditionsRequestType.currently : false,
                                                                                   ConditionsRequestType.hourly : false,
                                                                                   ConditionsRequestType.daily : false]
    private var forecastRequestCompletionHandler: RequestCompletionBlock?
    
    private var currentlyConditions: CurrentWeatherConditions?
    private var hourlyConditions: [HourlyWeatherConditions]?
    private var dailyConditions: [DailyWeatherConditions]?
    
    private let maxHoursArrayCapacity = 25
    
    // MARK: - Get Forecast
    
    func getForecast(location: Location,
                     completionHandler: @escaping RequestCompletionBlock) {
        self.forecastRequestCompletionHandler = completionHandler
        
        for key in self.requestTypeStatusDictionary.keys {
            self.requestTypeStatusDictionary[key] = false
        }
        
        DispatchQueue.global(qos: .background).async {
            self.getCurrentForecastFor(location) { (conditions) in
                self.currentlyConditions = conditions
                
                self.didReceiveResponse(requestType: .currently)
            }
            
            self.getHourlyForecastFor(location) { (conditions) in
                self.hourlyConditions = conditions
                
                self.didReceiveResponse(requestType: .hourly)
            }
            
            self.getDailyForecastForLocation(location) { (conditions) in
                self.dailyConditions = conditions
                
                self.didReceiveResponse(requestType: .daily)
            }
        }
    }
    
    // MARK: - Private Functions
    
    private func didReceiveResponse(requestType: ConditionsRequestType) {
        self.requestTypeStatusDictionary[requestType] = true
        
        for value in self.requestTypeStatusDictionary.values {
            if !value {
                return
            }
        }
        
        DispatchQueue.main.async {
            self.forecastRequestCompletionHandler?(self.currentlyConditions, self.hourlyConditions, self.dailyConditions)
        }
    }

}

extension SwiftSkyManager {
    
    // MARK: - Private Requests
    
    //Current
    
    private func getCurrentForecastFor(_ location: Location,
                                       completionHandlere: @escaping (CurrentWeatherConditions?) -> Void) {
        
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
            ).responseJSON(queue: queue, completionHandler: { (response) in
                guard response.result.error == nil,
                    let json = response.result.value as? [String: Any],
                    let currenly = json["currently"] as? [String: Any] else {
                        completionHandlere(nil)
                        
                        return
                }
                
                if let currentConditions = self.getCurrentConditions(json: currenly) {
                    completionHandlere(currentConditions)
                } else {
                    completionHandlere(nil)
                }
            })
    }
    
    //Hourly
    
    private func getHourlyForecastFor(_ location: Location,
                                      completionHandler: @escaping ([HourlyWeatherConditions]?) -> Void) {
        
        let latitudeString = String(location.latitude)
        let longitudeString = String(location.longitude)
        let URL = self.darkSkyForecastURL +
            SecretDarkSkyAPIKey.sharedInstance.getKey() + "/" +
            latitudeString + "," + longitudeString
        
        Alamofire.request(URL, method: .get,
                          parameters: ["key": key,
                                       "latitude": latitudeString,
                                       "longitude": longitudeString,
                                       "exclude": ["minutely", "alerts", "flags"],
                                       "units": "si"]
            ).responseJSON(queue: queue, completionHandler: { (response) in
                guard response.result.error == nil,
                    let json = response.result.value as? [String: Any],
                    let hourly = json["hourly"] as? [String: Any] else {
                        completionHandler(nil)
                        
                        return
                }
                
                if let hourlyConditions = self.getHourlyConditions(json: hourly) {
                    completionHandler(hourlyConditions)
                } else {
                    completionHandler(nil)
                }
            })
        
    }
    
    //Daily
    
    private func getDailyForecastForLocation(_ location: Location,
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
            ).responseJSON(queue: queue, completionHandler: { (response) in
                guard response.result.error == nil,
                    let json = response.result.value as? [String: Any],
                    let daily = json["daily"] as? [String: Any] else {
                        completionHandler(nil)
                        
                        return
                }
                
                if let dailyConditions = self.getDailyConditions(json: daily) {
                    completionHandler(dailyConditions)
                } else {
                    completionHandler(nil)
                }
            })
    }
    
    // MARK: - Get conditions Private Functions
    
    private func getConditionsForJson(_ json: [String: Any]) -> WeatherConditions? {
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
    
    private func getCurrentConditions(json: [String: Any]) -> CurrentWeatherConditions? {
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
    
    private func getHourlyConditions(json: [String: Any]) -> [HourlyWeatherConditions]? {
        var horlyConditionsArray: [HourlyWeatherConditions] = []
        
        guard var hours = json["data"] as? [[String: Any]] else {
            return nil
        }
        
        // Make sure to get forecast only for the next 24 hours
        
        if hours.count > maxHoursArrayCapacity {
            hours.removeLast(hours.count - maxHoursArrayCapacity)
        }
        
        for hour in hours {
            if let conditions = getConditionsForJson(hour) {
                let hourlyConditions = HourlyWeatherConditions()
                hourlyConditions.setUpWithWeatherConditions(weatherConditions: conditions)
                
                if let temperature = hour["temperature"] as? Double,
                    let apparentTemperature = hour["apparentTemperature"] as? Double {
                    hourlyConditions.temperature = temperature
                    hourlyConditions.apparentTemperature = apparentTemperature
                } else {
                    return nil
                }
                
                horlyConditionsArray.append(hourlyConditions)
            } else {
                return nil
            }
        }
        
        return horlyConditionsArray
    }
    
    private func getDailyConditions(json: [String: Any]) -> [DailyWeatherConditions]? {
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
    
}
