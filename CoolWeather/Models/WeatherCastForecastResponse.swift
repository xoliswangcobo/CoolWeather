//
//  WeatherCastForecastResponse.swift
//  CoolWeather
//
//  Created by Xoliswa on 2020/08/10.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

struct WeatherCastForecast: Decodable {
    func mainWeather() -> String {
        return self.weather.first?.main ?? ""
    }
    
    func description() -> String {
        return self.weather.first?.description ?? ""
    }
    
    func icon() -> String {
        return self.weather.first?.icon ?? ""
    }
    
    func timestamp() -> Int {
        return self.dt
    }
    
    private let dt: Int
    
    func temp() -> Double {
        return self.main.temp
    }
    
    func temp_min() -> Double {
        return self.main.temp_min
    }
    
    func temp_max() -> Double {
        return self.main.temp_max
    }
    
    func wind_speed() -> Double {
        return self.wind.speed
    }
    
    private let main: Main
    private let weather:[WeatherItem]
    private let wind: Wind
    
    private struct Main: Decodable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
    }
    
    private struct WeatherItem: Decodable {
        let main: String
        let description: String
        let icon: String
    }
    
    private struct Wind: Decodable {
        let speed: Double
    }
}

struct WeatherCastForecastResponse: Decodable {
    let message: Int
    let cod: String
    let list:[WeatherCastForecast]
}
