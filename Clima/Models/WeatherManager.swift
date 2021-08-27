//
//  WeatherManager.swift
//  Clima
//
//  Created by Anna Shark on 26/8/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f3a66d7f831677537daa8905fff61b66&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //1. Create a URL object
        if let url = URL(string: urlString){
            // 2. Create a URLSession > thing that can perform networing
            let session = URLSession(configuration: .default)
            // 3. Give session a task
            //let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather:weather)
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data)-> WeatherModel?{
        let decoder = JSONDecoder()
        
        do{
           let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
           let id = decodedData.weather[0].id
           let temp = decodedData.main.temp
           let name = decodedData.name
        
           let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
           return weather
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    


}

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

