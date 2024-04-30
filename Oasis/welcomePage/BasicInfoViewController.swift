//
//  BasicInfoViewController.swift
//  Oasis
//
//  Created by joanna on 2024/4/29.
//

import UIKit
import Photos
import AVFoundation

class BasicInfoViewController: UIViewController {
    
    private let imageButton = UIButton()
    private let changeImageButton = UIButton()
    private let nameLabel = UILabel()
    private let nameLabelDetail = UILabel()
    private let nameTextField = UITextField()
    private let finishButton = UIButton()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // 添加點擊手勢
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true) // 收起所有正在編輯的元素的鍵盤
    }
    
    @objc func finishAction() {
        // 儲存UserDefaults
        if let userImageData = imageButton.imageView?.image?.pngData() {
            UserDefaults.standard.set(userImageData, forKey: "userImageData")
        }
        UserDefaults.standard.set(nameTextField.text, forKey: "userName")
        
        // present tabBarController
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: false)
    }
    
    @objc func setProfileImage() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 照片圖庫
        let photoLibraryAction = UIAlertAction(title: "照片圖庫", style: .default) { [weak self] _ in
            guard let self else { return }
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized, .limited:
                self.presentPhotoLibrary()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        self.presentPhotoLibrary()
                    }
                }
            case .denied, .restricted:
                self.presentPhotoLibraryAlert()
            @unknown default:
                break
            }
        }
        
        // 相機
        let cameraAction = UIAlertAction(title: "相機", style: .default) { [weak self] _ in
            guard let self else { return }
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self.presentCamera()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { [weak self] success in
                    guard let self else { return }
                    guard success == true else { return }
                    self.presentCamera()
                }
            case .denied, .restricted:
                self.presentCameraAlert()
            @unknown default:
                break
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func presentCamera() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let controller = UIImagePickerController()
            controller.sourceType = .camera
            controller.delegate = self
            self.present(controller, animated: true)
        }
    }

    func presentCameraAlert() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alertController = UIAlertController (title: "未開啟相機權限", message: "請前往設定以允許訪問相機", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "設定", style: .default) { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {                         UIApplication.shared.open(settingsUrl)
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func presentPhotoLibrary() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let controller = UIImagePickerController()
            controller.sourceType = .photoLibrary
            controller.delegate = self
            self.present(controller, animated: true)
        }
    }

    func presentPhotoLibraryAlert() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alertController = UIAlertController (title: "照片圖庫無取用權限", message: "請前往設定以允許訪問照片圖庫", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "設定", style: .default) { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

extension BasicInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickImage = info[.originalImage] as? UIImage
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.setImage(pickImage, for: .normal)
        dismiss(animated: true)
    }
}

extension BasicInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 當用戶按下 return 鍵時，結束編輯狀態
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 獲取當前文本長度
        guard let text = textField.text else { return true }
        let currentLength = text.count + string.count - range.length
        let maxLength = 15 // 最大字符數
        // 檢查是否超過最大字符數
        if currentLength > maxLength {
            return false // 返回 false 表示不允許輸入更多字符
        }
        return true // 允許輸入更多字符
    }
}

extension BasicInfoViewController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNameView()
        configureImage()
        configureChangeImageButton()
        configureFinishButton()
    }
    
    private func configureNameView() {
        view.addSubview(nameLabel)
        nameLabel.text = "你的名稱"
        nameLabel.textColor = .primary
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.left.equalToSuperview().inset(24)
        }
        
        view.addSubview(nameLabelDetail)
        nameLabelDetail.text = "(最多可輸入15個字)"
        nameLabelDetail.textColor = .primary
        nameLabelDetail.font = UIFont.systemFont(ofSize: 15)
        nameLabelDetail.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(4)
        }
        
        view.addSubview(nameTextField)
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
    
    private func configureImage() {
        view.addSubview(imageButton)
        imageButton.setImage(UIImage(named: "avatar"), for: .normal)
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.layer.cornerRadius = 80
        imageButton.clipsToBounds = true
        imageButton.titleLabel?.font = UIFont.systemFont(ofSize: 80)
        imageButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nameLabel.snp.top).offset(-70)
            make.size.equalTo(160)
        }
        imageButton.addTarget(self, action: #selector(setProfileImage), for: .touchUpInside)
    }
    
    private func configureChangeImageButton() {
        view.addSubview(changeImageButton)
        changeImageButton.setTitle("更換照片", for: .normal)
        changeImageButton.setTitleColor(.tintColor, for: .normal)
        changeImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        changeImageButton.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        changeImageButton.addTarget(self, action: #selector(setProfileImage), for: .touchUpInside)
    }
    
    private func configureFinishButton() {
        view.addSubview(finishButton)
        finishButton.setTitle("完成", for: .normal)
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        finishButton.backgroundColor = .primary
        finishButton.layer.cornerRadius = 30
        
        finishButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.greaterThanOrEqualTo(nameTextField.snp.bottom).offset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.width.equalToSuperview().inset(60)
            make.height.equalTo(60)
        }
        finishButton.addTarget(self, action: #selector(finishAction), for: .touchUpInside)
    }
}
