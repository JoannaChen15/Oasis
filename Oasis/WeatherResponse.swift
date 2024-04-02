//
//  WeatherResponse.swift
//  Oasis
//
//  Created by joanna on 2024/4/2.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let main: Main
    let wind: Wind
    let clouds: Clouds
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}
