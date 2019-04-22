//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Ruxandra Ciortea on 14/04/2019.
//  Copyright © 2019 Ruxandra Ciortea. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak var locationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationsTableView.dataSource = self
        locationsTableView.delegate = self
    }
    
}


extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        let location = Location.getLocations()[indexPath.row]
        
        cell.textLabel?.text = location.city
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let forecast = SwiftSkyManager.getForecastForRegion(latitude: 46.770439,
                                                            longitude: 23.591423)
        print(forecast)
    }
    
}
