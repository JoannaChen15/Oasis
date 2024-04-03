//
//  Location.swift
//  Oasis
//
//  Created by joanna on 2024/4/1.
//

import Foundation

struct Location: Equatable {
    let name: String
    let latitude: Double
    let longitude: Double
    var favoriteStatus: FavoriteButtonStatus = .unselected
}
