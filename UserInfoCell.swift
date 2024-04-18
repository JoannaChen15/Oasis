//
//  UserInfoCell.swift
//  Oasis
//
//  Created by joanna on 2024/4/9.
//

import UIKit
import SnapKit

protocol UserInfoCellDelegate: AnyObject {
    func editProfile()
}

class UserInfoCell: UICollectionViewCell {
    
    static let cellIdentifier = "UserInfoCell"
    //MARK: Prop
    private let stackView = UIStackView()
    private let userView = UIView()
    private let userNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let userImageView = UIButton()
    
    weak var delegate: UserInfoCellDelegate?
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
        //test
        userNameLabel.text = "Joanna"
        descriptionLabel.text = "設定你的日記描述"
        userImageView.setTitle("J", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func editProfile() {
        delegate?.editProfile()
    }
    
    func configureUI(){
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(userView)
        
        userView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        userNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        userNameLabel.textColor = .primary
        
        userView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .primary
        
        stackView.addArrangedSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        userImageView.backgroundColor = .tintColor
        userImageView.layer.cornerRadius = 30
        userImageView.clipsToBounds = true
        userImageView.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        userImageView.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
    }
    
}
