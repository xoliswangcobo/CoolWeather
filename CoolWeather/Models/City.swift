//
//  City.swift
//  CoolWeather
//
//  Created by Xoliswa on 2020/08/10.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

struct City: Decodable {
    let name: String
    let country: String
    let sunset: Int
    let sunrise: Int
    
    enum CodingKeys: String, CodingKey {
        case city
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let city = try values.decodeIfPresent([String:Any].self, forKey: .city)
        
        self.name = (city?["name"] as? String) ?? ""
        self.country = (city?["country"] as? String) ?? ""
        self.sunrise = (city?["sunrise"] as? Int) ?? 0
        self.sunset = (city?["sunset"] as? Int) ?? 0
    }
}
