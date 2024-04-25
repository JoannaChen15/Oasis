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
    private let deleteImageButton = UIButton()
    private let nameLabel = UILabel()
    private let nameLabelDetail = UILabel()
    private let nameTextField = UITextField()
    private let descriptionLabel = UILabel()
    private let descriptionLabelDetail = UILabel()
    private let descriptionTextField = UITextField()
    
    private var textFieldBottom: CGFloat = 0
    
    private var imageData: Data?
    private var userName: String?
    private var diaryDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupWithUserDefaults()
        // 添加點擊手勢
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        // 訂閱鍵盤彈出和隱藏的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        if let userImageData = imageButton.imageView?.image?.pngData() {
            UserDefaults.standard.set(userImageData, forKey: "userImageData")
        } else {
            UserDefaults.standard.set(nil, forKey: "userImageData")
        }
        UserDefaults.standard.set(nameTextField.text, forKey: "userName")
        UserDefaults.standard.set(descriptionTextField.text, forKey: "diaryDescription")
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func backButtonTapped() {
        guard imageData == nil, userName == nil, diaryDescription == nil else {
            let controller = UIAlertController(title: "放棄更改內容？", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel)
            controller.addAction(cancelAction)
            let confirmAction = UIAlertAction(title: "放棄", style: .destructive) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            controller.addAction(confirmAction)
            present(controller, animated: true)
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func setProfileImage() {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: true)
    }
    
    @objc func deleteProfileImage() {
        let controller = UIAlertController(title: "確定移除照片？", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        controller.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "移除", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.imageButton.setImage(UIImage(), for: .normal)
            self.imageButton.imageView?.image = nil
            self.imageData = Data()
            self.deleteImageButton.isHidden = true
        }
        controller.addAction(confirmAction)
        present(controller, animated: true)
    }
    
    private func setupWithUserDefaults() {
        // 使用者名稱
        let userName = UserDefaults.standard.string(forKey: "userName")
        nameTextField.text = userName
        
        // 日記描述
        let diaryDescription = UserDefaults.standard.string(forKey: "diaryDescription")
        descriptionTextField.text = diaryDescription
        
        // 頭像文字
        if let firstChar = userName?.first {
            let firstCharString = String(firstChar)
            imageButton.setTitle("\(firstCharString)", for: .normal)
        }
        
        // 頭像圖片
        if let userImageData = UserDefaults.standard.data(forKey: "userImageData") {
            let userImage = UIImage(data: userImageData)
            imageButton.setImage(userImage, for: .normal)
            deleteImageButton.isHidden = false
        } else {
            deleteImageButton.isHidden = true
        }
    }
    
    deinit {
        // Unsubscribe from keyboard notifications
        NotificationCenter.default.removeObserver(self)
    }
}

extension ProfileSetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickImage = info[.originalImage] as? UIImage
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.setImage(pickImage, for: .normal)
        imageData = imageButton.imageView?.image?.pngData()
        deleteImageButton.isHidden = false
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
        // 開始編輯時紀錄原始文字
        userName = nameTextField.text
        diaryDescription = descriptionTextField.text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 結束編輯時比較文字是否變化
        if nameTextField.text != userName {
            userName = ""
        } else {
            userName = nil
        }
        
        if descriptionTextField.text != diaryDescription {
            diaryDescription = ""
        } else {
            diaryDescription = nil
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 獲取當前文本長度
        guard let text = textField.text else { return true }
        let currentLength = text.count + string.count - range.length
        var maxLength = 15 // 最大字符數
        if textField === descriptionTextField {
            maxLength = 18
        }
        // 檢查是否超過最大字符數
        if currentLength > maxLength {
            return false // 返回 false 表示不允許輸入更多字符
        }
        return true // 允許輸入更多字符
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
        // 自定義返回按鈕
        let backButtonImage = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(title: "個人檔案", image: backButtonImage, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
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
        
        scrollView.addSubview(deleteImageButton)
        deleteImageButton.backgroundColor = .systemGray6
        deleteImageButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteImageButton.tintColor = .primary
        deleteImageButton.layer.cornerRadius = 20
        deleteImageButton.snp.makeConstraints { make in
            make.top.equalTo(imageButton)
            make.right.equalTo(imageButton)
            make.size.equalTo(40)
        }
        deleteImageButton.addTarget(self, action: #selector(deleteProfileImage), for: .touchUpInside)
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
        
        scrollView.addSubview(nameLabelDetail)
        nameLabelDetail.text = "(最多可輸入15個字)"
        nameLabelDetail.textColor = .primary
        nameLabelDetail.font = UIFont.systemFont(ofSize: 15)
        nameLabelDetail.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(4)
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
        
        scrollView.addSubview(descriptionLabelDetail)
        descriptionLabelDetail.text = "(最多可輸入18個字)"
        descriptionLabelDetail.textColor = .primary
        descriptionLabelDetail.font = UIFont.systemFont(ofSize: 15)
        descriptionLabelDetail.snp.makeConstraints { make in
            make.centerY.equalTo(descriptionLabel)
            make.left.equalTo(descriptionLabel.snp.right).offset(4)
        }
        
        scrollView.addSubview(descriptionTextField)
        descriptionTextField.backgroundColor = .systemGray6
        descriptionTextField.textColor = .primary
        descriptionTextField.font = UIFont.systemFont(ofSize: 18)
        descriptionTextField.layer.cornerRadius = 8
        descriptionTextField.clipsToBounds = true
        descriptionTextField.placeholder = "例：寫下感受大自然的心情吧 🌱"
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
