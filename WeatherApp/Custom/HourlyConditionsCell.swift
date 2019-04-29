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
    
    override func awakeFromNib() {
        let cellsSeparatorRightInset: CGFloat = 16
        
        self.separatorInset.right = cellsSeparatorRightInset
    }
    
    func setHourlyConditionsCell(weatherConditions: HourlyWeatherConditions) {
        let screenHeight = UIScreen.main.bounds.height
        let fontSize = screenHeight * 0.03

        let date = Date(timeIntervalSince1970: weatherConditions.time)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        self.hourLabel.text = "\(hour):00"
        self.hourLabel.font = self.hourLabel.font.withSize(fontSize)
        
        self.iconLabel.text = weatherConditions.icon
        self.iconLabel.font = self.iconLabel.font.withSize(fontSize)

        self.temperatureLabel.text = "\(Int(weatherConditions.temperature))ºC"
        self.temperatureLabel.font = self.temperatureLabel.font.withSize(fontSize)

    }
    
}
