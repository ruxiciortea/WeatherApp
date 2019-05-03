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

    @IBOutlet weak var currnetConditionsView: UIView! 
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentSumaryLabel: UILabel!
    @IBOutlet weak var hourlyConditionsTableView: UITableView!
    
    private let cellHeightConstant: CGFloat = 60
    private let forecastManager = SwiftSkyManager()
    private let testLocation = Location.getLocations().first!
    private var locationManager: CLLocationManager?
    
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
    
    private var lastContentOffSet: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hourlyConditionsTableView.dataSource = self
        self.hourlyConditionsTableView.delegate = self
        
        self.makeNavigationBarTransparent()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.topItem?.title = testLocation.city
        self.currentTemperatureLabel.text = ""
        self.currentSumaryLabel.text = ""
        
        self.getForecatForLocation(testLocation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.requestLocationPermission()
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
        return UIScreen.main.bounds.height * 0.075
    }
    
    // MARK: - LocationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        print("LATITUDE: ", currentLocation.latitude, "LONGITUDE: ", currentLocation.longitude)
        self.getForecatForLocation(Location(city: "", country: "",
                                            latitude: currentLocation.latitude,
                                            longitude: currentLocation.longitude))
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
        let temperatureFontSize = screenHeight * 0.05
        let sumaryFontSize = screenHeight * 0.06

        self.currentTemperatureLabel.text = "\(Int(self.currentConditions.temperature))ºC"
        self.currentSumaryLabel.font = self.currentSumaryLabel.font.withSize(sumaryFontSize)
        
        self.currentSumaryLabel.text = "\(currentConditions.summary)"
        self.currentTemperatureLabel.font = self.currentTemperatureLabel.font.withSize(temperatureFontSize)
    }
    
    private func makeNavigationBarTransparent() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
}
