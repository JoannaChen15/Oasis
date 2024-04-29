//
//  DiaryListCollectionViewCell.swift
//  Oasis
//
//  Created by joanna on 2024/4/4.
//

import UIKit
import SnapKit

class DiaryListCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "DiaryListCollectionViewCell"
    //MARK: Prop
    private let coverImageView = UIImageView()
    private let emojiLabel = UILabel()
    private let locationNameLabel = UILabel()
    private let dateLabel = UILabel()
    private let contentLabel = UILabel()
    private let timeLine = UIView()
    private let underLine = UIView()
        
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(diaryModel: Diary) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let dateString = dateFormatter.string(from: diaryModel.date ?? Date())
        dateLabel.text = dateString
        locationNameLabel.text = diaryModel.locationName
        emojiLabel.text = LocationType(rawValue: diaryModel.locationType!)?.emoji
        coverImageView.image = UIImage(data: diaryModel.photo ?? Data())
        contentLabel.text = diaryModel.content
    }

}

extension DiaryListCollectionViewCell {
    private func configureUI(){
        configureCoverImageView()
        configureEmojiLabel()
        configureTimeLine()
        configureDateLabel()
        configureLocationNameLabel()
        configureContentLabel()
        configureUnderLine()
    }
    
    private func configureCoverImageView(){
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.size.equalTo(68)
        }
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.cornerRadius = 20
        coverImageView.clipsToBounds = true
        coverImageView.backgroundColor = .systemGray5
        
        // 添加白色半透明的覆蓋層
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        coverImageView.addSubview(overlayView)
        overlayView.layer.cornerRadius = 20
        overlayView.layer.masksToBounds = true
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureEmojiLabel() {
        contentView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.center.equalTo(coverImageView)
        }
        emojiLabel.font = UIFont.systemFont(ofSize: 28)
    }
    
    private func configureTimeLine() {
        contentView.addSubview(timeLine)
        timeLine.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(8)
            make.centerX.equalTo(coverImageView)
            make.width.equalTo(1)
            make.bottom.equalToSuperview()
        }
        timeLine.backgroundColor = .systemGray5
    }
    
    private func configureDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView).inset(8)
            make.left.equalTo(coverImageView.snp.right).offset(10)
        }
        dateLabel.textColor = .systemGray
        dateLabel.font = UIFont.systemFont(ofSize: 15)
    }

    private func configureLocationNameLabel() {
        contentView.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(6)
            make.left.equalTo(dateLabel.snp.left)
            make.right.equalToSuperview().inset(16)
        }
        locationNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        locationNameLabel.textColor = .primary
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(24)
            make.left.equalTo(dateLabel.snp.left)
            make.right.equalToSuperview().inset(16)
        }
        contentLabel.textColor = .primary
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.lineBreakMode = .byTruncatingTail // 末尾截斷，並顯示省略號
        // 創建屬性字串
        let attributedString = NSMutableAttributedString(string: contentLabel.text ?? "")
        // 設置段落樣式，包括上下間距
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6 // 上下間距
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        // 將屬性字串設置給UILabel
        contentLabel.attributedText = attributedString
        
        contentView.addSubview(underLine)
        underLine.backgroundColor = .systemGray6
        underLine.snp.makeConstraints { make in
            make.left.equalTo(dateLabel)
            make.bottom.equalToSuperview().inset(4)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
    }

    private func configureContentLabel() {
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(24)
            make.left.equalTo(dateLabel.snp.left)
            make.right.equalToSuperview().inset(16)
        }
        contentLabel.textColor = .primary
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.lineBreakMode = .byTruncatingTail // 末尾截斷，並顯示省略號
        // 創建屬性字串
        let attributedString = NSMutableAttributedString(string: contentLabel.text ?? "")
        // 設置段落樣式，包括上下間距
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6 // 上下間距
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        // 將屬性字串設置給UILabel
        contentLabel.attributedText = attributedString
    }

    private func configureUnderLine() {
        contentView.addSubview(underLine)
        underLine.backgroundColor = .systemGray6
        underLine.snp.makeConstraints { make in
            make.left.equalTo(dateLabel)
            make.bottom.equalToSuperview().inset(4)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
    }
}
