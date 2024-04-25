//
//  SelectionButton.swift
//  Oasis
//
//  Created by joanna on 2024/4/10.
//

import UIKit
import SnapKit

class SelectionButton: UIButton {
    
    let mainLabel = UILabel()
    let detailLabel = UILabel()
    let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        
        addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(24)
        }
        mainLabel.textColor = .primary
        
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(mainLabel)
            make.right.equalToSuperview().inset(24)
        }
        iconImageView.image = UIImage(systemName: "chevron.right")
        iconImageView.tintColor = .systemGray
        
        addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mainLabel)
            make.left.greaterThanOrEqualTo(mainLabel.snp.right).offset(16)
            make.right.equalTo(iconImageView.snp.left).offset(-16)
        }
        detailLabel.textColor = .systemGray
    }
    
}



