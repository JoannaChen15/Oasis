//
//  ChooseLocationTypeController.swift
//  Oasis
//
//  Created by joanna on 2024/4/12.
//

import UIKit
import SnapKit

class ChooseLocationTypeController: UIViewController {
    
    private let navigationBar = UINavigationBar()
    private let stackView = UIStackView()
    private let campgroundButton = UIButton()
    private let beachButton = UIButton()
    private let hikingButton = UIButton()
    
    var buttonHandler: ((Int, String) -> Void)? // 接收按鈕資料的閉包
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @objc func cancelAction() {
        dismiss(animated: true)
    }
    
    @objc func selectLocationType(_ sender: UIButton) {
        if let locationType = sender.titleLabel?.text {
            // 調用閉包並傳遞按鈕資料
            buttonHandler?(sender.tag, locationType)
        }
        dismiss(animated: true)
    }
    
}

extension ChooseLocationTypeController {
    private func configure() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureStackView()
        configureButton()
    }
    
    private func configureNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.isTranslucent = false
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        // 設置導航欄的標題
        let navigationItem = UINavigationItem(title: "選擇地點類型")
        // 設置導航欄的標題文本屬性
        let titleFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.primary // 設置文字顏色
        ]
        navigationBar.titleTextAttributes = titleTextAttributes
        // 添加按鈕
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.leftBarButtonItem = cancelButton
        navigationBar.setItems([navigationItem], animated: false)
        navigationBar.backgroundColor = .systemBackground
    }
    
    private func configureStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        stackView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.left.equalTo(24)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    private func configureButton() {
        for (index, locationType) in LocationType.allCases.enumerated() {
            //設置容器
            let containerView = UIView()
            // 添加容器到stackView
            stackView.addArrangedSubview(containerView)
            //設置圖片
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: locationType.rawValue)
            imageView.layer.cornerRadius = 10
            imageView.layer.masksToBounds = true
            // 添加圖片到容器
            containerView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            // 添加黑色半透明的覆蓋層
            let overlayView = UIView()
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            containerView.addSubview(overlayView)
            overlayView.layer.cornerRadius = 10
            overlayView.layer.masksToBounds = true
            overlayView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            //設置按鈕
            let button = UIButton()
            //設置按鈕文字
            switch locationType {
            case .campground:
                button.setTitle("營地", for: .normal)
            case .beach:
                button.setTitle("海灘", for: .normal)
            case .hiking:
                button.setTitle("步道", for: .normal)
            }
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
            //設置按鈕功能
            button.tag = index
            button.addTarget(self, action: #selector(selectLocationType(_:)), for: .touchUpInside)
            // 添加按鈕到容器
            containerView.addSubview(button)
            button.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}
