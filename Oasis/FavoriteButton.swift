//
//  FavoriteButton.swift
//  Oasis
//
//  Created by joanna on 2024/4/2.
//

import UIKit

//protocol FavoriteButtonDelegate {
//    func FavoriteButtonTapped(_ sender: FavoriteButton)
//}

class FavoriteButton: UIButton {
    
    let favoriteImageView = UIImageView()
    
//    var delegate: FavoriteButtonDelegate?
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
        favoriteImageView.image = status.image
        addTarget(self, action: #selector(didSelected), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI() {
        self.favoriteImageView.image = status.image
    }
    
    @objc func didSelected(sender: UIButton) {
        switch self.status {
        case .unselected:
            self.status = .selected
            self.tintColor = .red
        case .selected:
            self.status = .unselected
            self.tintColor = .systemGray
        }
//        self.delegate?.FavoriteButtonTapped(sender as! FavoriteButton)
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
}
