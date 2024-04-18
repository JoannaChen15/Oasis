//
//  ProfileSetupViewController.swift
//  Oasis
//
//  Created by joanna on 2024/4/17.
//

import UIKit

class ProfileSetupViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let navigationBar = UINavigationBar()
    private let imageLabel = UILabel()
    private let imageButton = UIButton()
    private let nameLabel = UILabel()
    private let nameTextField = UITextField()
    private let descriptionLabel = UILabel()
    private let descriptionTextField = UITextField()
    
    private var textFieldBottom: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // 添加點擊手勢
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        // 訂閱鍵盤彈出和隱藏的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // test
        imageButton.setTitle("J", for: .normal)
        nameTextField.text = "Joanna"
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true) // 收起所有正在編輯的元素的鍵盤
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // 獲取鍵盤的高度
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        // 計算scrollView是否需滾動，使textField在鍵盤上方可見
        let keyboardTop = scrollView.frame.height - keyboardSize.height
        let distance = textFieldBottom - keyboardTop
        if distance > 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: distance + 16), animated: true)
        }
        // 設置 scrollView 的內容偏移量
        scrollView.contentInset.bottom = keyboardSize.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // 隱藏鍵盤時重置 scrollView 的內容偏移量
        scrollView.contentInset = .zero
    }
    
    @objc func saveAction() {
        
    }
    
    @objc func setProfileImage() {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: true)
    }
    
    deinit {
        // Unsubscribe from keyboard notifications
        NotificationCenter.default.removeObserver(self)
    }
}

extension ProfileSetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickImage = info[.originalImage] as? UIImage
        imageButton.setImage(pickImage, for: .normal)
        imageButton.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true)
    }
}

extension ProfileSetupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 當用戶按下 return 鍵時，結束編輯狀態
        textField.resignFirstResponder()
        return true
    }
    // 計算textField底部位置
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldBottom = textField.frame.maxY
    }
}

extension ProfileSetupViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureScrollView()
        configureImage()
        configureName()
        configureDescription()
    }
    
    private func configureNavigationBar() {
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

        navigationItem.title = "編輯"
        // 添加右側按鈕
        let saveButton = UIBarButtonItem(title: "儲存", style: .plain, target: self, action: #selector(saveAction))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.bottom.equalToSuperview()
        }
        scrollView.alwaysBounceVertical = true
    }
    
    private func configureImage() {
        scrollView.addSubview(imageLabel)
        imageLabel.text = "你的照片"
        imageLabel.textColor = .primary
        imageLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        imageLabel.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.left.equalToSuperview().inset(24)
        }
        
        scrollView.addSubview(imageButton)
        imageButton.backgroundColor = .tintColor
        imageButton.layer.cornerRadius = 80
        imageButton.clipsToBounds = true
        imageButton.titleLabel?.font = UIFont.systemFont(ofSize: 80)
        imageButton.snp.makeConstraints { make in
            make.top.equalTo(imageLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(160)
        }
        imageButton.addTarget(self, action: #selector(setProfileImage), for: .touchUpInside)
    }
    
    private func configureName() {
        scrollView.addSubview(nameLabel)
        nameLabel.text = "你的名稱"
        nameLabel.textColor = .primary
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(24)
            make.left.equalToSuperview().inset(24)
        }
        
        scrollView.addSubview(nameTextField)
        nameTextField.backgroundColor = .systemGray6
        nameTextField.textColor = .primary
        nameTextField.font = UIFont.systemFont(ofSize: 18)
        nameTextField.layer.cornerRadius = 8
        nameTextField.clipsToBounds = true
        // 創建左側視圖
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0)) // 左側間距為10
        nameTextField.leftView = leftView
        nameTextField.leftViewMode = .always
        // 創建右側視圖
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0)) // 右側間距為10
        nameTextField.rightView = rightView
        nameTextField.rightViewMode = .always
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.width.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        nameTextField.delegate = self
    }
    
    private func configureDescription() {
        scrollView.addSubview(descriptionLabel)
        descriptionLabel.text = "日記描述"
        descriptionLabel.textColor = .primary
        descriptionLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(24)
            make.left.equalToSuperview().inset(24)
        }
        
        scrollView.addSubview(descriptionTextField)
        descriptionTextField.backgroundColor = .systemGray6
        descriptionTextField.textColor = .primary
        descriptionTextField.font = UIFont.systemFont(ofSize: 18)
        descriptionTextField.layer.cornerRadius = 8
        descriptionTextField.clipsToBounds = true
        descriptionTextField.placeholder = "例：這是一本簡單的小日記"
        // 創建左側視圖
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0)) // 左側間距為10
        descriptionTextField.leftView = leftView
        descriptionTextField.leftViewMode = .always
        // 創建右側視圖
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0)) // 右側間距為10
        descriptionTextField.rightView = rightView
        descriptionTextField.rightViewMode = .always
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.width.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(scrollView.contentLayoutGuide).inset(24)
        }
        descriptionTextField.delegate = self
    }
}
