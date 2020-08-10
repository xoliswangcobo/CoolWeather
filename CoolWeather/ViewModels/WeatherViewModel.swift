//
//  WeatherViewModel.swift
//  CoolWeather
//
//  Created by Xoliswa on 2020/08/10.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import Moya

class WeatherViewModel {
    
    private let provider:MoyaProvider<WeatherService>!
    
    init(provider:MoyaProvider<WeatherService>) {
        self.provider = provider
    }
}
