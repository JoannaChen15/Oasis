//
//  DiaryDetailController.swift
//  Oasis
//
//  Created by joanna on 2024/4/16.
//

import UIKit

class DiaryDetailController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let photoImageView = UIImageView()
    private let dateLabel = UILabel()
    private let locationTypeButton = UIButton()
    private let locationNameLabel = UILabel()
    private let contentLabel = UILabel()
    
    var diary: Diary!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    @objc func tapEditButton() {
    func setupWith(diaryModel: Diary) {
        diary = diaryModel
        updateUI(with: diary)
    }
    
    func updateUI(with diary: Diary) {
        // 設置照片
        if let photoData = diary.photo {
            self.photoData = photoData
            photoImageView.image = UIImage(data: photoData)
        }
        // 設置地點類型
        if let locationType = LocationType(rawValue: diary.locationType!) {
            locationTypeButton.setTitle("\(locationType.emoji) \(locationType.displayName)", for: .normal)
        }
        // 設置日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormatter.string(from: diary.date ?? Date())
        dateLabel.text = "\(dateString) 在 "
        // 設置地點
        locationNameLabel.text = diary.locationName
        // 設置日記內容
        contentLabel.text = diary.content
    }
    }
    
        let newDiaryViewController = NewDiaryViewController()
        let newDiaryViewNavigation = UINavigationController(rootViewController: newDiaryViewController)
        newDiaryViewNavigation.modalPresentationStyle = .fullScreen
        self.present(newDiaryViewNavigation, animated: true, completion: nil)
    // Core Data
    
    func deleteDiary(diary: Diary) {
        context.delete(diary)
        do {
            try context.save()
        } catch {
            // error
        }
    }
    
    }
}

extension DiaryDetailController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigation()
        configureScrollView()
        configurePhotoImageView()
        configureLocationTypeButton()
        configureDateLabel()
        configureLocationNameLabel()
        configureContentLabel()
    }
    
    private func configureNavigation() {
        // 設置標題文本的字體和重量
        let titleFont = UIFont.systemFont(ofSize: 17, weight: .regular) // 設置標題字體大小和粗細
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.primary
        ]
        // 配置導航欄的標準外觀
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = titleTextAttributes
        navBarAppearance.backgroundColor = .systemBackground
        navBarAppearance.shadowColor = .clear
        // 設置導航欄的標準外觀和滾動到邊緣時的外觀
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationItem.title = "日記"
        // 添加右側按鈕
        let editButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(tapEditButton))
        navigationItem.rightBarButtonItem = editButton
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.bottom.equalToSuperview()
        }
    }
    
    private func configurePhotoImageView() {
        scrollView.addSubview(photoImageView)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide)
            make.width.equalToSuperview()
            make.height.equalTo(photoImageView.snp.width).multipliedBy(0.9)
        }
    }
    
    private func configureLocationTypeButton() {
        scrollView.addSubview(locationTypeButton)
        locationTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        locationTypeButton.setTitleColor(.primary, for: .normal)
        locationTypeButton.backgroundColor = .systemGray6
        locationTypeButton.layer.cornerRadius = 10
        locationNameLabel.clipsToBounds = true
        locationTypeButton.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(76)
            make.height.equalTo(32)
        }
    }
    
    private func configureDateLabel() {
        scrollView.addSubview(dateLabel)
        dateLabel.textColor = .primary
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(locationTypeButton.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(16)
        }
    }
    
    private func configureLocationNameLabel() {
        scrollView.addSubview(locationNameLabel)
        locationNameLabel.textColor = .primary
        locationNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        locationNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.left.equalTo(dateLabel.snp.right)
        }
    }
    
    private func configureContentLabel() {
        scrollView.addSubview(contentLabel)
        contentLabel.textColor = .primary
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .justified
        
        // 設置行間距
        let attributedString = NSMutableAttributedString(string: contentLabel.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8 // 設置行間距為8個點
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        contentLabel.attributedText = attributedString
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(24)
            make.left.equalTo(scrollView.frameLayoutGuide).inset(16)
            make.right.equalTo(scrollView.frameLayoutGuide).inset(24)
            make.bottom.equalTo(scrollView.contentLayoutGuide).inset(24)
        }
    }
}
