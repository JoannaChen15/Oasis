//
//  DiaryListHeaderView.swift
//  Oasis
//
//  Created by joanna on 2024/4/9.
//

import UIKit
import SnapKit

protocol ChangeListContentDelegate: AnyObject {
    func changeListContent()
}

class DiaryListHeaderView: UICollectionReusableView {
    
    static let headerIdentifier = "DiaryListHeaderView"
    weak var delegate: ChangeListContentDelegate?
    
    //MARK: Properities
    private let stackView = UIStackView()
    private let diaryButton = DiaryListHeaderButton()
    private let favoriteButton = DiaryListHeaderButton()
    private let underline = UIView()
    private let underlineBackground = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureListStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureListStackView() {
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.width.equalToSuperview()
        }
        stackView.backgroundColor = .systemBackground

        stackView.addArrangedSubview(diaryButton)
        stackView.addArrangedSubview(favoriteButton)
        diaryButton.setTitle("日記", for: .normal)
        favoriteButton.setTitle("收藏", for: .normal)
        diaryButton.setTitleColor(.systemGray4, for: .normal)
        favoriteButton.setTitleColor(.systemGray4, for: .normal)
        diaryButton.setTitleColor(.primary, for: .selected)
        favoriteButton.setTitleColor(.primary, for: .selected)
        diaryButton.isSelected = true

        addSubview(underlineBackground)
        underlineBackground.backgroundColor = .systemGray4
        underlineBackground.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(0.5)
        }

        addSubview(underline)
        underline.backgroundColor = .primary
        underline.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.bottom)
            make.width.equalTo(diaryButton.snp.width)
            make.centerX.equalTo(diaryButton)
            make.height.equalTo(1)
        }

        let buttons = stackView.subviews
        for (index, button) in buttons.enumerated() {
            let button = button as! UIButton
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    func setButtonUnderlineConstraint(button: UIButton) {
        underline.snp.remakeConstraints { make in
            make.bottom.equalTo(stackView.snp.bottom)
            make.width.equalTo(diaryButton.snp.width)
            make.centerX.equalTo(button)
            make.height.equalTo(1)
        }
        UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.layoutIfNeeded()
        }.startAnimation()
    }
    
    @objc func buttonTapped(_ sender: UIButton){
        setButtonUnderlineConstraint(button: sender)
        // 設置按鈕 isSelected 屬性
        for case let button as UIButton in stackView.arrangedSubviews {
            button.isSelected = (button == sender)
        }
        delegate?.changeListContent()
    }
    
}
