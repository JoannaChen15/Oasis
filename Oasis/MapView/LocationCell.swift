//
//  LocationCell.swift
//  Oasis
//
//  Created by joanna on 2024/4/1.
//

import UIKit

protocol LocationCellDelegate: AnyObject {
    func didTapFavoriteButton(location: LocationModel)
}

class LocationCell: UICollectionViewCell {
    
    private let shadowView = UIView()
    private let locationNameLabel = UILabel()
    private let mainStackView = UIStackView()
    private let favoriteButton = FavoriteButton()
        
    private let temperatureImage = UIImage(systemName: "thermometer.medium")
    private let temperatureLabel = UILabel()
    private let humidityImage = UIImage(systemName: "humidity.fill")
    private let humidityLabel = UILabel()
    private let cloudsImage = UIImage(systemName: "smoke")
    private let cloudsLabel = UILabel()
    private let windSpeedImage = UIImage(systemName: "wind")
    private let windSpeedLabel = UILabel()
    
    private var location: LocationModel?
    weak var delegate: LocationCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 在這裡重置 cell 的狀態或清除之前設置的任何資料，以便重用
        temperatureLabel.text = ""
        humidityLabel.text = ""
        cloudsLabel.text = ""
        windSpeedLabel.text = ""
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
        favoriteButton.addTarget(self, action: #selector(tapFavoriteButton), for: .touchUpInside)
        
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
        createIconLabelStackView(image: humidityImage!, label: humidityLabel)
        createIconLabelStackView(image: cloudsImage!, label: cloudsLabel)
        createIconLabelStackView(image: windSpeedImage!, label: windSpeedLabel)
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
    
    func setupWith(locationModel: LocationModel) {
        location = locationModel
        locationNameLabel.text = locationModel.name
        favoriteButton.status = locationModel.favoriteStatus
        
        guard let weatherData = locationModel.weatherData else { return }
        temperatureLabel.text = "\(((weatherData.main.temp) - 273.15).rounded(toDecimals: 1))°C"
        humidityLabel.text = "\(weatherData.main.humidity) %"
        cloudsLabel.text = "\(weatherData.clouds.all) %"
        windSpeedLabel.text = "\(weatherData.wind.speed) m/s"
    }

    @objc func tapFavoriteButton() {
        // 儲存此筆cell的location
        guard let location = self.location else { return }
        // 呼叫delegate執行按下按鈕要做的事
        delegate?.didTapFavoriteButton(location: location)
    }
    
}

// 計算溫度用
extension Double {
    // 四捨五入到個位數
    func rounded(toDecimals decimals: Int) -> Double {
        let multiplier = pow(10, Double(decimals))
        return (self * multiplier).rounded() / multiplier
    }
}
