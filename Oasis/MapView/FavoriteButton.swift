//
//  FavoriteButton.swift
//  Oasis
//
//  Created by joanna on 2024/4/2.
//

import UIKit

class FavoriteButton: UIButton {
    
    let favoriteImageView = UIImageView()
    
    var status: FavoriteButtonStatus = .unselected {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(favoriteImageView)
        favoriteImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        updateUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI() {
        favoriteImageView.image = status.image
        tintColor = status.color
    }

}

enum FavoriteButtonStatus {
    case selected
    case unselected
    
    var image: UIImage {
        switch self {
        case .unselected:
            return UIImage(systemName: "heart")!
        case .selected:
            return UIImage(systemName: "heart.fill")!
        }
    }
    
    var color: UIColor {
        switch self {
        case .unselected:
            return .systemGray
        case .selected:
            return .red
        }
    }
}
