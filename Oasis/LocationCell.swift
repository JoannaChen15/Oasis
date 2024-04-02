//
//  LocationCell.swift
//  Oasis
//
//  Created by joanna on 2024/4/1.
//

import UIKit

class LocationCell: UICollectionViewCell {
    
    private let shadowView = UIView()
    private let locationNameLabel = UILabel()
    private let mainStackView = UIStackView()
    private let favoriteButton = FavoriteButton()
        
    private let temperatureImage = UIImage(systemName: "thermometer.medium")
    private let temperatureLabel = UILabel()
    private let uvIndexImage = UIImage(systemName: "sun.max.trianglebadge.exclamationmark")
    private let uvIndexLabel = UILabel()
    private let probabilityOfPrecipitationImage = UIImage(systemName: "cloud.drizzle")
    private let probabilityOfPrecipitationLabel = UILabel()
    private let windSpeedImage = UIImage(systemName: "wind")
    private let windSpeedLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        // 添加陰影視圖
        contentView.addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(52)
            make.top.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(32)
        }
        shadowView.backgroundColor = .systemBackground
        shadowView.layer.cornerRadius = 20
        shadowView.layer.shadowColor = UIColor.systemGray4.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 4
        
        // 地點名稱
        shadowView.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        locationNameLabel.font = UIFont.systemFont(ofSize: 18)
        
        // 收藏按鈕
        shadowView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalTo(locationNameLabel.snp.centerY)
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
        favoriteButton.tintColor = .systemGray
        
        // 天氣狀況 mainStackView
        shadowView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(locationNameLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.distribution = .fillEqually
        
        // 創建 iconLabelStackView
        createIconLabelStackView(image: temperatureImage!, label: temperatureLabel)
        createIconLabelStackView(image: uvIndexImage!, label: uvIndexLabel)
        createIconLabelStackView(image: probabilityOfPrecipitationImage!, label: probabilityOfPrecipitationLabel)
        createIconLabelStackView(image: windSpeedImage!, label: windSpeedLabel)
        
        // test
        temperatureLabel.text = "23.5°C"
        uvIndexLabel.text = "23.5C"
        probabilityOfPrecipitationLabel.text = "25%"
        windSpeedLabel.text = "1.10 m/s"
    }
    
    func createIconLabelStackView(image: UIImage, label: UILabel) {
        let iconLabelStackView = UIStackView()
        iconLabelStackView.axis = .vertical
        iconLabelStackView.alignment = .center
        iconLabelStackView.spacing = 6
        iconLabelStackView.distribution = .equalSpacing
        
        // icon
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.size.equalTo(28)
        }
        iconLabelStackView.addArrangedSubview(imageView)
        
        // label
        iconLabelStackView.addArrangedSubview(label)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemGray
        
        // 添加到 mainStackView 中
        mainStackView.addArrangedSubview(iconLabelStackView)
    }
    
    func setupWith(location: Location) {
        locationNameLabel.text = location.name
    }

}
