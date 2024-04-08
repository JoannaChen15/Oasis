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
    //    case mountains
    var emoji: String {
        switch self {
        case .campground:
            return "🏕️"
        case .beach:
            return "🏝"
        case .hiking:
            return "🏔"
        }
    }
}
