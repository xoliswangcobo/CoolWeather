//
//  Swinject+Storyboard.swift
//  CoolWeather
//
//  Created by Xoliswa on 2020/08/10.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        
        let appContainer = AppContainer.shared.container
        
        defaultContainer.storyboardInitCompleted(MainWeatherViewController.self) { _, controller in
            controller.viewModel = appContainer.resolve(WeatherViewModel.self)
        }
    }
}
