//
//  WeatherManager.swift
//  Clima
//
//  Created by Albert Stanley on 13/05/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weather : WeatherModel)
    func didError(_ error : Error)
}
class WeatherManager {
    var url = "https://api.openweathermap.org/data/2.5/weather?appid=4b64c74397076a726906b52d2d26aa0a&units=metric"
    var delegate: WeatherManagerDelegate?
    func fetchWeather (cityName : String) {
        let urlString = "\(url)&q=\(cityName)"
        performRequest(urlString)
    }
    func fetchWeather (latitude lat : Double, longitude lon : Double) {
        let urlString = "\(url)&lat=\(lat)&lon=\(lon)"
        performRequest(urlString)
    }
    func performRequest (_ urlString : String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data, response, error) in
                if error != nil {
                    self.delegate?.didError(error!)
                    return
                }
                if let data = data {
                    if let weather = self.parseJSON(weatherData: data){
                        self.delegate?.didUpdateWeather(weather)
                    }
                }
            }
            task.resume()
        }
        
    }
    func parseJSON (weatherData : Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weather = WeatherModel(conditionID: decodedData.weather[0].id, cityName: decodedData.name
                , temperature: decodedData.main.temp)
            return weather
        }catch {
            self.delegate?.didError(error)
            return nil
        }
    }
}
