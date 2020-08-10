//
//  WeatherViewModel.swift
//  CoolWeather
//
//  Created by Xoliswa on 2020/08/10.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import Moya
import CoreLocation
import Bond

class WeatherViewModel: NSObject {
    
    private let provider:MoyaProvider<WeatherService>!
    private let locationManager: CLLocationManager!
    private var currentLocation = Observable<CLLocationCoordinate2D>(CLLocationCoordinate2D.init(latitude: 90.1, longitude: 180.005))
    
    // Mark : Bond
    var locationStatus = Observable<LocationStatus>(.Unknown)
    var operationStatus = Observable<WeatherServiceOperationStatus>(.None)
    
    init(provider:MoyaProvider<WeatherService>, locationManager: CLLocationManager) {
        self.provider = provider
        self.locationManager = locationManager
        self.locationManager.requestWhenInUseAuthorization()
        
        super.init()
        self.startLocationService()
    }
}

extension WeatherViewModel: CLLocationManagerDelegate {
    
    func startLocationService() {
        self.locationManager.delegate = self
        self.locationManager.activityType = .other
        self.locationManager.pausesLocationUpdatesAutomatically = true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.startMonitoringSignificantLocationChanges()
        
        if let location = self.locationManager.location {
            self.currentLocation.send(location.coordinate)
        }
        
        self.checkLocationService()
    }
    
    func checkLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                    self.locationStatus.send(.Unknown)
                case .restricted, .denied:
                    self.locationStatus.send(.NotAvailable)
                case .authorizedAlways, .authorizedWhenInUse:
                    self.locationStatus.send(.Available)
                @unknown default:
                    break
            }
        } else {
            self.locationStatus.send(.NotAvailable)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationService()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if self.currentLocation.value.latitude > 90.005 || self.currentLocation.value.longitude > 180.005 {
             self.locationStatus.send(.Unknown)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        self.currentLocation.send(location.coordinate)
    }
}
