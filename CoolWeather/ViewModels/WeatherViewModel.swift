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
    var weatherCasts = MutableObservableArray<WeatherCastForecast>([])
    var weatherCastsDaily = MutableObservableDictionary<String,[WeatherCastForecast]>([:])
    var weatherCity = Observable<City?>(try? City.decode([ "name": "", "country" : "", "sunset" : 0, "sunrise" : 0]))
    
    init(provider:MoyaProvider<WeatherService>, locationManager: CLLocationManager) {
        self.provider = provider
        self.locationManager = locationManager
        self.locationManager.requestWhenInUseAuthorization()
        
        super.init()
        self.startLocationService()
    }
    
    func getWeatherCasts(forecastDays: Int) {
        self.provider.request(.forecast(lat: self.currentLocation.value.latitude, lon: self.currentLocation.value.longitude, count: 8*forecastDays)) { result in
            switch result {
            case .success(let response):
                do {
                    let castsResponse:WeatherCastForecastResponse? = try WeatherCastForecastResponse.decode(response.data)
                    self.weatherCasts.replace(with: castsResponse?.list ?? [])
                    
                    var dailyCasts: [String: Any] = [:]
                    castsResponse?.list.forEach { cast in
                        let key = "\(Date.fromUnixTime(timestamp: cast.timestamp()).zeroDay().unixTime())"
                        var casts: [WeatherCastForecast] = (dailyCasts[key] as? [WeatherCastForecast]) ?? []
                        casts.append(cast)
                        dailyCasts[key] = casts
                    }
                    
                    self.weatherCastsDaily.replace(with:dailyCasts)
                } catch {
                    
                }
                
                do {
                    let cityResponse:City? = try City.decode(response.data)
                    self.weatherCity.send(cityResponse)
                } catch {
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension WeatherViewModel: CLLocationManagerDelegate {
    
    func startLocationService() {
        self.locationManager.delegate = self
        self.locationManager.activityType = .other
        self.locationManager.pausesLocationUpdatesAutomatically = true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.startUpdatingLocation()
        
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
