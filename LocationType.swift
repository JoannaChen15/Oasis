//
//  LocationType.swift
//  Oasis
//
//  Created by joanna on 2024/4/8.
//

import Foundation

enum LocationType: String, CaseIterable {
    case campground
    case beach
    case hiking
    case park

    var emoji: String {
        switch self {
        case .campground:
            return "🏕️"
        case .beach:
            return "🏖"
        case .hiking:
            return "⛰"
        case .park:
            return "🌳"
        }
    }
    
    var displayName: String {
        switch self {
        case .campground:
            return "營地"
        case .beach:
            return "海灘"
        case .hiking:
            return "步道"
        case .park:
            return "公園"
        }
    }
}
