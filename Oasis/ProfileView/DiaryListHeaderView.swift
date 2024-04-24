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
    enum ButtonType {
        case diary
        case favorite
    }
    
    static let headerIdentifier = "DiaryListHeaderView"
    weak var delegate: ChangeListContentDelegate?
    var viewModel: DiaryListHeaderViewModel!
    
    //MARK: Properities
    private let stackView = UIStackView()
    let diaryButton = UIButton()
    let favoriteButton = UIButton()
    private let underline = UIView()
    private let underlineBackground = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureListStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureListStackView() {
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
        diaryButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        favoriteButton.setTitle("收藏", for: .normal)
        favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
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
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }
    
    private func setButtonUnderlineConstraint(button: UIButton) {
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
    
    @objc private func buttonTapped(_ sender: UIButton){
        viewModel.buttonTapped(type: sender == diaryButton ? .diary : .favorite)
        delegate?.changeListContent()
    }
    
}

extension DiaryListHeaderView: DiaryListHeaderModelDelegate {
    func buttonDidTapped(type: DiaryListHeaderView.ButtonType) {
        switch type {
        case .diary:
            diaryButton.isSelected = true
            favoriteButton.isSelected = false
            setButtonUnderlineConstraint(button: diaryButton)
        case .favorite:
            diaryButton.isSelected = false
            favoriteButton.isSelected = true
            setButtonUnderlineConstraint(button: favoriteButton)
        }
    }
}
    
protocol DiaryListHeaderModelDelegate: AnyObject {
    func buttonDidTapped(type: DiaryListHeaderView.ButtonType)
}
    
class DiaryListHeaderViewModel {
    
    weak var collectionViewSectionDelegate: DiaryListHeaderModelDelegate?
    weak var stickyHeaderViewDelegate: DiaryListHeaderModelDelegate?
    
    func buttonTapped(type: DiaryListHeaderView.ButtonType) {
        collectionViewSectionDelegate?.buttonDidTapped(type: type)
        stickyHeaderViewDelegate?.buttonDidTapped(type: type)
    }
}
