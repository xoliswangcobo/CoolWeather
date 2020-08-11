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
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBinding()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        self.viewModel.getWeatherCasts(forecastDays: self.settings.forecastDays)
    }
    
    func setupBinding() {
        self.viewModel.weatherCastsDaily.observeNext { casts in
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }.dispose(in: self.bag)
        
        self.viewModel.locationStatus.observeNext { status in
            switch status {
                case .Available:
                    self.noLocationView.isHidden = true
                    self.tableView.isHidden = false
                case .NotAvailable, .Unknown:
                    self.noLocationView.isHidden = false
                    self.tableView.isHidden = true
            
            }
        }.dispose(in: self.bag)
        
        self.viewModel.weatherCity.observeNext { city in
            if let city = city, city.name != "" {
                self.title = "CoolWeather - \(city.name)"
            } else {
                self.title = "CoolWeather"
            }
        }.dispose(in: self.bag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.viewModel.getWeatherCasts(forecastDays: self.settings.forecastDays)
        }
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
        } else if segue.identifier == "toWeatherDetails" {
            let viewController = segue.destination as! DayWeatherViewController
            let indexPath = sender as! IndexPath
            let keys:[String] = Array(self.viewModel.weatherCastsDaily.collection.keys.sorted())
            viewController.weatherCasts = self.viewModel.weatherCastsDaily.collection[keys[indexPath.row]]
            viewController.city = self.viewModel.weatherCity.value
        }
    }
}

extension MainWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.weatherCastsDaily.collection.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCastCell", for: indexPath) as! WeatherCastTableViewCell
        
        let castsKey = Array(self.viewModel.weatherCastsDaily.collection.keys.sorted())[indexPath.row]
        
        let casts = self.viewModel.weatherCastsDaily.collection[castsKey]?.sorted(by: { $0.timestamp() < $1.timestamp() }) ?? []
        
        let maxTemp = casts.map { $0.temp_max() }.max()
        let minTemp = casts.map { $0.temp_min() }.min()
        cell.highTemp.text = String(format:"%.0f\u{00B0}C", (maxTemp ?? 0))
        cell.lowTemp.text = String(format:"%.0f\u{00B0}C", (minTemp ?? 0))
        
        
        let weatherCast = casts.last
        cell.mainTemp.text = String(format:"%.0f\u{00B0}C", weatherCast?.temp() ?? 0)
        
        let date = Date.fromUnixTime(timestamp: weatherCast?.timestamp() ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.weatherCastDailyDateFormat
        cell.date.text = dateFormatter.string(from: date)
        
        let url = "\(AppConstants.iconURL)/\(weatherCast?.icon() ?? "")@2x.png"
        cell.icon.sd_setImage(with:URL.init(string: url))
        cell.mainWeather.text = weatherCast?.mainWeather()
        
        cell.innerView.addDropShadowToView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toWeatherDetails", sender: indexPath)
    }
}
