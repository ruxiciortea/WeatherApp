//
//  WeatherConditions.swift
//  WeatherApp
//
//  Created by Ruxandra Ciortea on 18/04/2019.
//  Copyright © 2019 Ruxandra Ciortea. All rights reserved.
//

import UIKit

class WeatherConditions: NSObject {
    
    var temperature: Double =  66.1
    var apparentTemperature: Double = 66.31
    var precipIntensity: Double = 0.0089
    var precipProbability: Double = 0.9
    var nearestStormDistance: Double = 0
    var humidity: Double = 0.83
    var windSpeed: Double = 5.59
    var cloudCover: Double = 0.7
    var visibility: Double = 9.84
    var summary: String = "Drizzle"
    var icon: String = "rain"
    var precipType: String = "rain"

    override init() {
        self.temperature = 0
        self.apparentTemperature = 0
        self.precipIntensity = 0
        self.precipProbability = 0
        self.nearestStormDistance = 0
        self.humidity = 0
        self.windSpeed = 0
        self.cloudCover = 0
        self.visibility = 0
        self.summary = ""
        self.icon = ""
        self.precipType = ""
    }
    
    init(temperature: Double,
         apparentTemperature: Double,
         precipIntensity: Double,
         precipProbability: Double,
         nearestStormDistance: Double,
         humidity: Double,
         windSpeed: Double,
         cloudCover: Double,
         visibility: Double,
         summary: String,
         icon: String,
         precipType: String) {
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.precipIntensity = precipIntensity
        self.precipProbability = precipProbability
        self.nearestStormDistance = nearestStormDistance
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.cloudCover = cloudCover
        self.visibility = visibility
        self.summary = summary
        self.icon = icon
        self.precipType = precipType
    }
    
}
