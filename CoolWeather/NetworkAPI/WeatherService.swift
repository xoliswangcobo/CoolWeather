//
//  WeatherService.swift
//  CoolWeather
//
//  Created by Xoliswa on 2020/08/10.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import Moya

enum WeatherService {
    case forecast(lat: String, lon: String, dt: Int)
    case historical(lat: String, lon: String, cnt: Int)
    case current(lat: String, lon: String)
}

extension WeatherService: TargetType {
    
    var baseURL: URL {
        return URL.init(string: AppConstants.apiURL)!
    }
    
    var path: String {
        switch self {
            case .forecast:
                return "/data/2.5/forecast"
            case .historical:
                return "/onecall/timemachine"
            case .current:
            return "/data/2.5/weather"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        var parameters:[String: Any] = [:]
            
        switch self {
            case .forecast(let lat, let lon, let dt):
                parameters["lat"] = lat
                parameters["lon"] = lon
                parameters["dt"] = dt
            case .historical(let lat, let lon, let dt):
                parameters["lat"] = lat
                parameters["lon"] = lon
                parameters["dt"] = dt
            case .current(let lat, let lon):
                parameters["lat"] = lat
                parameters["lon"] = lon
        }
        
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
}
