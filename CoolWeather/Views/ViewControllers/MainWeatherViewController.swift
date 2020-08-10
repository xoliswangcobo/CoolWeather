//
//  MainWeatherViewController.swift
//  CoolWeather
//
//  Created by Xoliswa on 2020/08/10.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit

class MainWeatherViewController: UIViewController {
    var viewModel: WeatherViewModel!
    var settings: SettingsStore!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSettings" {
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! SettingsViewController
            viewController.completion = {
                
            }
        }
    }
}
