//
//  NetworkManager.swift
//  Oasis
//
//  Created by joanna on 2024/4/2.
//

import Alamofire

// MARK: - NetworkManager

class NetworkManager {
    
    let apiKey = "ca3ff36e191a554c093fd1b93ad9306e"
    
    func getCurrentWeatherData(lat: Double, lon: Double, completion: @escaping (Result<WeatherResponse,Error>) -> Void) {
        
        let parameters: [String : Any] = [
            "lat": lat,
            "lon": lon,
            "appid": apiKey
        ]
        
        AF.request("https://api.openweathermap.org/data/2.5/weather", method: .get, parameters: parameters)
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    do {
                        let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                        completion(.success(weatherResponse))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Network request failed with error: \(error)")
                }
                
            }
    }
    
}
