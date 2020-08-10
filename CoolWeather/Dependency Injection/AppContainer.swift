//
//  AppContainer.swift
//  CoolWeather
//
//  Created by Xoliswa on 2020/08/10.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import Swinject
import Moya
import CoreLocation

class AppContainer {
    
    static let shared = AppContainer()
    
    let container = Container()
    
    private init() {
        setupDefaultContainers()
    }
    
    private func setupDefaultContainers() {
        
        container.register(MoyaProvider<WeatherService>.self) { resolver in
            return MoyaProvider<WeatherService>()
        }
        
        container.register(WeatherViewModel.self) { resolver in
            return WeatherViewModel.init(provider: resolver.resolve(MoyaProvider<WeatherService>.self)!, locationManager: CLLocationManager.init())
        }
        
        container.register(SettingsStore.self) { resolver in
            return SettingsStore.current
        }
    }
}
