//
//  SearchLocationViewController.swift
//  WeatherApp
//
//  Created by Ruxandra Ciortea on 03/05/2019.
//  Copyright © 2019 Ruxandra Ciortea. All rights reserved.
//

import UIKit

class SearchLocationViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    @IBAction func didPressDoneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
