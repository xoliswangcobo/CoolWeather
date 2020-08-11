//
//  MainWeatherViewController.swift
//  CoolWeather
//
//  Created by Xoliswa on 2020/08/10.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit
import SDWebImage

class MainWeatherViewController: UIViewController {
    var viewModel: WeatherViewModel!
    var settings: SettingsStore!
    
    @IBOutlet weak var noLocationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBinding()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setupBinding() {
        self.viewModel.weatherCasts.observeNext { casts in
            self.tableView.reloadData()
        }.dispose(in: self.bag)
        
//        self.viewModel.weatherCasts.bind(to: self.tableView, cellType: WeatherCastTableViewCell.self) { (cell, weatherCast) in
//            cell.date.text = "\(weatherCast.timestamp())"
//            cell.icon.sd_setImage(with:URL.init(string: weatherCast.icon()))
//            cell.lowTemp.text = "\(weatherCast.temp_min()) \u{00B0}"
//            cell.mainTemp.text = "\(weatherCast.temp()) \u{00B0}"
//            cell.highTemp.text = "\(weatherCast.temp_max()) \u{00B0}"
//            cell.mainWeather.text = weatherCast.mainWeather()
//        }
        
        self.viewModel.locationStatus.observeNext { status in
            switch status {
                case .Available:
                    self.noLocationView.isHidden = true
                case .NotAvailable, .Unknown:
                    self.noLocationView.isHidden = false
            
            }
        }.dispose(in: self.bag)
        
        self.viewModel.weatherCity.observeNext { city in
            if let city = city, city.name != "" {
                self.title = "CoolWeather - \(city.name)"
            } else {
                self.title = "CoolWeather"
            }
        }.dispose(in: self.bag)
        
        self.viewModel.getWeatherCasts(forecastDays: self.settings.forecastDays)
    }
    
    @IBAction func goToPhoneSettings(sender: UIButton) {
        let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsUrl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSettings" {
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! SettingsViewController
            viewController.completion = {
                self.viewModel.getWeatherCasts(forecastDays: self.settings.forecastDays)
            }
        }
    }
}

extension MainWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.weatherCasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCastCell", for: indexPath) as! WeatherCastTableViewCell
        
        let weatherCast = self.viewModel.weatherCasts.collection.item(at: indexPath)
        let date = Date.fromUnixTime(timestamp: weatherCast.timestamp())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.weatherCastDateFormat
        cell.date.text = dateFormatter.string(from: date)
        let url = "\(AppConstants.iconURL)/\(weatherCast.icon())@2x.png"
        cell.icon.sd_setImage(with:URL.init(string: url))
        cell.lowTemp.text = String(format:"%.0f\u{00B0}C", weatherCast.temp_min())
        cell.mainTemp.text = String(format:"%.0f\u{00B0}C", weatherCast.temp())
        cell.mainWeather.text = weatherCast.mainWeather()
        cell.highTemp.text = String(format:"%.0f\u{00B0}C", weatherCast.temp_max())
        cell.innerView.addDropShadowToView()
        
        return cell
    }
    
    
}
