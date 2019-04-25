//
//  WeatherConditions.swift
//  WeatherApp
//
//  Created by Ruxandra Ciortea on 18/04/2019.
//  Copyright © 2019 Ruxandra Ciortea. All rights reserved.
//

import UIKit

class WeatherConditions: NSObject {
    
    var precipIntensity: Double
    var precipProbability: Double
    var humidity: Double
    var windSpeed: Double
    var cloudCover: Double
    var visibility: Double
    var time: Double
    var summary: String
    var icon: String

    override init() {
        self.precipIntensity = 0
        self.precipProbability = 0
        self.humidity = 0
        self.windSpeed = 0
        self.cloudCover = 0
        self.visibility = 0
        self.time = 0
        self.summary = ""
        self.icon = ""
    }
    
    init(precipIntensity: Double,
         precipProbability: Double,
         humidity: Double,
         windSpeed: Double,
         cloudCover: Double,
         visibility: Double,
         time: Double,
         summary: String,
         icon: String) {
        self.precipIntensity = precipIntensity
        self.precipProbability = precipProbability
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.cloudCover = cloudCover
        self.visibility = visibility
        self.time = time
        self.summary = summary
        self.icon = icon
    }
    
    func setUpWithWeatherConditions(weatherConditions: WeatherConditions) {
        self.precipProbability = weatherConditions.precipIntensity
        self.precipProbability = weatherConditions.precipProbability
        self.humidity = weatherConditions.humidity
        self.windSpeed = weatherConditions.windSpeed
        self.cloudCover = weatherConditions.cloudCover
        self.visibility = weatherConditions.visibility
        self.time = weatherConditions.time
        self.summary = weatherConditions.summary
        self.icon = weatherConditions.icon
    }
    
}
