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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    @objc func tapEditButton() {
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
        // test
        photoImageView.image = UIImage(named: "campground")
        dateLabel.text = "2024/4/17 在 "
        locationTypeButton.setTitle("🏕️ 營地", for: .normal)
        locationNameLabel.text = "華中露營地"
        contentLabel.text = "天氣很好。下次還要來：) 和自己談心：寫日記是一種和自我對話的方式，誠實面對自己的心情，釋放壓力與負能量。讓生活更有意義：讓生活不再過的慵懶，記錄每一天平凡卻重要的事情，幫助自己前往目標的軌道上，找到生活中有意義且快樂的事，獲得成就感。整理一天的思緒：除了與自己獨處，也能提高自我反省、釐清事物的能力，有助於日常的溝通和協調。養成寫日記的習慣，把每一天值得記錄的事情、心情、以及回憶寫下，不管是上班工作的大小事、週末旅行的點滴，還是每天吃飯運動的日常，零碎的小事日日累積，成為每一天記錄生活的儀式感！"
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
