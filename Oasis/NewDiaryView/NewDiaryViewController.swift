//
//  NewDiaryViewController.swift
//  Oasis
//
//  Created by joanna on 2024/4/1.
//

import UIKit
import SnapKit

class NewDiaryViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let stackView = UIStackView()

    private let typeButton = SelectionButton()
    private let locationButton = SelectionButton()
    private let timeButton = SelectionButton()
    private let photoLabel = UILabel()
    private let photoButton = UIButton()
    private let contentLabel = UILabel()
    private let contentView = UIView()
    private let contentTextField = UITextField()

    private let constant: CGFloat = 24
    private let buttonHeight: CGFloat = 56
    private var isFirstPresent = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // 添加點擊手勢
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        // 訂閱鍵盤彈出和隱藏的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstPresent {
            isFirstPresent = false
            addDashedBorder()
        }
    }

    @objc func hideKeyboard() {
        view.endEditing(true) // 收起所有正在編輯的元素的鍵盤
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // 獲取鍵盤的高度
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        // 設置 scrollView 的內容偏移量，使文本字段在鍵盤上方可見
        scrollView.contentInset.bottom = keyboardSize.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // 隱藏鍵盤時重置 scrollView 的內容偏移量
        scrollView.contentInset = .zero
    }

    @objc func doneAction() {

    }
    
    @objc func cancelAction() {
        dismiss(animated: true)
    }
    
    @objc func chooseLocationType() {
        let chooseController = ChooseLocationTypeController()
//        if let sheetPresentationController = chooseController.sheetPresentationController {
//            sheetPresentationController.detents = [.large()]
//        }
        present(chooseController, animated: true)
    }
    
    @objc func chooseLocation() {
        
    }
    
    @objc func chooseTime() {
        
    }
    
    @objc func choosePhoto() {
        
    }

    deinit {
        // Unsubscribe from keyboard notifications
        NotificationCenter.default.removeObserver(self)
    }
}

private extension NewDiaryViewController {
    func configure() {
        view.backgroundColor = .systemGray6
        configureNavigation()
        configScrollView()
        configContainerView()
        configStackView()

        stackView.addArrangedSubview(typeButton)
        configTypeButton()

        stackView.addArrangedSubview(locationButton)
        configLocationButton()

        stackView.addArrangedSubview(timeButton)
        configTimeButton()

        stackView.addArrangedSubview(photoLabel)
        configPhotoLabel()

        stackView.addArrangedSubview(photoButton)
        configPhotoButton()

        stackView.addArrangedSubview(contentLabel)
        configContentLabel()

        stackView.addArrangedSubview(contentView)
        configContentView()
    }
    
    func configureNavigation() {
        // 設置標題文本的字體和重量
        let titleFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.primary
        ]
        // 配置導航欄的標準外觀
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = titleTextAttributes
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemGray]
        navBarAppearance.backgroundColor = .systemBackground

        // 設置導航欄的標準外觀和滾動到邊緣時的外觀
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.title = "新增日記"
        // 添加按鈕
        let doneButton = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItem = doneButton
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func configScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.backgroundColor = .systemGray6
        scrollView.alwaysBounceVertical = true
    }

    func configContainerView() {
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.edges.equalTo(scrollView.contentLayoutGuide)
        }
    }
    
    func configStackView() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = constant
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(24)
            $0.bottom.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(constant)
        }
    }
    
    func configTypeButton() {
        typeButton.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
            make.width.equalToSuperview()
        }
        typeButton.mainLabel.text = "類型"
        typeButton.detailLabel.text = "選擇"
        typeButton.addTarget(self, action: #selector(chooseLocationType), for: .touchUpInside)
    }

    func configLocationButton() {
        locationButton.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
            make.width.equalToSuperview()
        }
        locationButton.mainLabel.text = "地點"
        locationButton.detailLabel.text = "選擇"
        locationButton.addTarget(self, action: #selector(chooseLocation), for: .touchUpInside)
    }

    func configTimeButton() {
        timeButton.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
            make.width.equalToSuperview()
        }
        timeButton.mainLabel.text = "時間"
        timeButton.detailLabel.text = "選擇"
        timeButton.addTarget(self, action: #selector(chooseTime), for: .touchUpInside)
    }

    func configPhotoLabel() {
        photoLabel.text = "選擇照片"
        photoLabel.textColor = .primary
        photoLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        photoLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
    }

    func configPhotoButton() {
        photoButton.snp.makeConstraints { make in
            make.size.equalTo(100)
        }
        photoButton.backgroundColor = .systemBackground
        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "photo", withConfiguration: configuration)
        photoButton.setImage(image, for: .normal)
        photoButton.tintColor = .systemGray2
        photoButton.layer.cornerRadius = 8
        photoButton.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)
    }

    func configContentLabel() {
        contentLabel.text = "日記內容"
        contentLabel.textColor = .primary
        contentLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        contentLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
    }

    func configContentView() {
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(200)
            make.bottom.equalToSuperview()
        }
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8

        contentView.addSubview(contentTextField)
        contentTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        contentTextField.contentVerticalAlignment = .top
        contentTextField.contentHorizontalAlignment = .left
        contentTextField.placeholder = "寫下這次感受大自然的心情吧. 🌱"
        contentTextField.delegate = self
    }
}

extension NewDiaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
}

extension NewDiaryViewController {
    func addDashedBorder() {
        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = UIColor.systemGray.cgColor
        dashedBorder.lineDashPattern = [8, 2] // 设置虚线的间隔
        dashedBorder.frame = photoButton.bounds
        dashedBorder.fillColor = nil
        dashedBorder.path = UIBezierPath(roundedRect: photoButton.bounds, cornerRadius: 8).cgPath
        photoButton.layer.addSublayer(dashedBorder)
    }
}

extension NewDiaryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 當用戶按下 return 鍵時，結束編輯狀態
        textField.resignFirstResponder()
        return true
    }
}
