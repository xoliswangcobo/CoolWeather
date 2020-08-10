//
//  SettingsStore.swift
//  CoolWeather
//
//  Created by Xoliswa on 2020/08/10.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

class SettingsStore {
    
    var historyDays: Int {
        didSet {
            save()
        }
    }
    
    var forecastDays:Int {
        didSet {
            save()
        }
    }
    
    let historyDaysLimit: Int = AppConstants.historyDaysLimit
    let forecastDaysLimit:Int = AppConstants.forecastDaysLimit
    
    static let current = SettingsStore()
    
    private init() {
        let settings = SettingsStore.get()
        self.historyDays = settings.history > 0 ? settings.history : 2
        self.forecastDays = settings.forecast > 0 ? settings.forecast : 5
    }
    
    private func save() {
        UserDefaults.standard.set(self.historyDays, forKey: "History")
        UserDefaults.standard.set(self.forecastDays, forKey: "Forecast")
    }
    
    private static func get() -> (history:Int, forecast:Int) {
        return (UserDefaults.standard.integer(forKey: "History"), UserDefaults.standard.integer(forKey: "Forecast"))
    }
}
