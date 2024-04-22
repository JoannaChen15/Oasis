//
//  FavoriteLocationCell.swift
//  Oasis
//
//  Created by joanna on 2024/4/18.
//

import UIKit
import SnapKit

protocol FavoriteLocationCellDelegate: AnyObject {
    func didTapFavoriteButton(location: LocationModel)
    func didTapNewDiaryButton(location: LocationModel)
}

class FavoriteLocationCell: UICollectionViewCell {
    
    static let cellIdentifier = "FavoriteLocationCell"
    //MARK: Prop
    private let favoriteButton = FavoriteButton()
    private let locationTypeView = UIButton()
    private let locationNameLabel = UILabel()
    private let newDiaryButton = UIButton()
    private let underLine = UIView()
    
    weak var delegate: FavoriteLocationCellDelegate?
    
    var favoriteLocation: LocationModel?
//    {
//        didSet {
//            guard let favoriteLocation else { return }
//            locationTypeView.setTitle("\(favoriteLocation.type.emoji) \(favoriteLocation.type.displayName)", for: .normal)
//            locationNameLabel.text = "\(favoriteLocation.name)"
//            favoriteButton.status = favoriteLocation.favoriteStatus
//        }
//    }
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
        //test
        locationTypeView.setTitle("🏕️ 營地", for: .normal)
        locationNameLabel.text = "皇后鎮森林金山"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(favoriteLocationModel: LocationModel) {
        favoriteLocation = favoriteLocationModel
        locationTypeView.setTitle("\(favoriteLocationModel.type.emoji) \(favoriteLocationModel.type.displayName)", for: .normal)
        locationNameLabel.text = "\(favoriteLocationModel.name)"
        favoriteButton.status = favoriteLocationModel.favoriteStatus
    }
    
    @objc func tapFavoriteButton() {
        // 儲存此筆cell的location
        guard let favoriteLocation = self.favoriteLocation else { return }
        // 呼叫delegate執行按下按鈕要做的事
        delegate?.didTapFavoriteButton(location: favoriteLocation)
    }
    
    @objc func tapNewDiaryButton() {
        guard let favoriteLocation = self.favoriteLocation else { return }
        delegate?.didTapNewDiaryButton(location: favoriteLocation)
    }
    
}

extension FavoriteLocationCell {
    private func configureUI() {
        configureFavoriteButton()
        configureLocationTypeButton()
        configureLocationNameLabel()
        configureNewDiaryButton()
        configureUnderLine()
    }
    
    private func configureFavoriteButton() {
        contentView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
        favoriteButton.addTarget(self, action: #selector(tapFavoriteButton), for: .touchUpInside)
    }
    
    private func configureLocationTypeButton() {
        contentView.addSubview(locationTypeView)
        locationTypeView.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        locationTypeView.setTitleColor(.primary, for: .normal)
        locationTypeView.backgroundColor = .systemGray6
        locationTypeView.layer.cornerRadius = 10
        locationNameLabel.clipsToBounds = true
        locationTypeView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-12)
            make.left.equalTo(favoriteButton.snp.right).offset(16)
            make.width.equalTo(68)
            make.height.equalTo(28)
        }
    }
        
    private func configureLocationNameLabel() {
        contentView.addSubview(locationNameLabel)
        locationNameLabel.textColor = .primary
        locationNameLabel.font = UIFont.systemFont(ofSize: 16)
        locationNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(16)
            make.left.equalTo(locationTypeView).inset(4)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureNewDiaryButton() {
        contentView.addSubview(newDiaryButton)
        newDiaryButton.setTitle("新增日記", for: .normal)
        newDiaryButton.setTitleColor(.white, for: .normal)
        newDiaryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        newDiaryButton.backgroundColor = .systemCyan
        newDiaryButton.layer.cornerRadius = 10
        newDiaryButton.addTarget(self, action: #selector(tapNewDiaryButton), for: .touchUpInside)
        newDiaryButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(92)
            make.height.equalTo(36)
        }
        locationNameLabel.snp.makeConstraints { make in
            make.right.lessThanOrEqualTo(newDiaryButton.snp.left).offset(-2)
        }
    }
    
    private func configureUnderLine() {
        contentView.addSubview(underLine)
        underLine.backgroundColor = .systemGray6
        underLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(8)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}
