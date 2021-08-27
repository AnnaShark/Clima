//
//  WeatherData.swift
//  Clima
//
//  Created by Anna Shark on 26/8/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable{
    let temp: Double
}

struct Weather: Codable{
    let id: Int
    
}
