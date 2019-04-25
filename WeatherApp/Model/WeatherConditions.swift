//
//  WeatherConditions.swift
//  WeatherApp
//
//  Created by Ruxandra Ciortea on 18/04/2019.
//  Copyright © 2019 Ruxandra Ciortea. All rights reserved.
//

import UIKit

class WeatherConditions: NSObject {
    
    var temperature: Int
    var apparentTemperature: Int
    var precipitationRate: Int

    override init() {
        self.temperature = 0
        self.apparentTemperature = 0
        self.precipitationRate = 0
    }
    
    init(temperature: Int, apparentTemperature: Int, precipitationRate: Int) {
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.precipitationRate = precipitationRate
    }
    
}
