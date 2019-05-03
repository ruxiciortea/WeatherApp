//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Ruxandra Ciortea on 14/04/2019.
//  Copyright © 2019 Ruxandra Ciortea. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController {

    // Outlets
    
    @IBOutlet weak var currnetConditionsView: UIView! 
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentSumaryLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var hourlyConditionsTableView: UITableView!
  
    // Constants
    
    private let cellHeightConstant: CGFloat = 60
    private var lastContentOffSet: CGFloat = 0
    
    // Needed variables
    
    private let forecastManager = SwiftSkyManager()
    private var locationManager: CLLocationManager?
    private var currentLocation = Location()
    private var lastLocation = Location() {
        didSet {
            self.getForecatForLocation(self.lastLocation)
        }
    }
    
    // Weather Information
    
    private var currentConditions = CurrentWeatherConditions() {
        didSet {
            self.setCurrentConditionLabels()
        }
    }
    private var hourlyConditions: [HourlyWeatherConditions] = [] {
        didSet {
            self.hourlyConditionsTableView.reloadData()
        }
    }
    private var dailyConditions: [DailyWeatherConditions] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hourlyConditionsTableView.dataSource = self
        self.hourlyConditionsTableView.delegate = self
        
        self.lastLocation = Location.getLastLocationFromKeychain()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.locationManager = Location.requestLocationPermission(delegate: self)
    }
    
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hourlyConditions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultAnimationDuration = 0.1
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! HourlyConditionsCell
        cell.alpha = 0
        
        cell.setHourlyConditionsCell(weatherConditions: hourlyConditions[indexPath.row])
        
        UIView.animate(withDuration: defaultAnimationDuration) {
            cell.alpha = 1
        }

        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.07
    }
    
    // MARK: - LocationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        let latitude = currentLocation.latitude
        let longitude = currentLocation.longitude
        
        self.currentLocation.latitude = latitude
        self.currentLocation.longitude = longitude

        Location.getCityNameFromCoordinates(latidue: latitude, longitude: longitude) { (locationName) in
            if let currentLocationName = locationName {
                let currentCity = currentLocationName.city
                let currentCountry = currentLocationName.country
                
                self.currentLocation.updateLocationWith(city: currentCity,
                                                        country: currentCountry)
                
                if self.lastLocation.city != currentCity {
                    self.lastLocation = self.currentLocation

                    Location.deleteLastLocationFromKeychain()
                    Location.saveLastLocation(location: self.lastLocation)
                    
                    self.getForecatForLocation(Location(latitude: currentLocation.latitude,
                                                        longitude: currentLocation.longitude))
                }
            }
        }
        
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
        }
    }
    
    private func setCurrentConditionLabels() {
        let screenHeight = UIScreen.main.bounds.height
        let temperatureFontSize = screenHeight * 0.045
        let sumaryFontSize = screenHeight * 0.055

        self.currentTemperatureLabel.text = "\(Int(self.currentConditions.temperature))ºC"
        self.currentSumaryLabel.font = self.currentSumaryLabel.font.withSize(sumaryFontSize)
        
        self.currentSumaryLabel.text = "\(currentConditions.summary)"
        self.currentTemperatureLabel.font = self.currentTemperatureLabel.font.withSize(temperatureFontSize)
        
        self.currentLocationLabel.text = self.currentLocation.city
    }
    
}
