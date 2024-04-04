//
//  LocationModel.swift
//  Oasis
//
//  Created by joanna on 2024/4/1.
//

import Foundation

class LocationModel: Hashable {
    
    let name: String
    let latitude: Double
    let longitude: Double
    var favoriteStatus: FavoriteButtonStatus
    private var weatherData: WeatherResponse?
    
    private let networkManager = NetworkManager()
    
    init(name: String, latitude: Double, longitude: Double, favoriteStatus: FavoriteButtonStatus, weatherData: WeatherResponse? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.favoriteStatus = favoriteStatus
        self.weatherData = weatherData
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    
    static func == (lhs: LocationModel, rhs: LocationModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func fetchWeatherData(completion: @escaping (WeatherResponse) -> Void) {
        if let weatherData = weatherData {
            completion(weatherData)
            return
        }
        // 抓取天氣資料
        networkManager.getCurrentWeatherData(lat: latitude, lon: longitude) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let weatherData):
                self.weatherData = weatherData
                completion(weatherData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
