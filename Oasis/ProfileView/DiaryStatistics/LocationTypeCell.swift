//
//  LocationTypeCell.swift
//  Oasis
//
//  Created by joanna on 2024/4/8.
//

import UIKit
import SnapKit

class LocationTypeCell: UICollectionViewCell {
    
    static let cellIdentifier = "LocationTypeCell"
    //MARK: Prop
    private let shadowView = UIView()
    private let emojiView = UIView()
    private let emojiLabel = UILabel()
    private let locationTypeLabel = UILabel()
    private let countLabel = UILabel()
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(locationTypeCellModel: LocationTypeCellModel) {
        emojiLabel.text = "\(locationTypeCellModel.type?.emoji ?? "🌱")"
        locationTypeLabel.text = "\(locationTypeCellModel.type?.displayName ?? "全部")"
        countLabel.text = "\(locationTypeCellModel.count)"
    }
    
    private func configureUI(){
        contentView.addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(124)
            make.width.equalTo(72)
        }
        shadowView.backgroundColor = .systemBackground
        shadowView.layer.cornerRadius = 36
        shadowView.layer.shadowColor = UIColor.systemGray4.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 4
        
        contentView.addSubview(emojiView)
        emojiView.snp.makeConstraints { make in
            make.top.equalTo(shadowView.snp.top).inset(10)
            make.centerX.equalTo(shadowView)
            make.size.equalTo(52)
        }
        emojiView.layer.cornerRadius = 26
        emojiView.layer.borderWidth = 1
        emojiView.layer.borderColor = UIColor.systemGray5.cgColor
        
        contentView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.center.equalTo(emojiView)
        }
        emojiLabel.font = UIFont.systemFont(ofSize: 28)
        
        contentView.addSubview(locationTypeLabel)
        locationTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(emojiView.snp.bottom).offset(6)
            make.centerX.equalTo(shadowView)
        }
        locationTypeLabel.textColor = .primary
        locationTypeLabel.font = UIFont.systemFont(ofSize: 16)
        
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(locationTypeLabel.snp.bottom).offset(2)
            make.centerX.equalTo(shadowView)
        }
        countLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        countLabel.textColor = .primary
    }

}
