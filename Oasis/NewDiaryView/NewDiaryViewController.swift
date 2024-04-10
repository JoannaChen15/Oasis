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

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {

    }


    deinit {
        // Unsubscribe from keyboard notifications
        NotificationCenter.default.removeObserver(self)
    }
}

private extension NewDiaryViewController {
    func configure() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.backgroundColor = .systemGray5
        scrollView.alwaysBounceVertical = true

        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.edges.equalTo(scrollView.contentLayoutGuide)
        }

        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = constant

        containerView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(24)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.left.equalTo(constant)
        }

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

    func configTypeButton() {
        typeButton.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
            make.width.equalToSuperview()
        }
        typeButton.mainLabel.text = "類型"
        typeButton.detailLabel.text = "選擇"
    }

    func configLocationButton() {
        locationButton.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
            make.width.equalToSuperview()
        }
        locationButton.mainLabel.text = "地點"
        locationButton.detailLabel.text = "選擇"
    }

    func configTimeButton() {
        timeButton.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
            make.width.equalToSuperview()
        }
        timeButton.mainLabel.text = "時間"
        timeButton.detailLabel.text = "選擇"
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
