//
//  HourlyConditionsCell.swift
//  WeatherApp
//
//  Created by Ruxandra Ciortea on 29/04/2019.
//  Copyright © 2019 Ruxandra Ciortea. All rights reserved.
//

import UIKit

class HourlyConditionsCell: UITableViewCell {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    
    func setHourlyConditionsCell(weatherConditions: HourlyWeatherConditions) {
        let date = Date(timeIntervalSince1970: weatherConditions.time)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        self.hourLabel.text = "\(hour):00"
        self.iconLabel.text = weatherConditions.icon
        self.temperatureLabel.text = "\(Int(weatherConditions.temperature))ºC"
    }

}
