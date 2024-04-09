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
    private let timeLabel = UILabel()
    private let contentLabel = UILabel()
    private let timeLine = UIView()
    
//    var cellData : DiaryListModel? {
//        didSet {
//            guard let diaryData = cellData else { return }
//            locationNameLabel.text = diaryData.locationName
//            coverImageView.image = UIImage(named: diaryData.coverImage)
//            contentLabel.text = diaryData.content
//        }
//    }
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.size.equalTo(80)
        }
        coverImageView.layer.cornerRadius = 20
        coverImageView.backgroundColor = .systemGray6
        
        contentView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.center.equalTo(coverImageView)
        }
        emojiLabel.font = UIFont.systemFont(ofSize: 40)
        
        contentView.addSubview(timeLine)
        timeLine.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(10)
            make.centerX.equalTo(coverImageView)
            make.width.equalTo(1)
            make.bottom.equalToSuperview()
        }
        timeLine.backgroundColor = .systemGray5
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView)
            make.left.equalTo(coverImageView.snp.right).offset(10)
        }
        timeLabel.textColor = .systemGray
        timeLabel.font = UIFont.systemFont(ofSize: 15)
        
        contentView.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(6)
            make.left.equalTo(timeLabel.snp.left)
        }
        locationNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        locationNameLabel.textColor = .primary
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(locationNameLabel.snp.bottom).offset(10)
            make.left.equalTo(timeLabel.snp.left)
            make.right.equalToSuperview().inset(16)
        }
        contentLabel.textColor = .primary
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.numberOfLines = 2
        
        //test
        timeLabel.text = "2024年4月8日 週一"
        locationNameLabel.text = "粉鳥林秘境"
        contentLabel.text = "我的日記內容，我的日記內容我的日記內容我的日記內容我的日記內容diaryContentdiaryContentdiaryContentdiaryContentdiaryCont我的日記內容ContentdiaryContentdiaryContentdiaryContentdiaryContentdiaryContentdiaryContentdiaryContentdiaryContentdiaryContentdiaryContentdiaryContentdiaryContentdiaryContentdiaryContentdiaryContentdiaryContentdiaryContentdiaryContent"
        emojiLabel.text = "🏕️"
        
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
    
}
