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
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChooseLocationCell {
    private func configure() {
        contentView.addSubview(iconLabel)
        iconLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        iconLabel.font = UIFont.systemFont(ofSize: 36)
        
        contentView.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconLabel.snp.right).offset(16)
        }
        locationNameLabel.textColor = .primary
        locationNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        locationNameLabel.textColor = .primary
        
        //test
        iconLabel.text = "🏕️"
        locationNameLabel.text = "123露營區"
    }
}
