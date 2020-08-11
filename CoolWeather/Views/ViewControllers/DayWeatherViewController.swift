//
//  DayWeatherViewController.swift
//  CoolWeather
//
//  Created by Xoliswa on 2020/08/10.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit

class DayWeatherViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var weatherCasts: [WeatherCastForecast]!
    var city: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let date = Date.fromUnixTime(timestamp: weatherCasts.first?.timestamp() ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.weatherCastDailyDateFormat
        self.title = String(format: "%@ (%@)", dateFormatter.string(from: date), self.city?.name ?? "")
    }
}

extension DayWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherCasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCastCell", for: indexPath) as! WeatherCastTableViewCell
        
        let weatherCast = weatherCasts.item(at: indexPath)
        
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
