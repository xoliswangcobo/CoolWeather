//
//  WeatherCast.swift
//  CoolWeather
//
//  Created by Xoliswa on 2020/08/10.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

struct WeatherCastHistorical: Decodable {
    let main: String
    let description: String
    let icon: String
    let timestamp: Int
    let temp: Double
}

struct WeatherCastResponse: Decodable {
    let message: String
    let cod: String
}
