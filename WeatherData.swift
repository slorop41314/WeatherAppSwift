//
//  WeatherData.swift
//  Clima
//
//  Created by Albert Stanley on 13/05/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

class WeatherData : Codable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main : Codable {
    let temp : Double
}

struct Weather : Codable {
    let id : Int
}
