//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Ruxandra Ciortea on 14/04/2019.
//  Copyright © 2019 Ruxandra Ciortea. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak var currnetConditionsView: UIView! 
    @IBOutlet weak var hourlyConditionsTableView: UITableView! {
        didSet {
            hourlyConditionsTableView.setCornerRadius(cornerRadius: 10)
        }
    }
    
    private let cellHeightConstant: CGFloat = 60
    private let forecastManager = SwiftSkyManager()
    
    private var currentConditions = CurrentWeatherConditions()
    private var hourlyConditions: [HourlyWeatherConditions] = []
    private var dailyConditions: [DailyWeatherConditions] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourlyConditionsTableView.dataSource = self
        hourlyConditionsTableView.delegate = self
        
        self.getForecatForLocation(Location.getLocations().first!)
    }
    
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hourlyConditions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! HourlyConditionsCell
        
        cell.setHourlyConditionsCell(weatherConditions: hourlyConditions[indexPath.row])
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.1, animations: { cell.alpha = 1 })

        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.075

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
}

extension ForecastViewController {
    
    // MARK: - Private Functions
    
    private func getForecatForLocation(_ location: Location) {
        forecastManager.getForecast(location: location) {
            (currentConditions, hourlyConditions, dailyConditions) in
            if currentConditions != nil, hourlyConditions != nil, dailyConditions != nil {
                self.currentConditions = currentConditions!
                self.hourlyConditions = hourlyConditions!
                self.dailyConditions = dailyConditions!
            }
            
            self.hourlyConditionsTableView.reloadData()
        }
    }
    
}
