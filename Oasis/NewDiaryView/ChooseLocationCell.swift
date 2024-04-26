//
//  ChooseLocationCell.swift
//  Oasis
//
//  Created by joanna on 2024/4/13.
//

import UIKit

class ChooseLocationCell: UITableViewCell {
    
    static let cellIdentifier = "ChooseLocationCell"
    
    private let iconLabel = UILabel()
    private let locationNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "ChooseLocationCell")
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(location: LocationModel) {
        iconLabel.text = location.type.emoji
        locationNameLabel.text = location.name
    }
    
}

extension ChooseLocationCell {
    private func configureUI() {
        contentView.addSubview(iconLabel)
        iconLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        iconLabel.font = UIFont.systemFont(ofSize: 28)
        
        contentView.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconLabel.snp.right).offset(16)
            make.right.lessThanOrEqualToSuperview().inset(16)
        }
        locationNameLabel.textColor = .primary
        locationNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        locationNameLabel.adjustsFontSizeToFitWidth = true // 開啟自動縮小字體大小
        locationNameLabel.minimumScaleFactor = 0.9 // 設置最小比例為0.9
        locationNameLabel.textColor = .primary
    }
}
