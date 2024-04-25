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
    
    var cellModel: LocationModel?
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(favoriteLocationModel: LocationModel) {
        cellModel = favoriteLocationModel
        locationTypeView.setTitle("\(favoriteLocationModel.type.emoji) \(favoriteLocationModel.type.displayName)", for: .normal)
        locationNameLabel.text = "\(favoriteLocationModel.name)"
        favoriteButton.status = favoriteLocationModel.favoriteStatus
    }

    @objc func tapFavoriteButton() {
        // 儲存此筆cell的location
        guard let favoriteLocationModel = cellModel else { return }
        delegate?.didTapFavoriteButton(location: favoriteLocationModel)
    }
    
    @objc func tapNewDiaryButton() {
        guard let favoriteLocationModel = cellModel else { return }
        delegate?.didTapNewDiaryButton(location: favoriteLocationModel)
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
        locationTypeView.clipsToBounds = true
        locationTypeView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalTo(favoriteButton.snp.right).offset(16)
            make.width.equalTo(68)
            make.height.equalTo(28)
        }
    }
        
    private func configureLocationNameLabel() {
        contentView.addSubview(locationNameLabel)
        locationNameLabel.textColor = .primary
        locationNameLabel.font = UIFont.systemFont(ofSize: 16)
        locationNameLabel.numberOfLines = 2
        locationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(locationTypeView.snp.bottom).offset(6)
            make.left.equalTo(locationTypeView).inset(4)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func configureNewDiaryButton() {
        contentView.addSubview(newDiaryButton)
        newDiaryButton.setTitle("新增日記", for: .normal)
        newDiaryButton.setTitleColor(.white, for: .normal)
        newDiaryButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        newDiaryButton.backgroundColor = .systemCyan
        newDiaryButton.layer.cornerRadius = 10
        newDiaryButton.addTarget(self, action: #selector(tapNewDiaryButton), for: .touchUpInside)
        newDiaryButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(88)
            make.height.equalTo(32)
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
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}
