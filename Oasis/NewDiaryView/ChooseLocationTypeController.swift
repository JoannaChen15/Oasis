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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @objc func cancelAction() {
        dismiss(animated: true)
    }
    
    @objc func selectLocationType(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}

extension ChooseLocationTypeController {
    private func configure() {
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
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        stackView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(24 + 56)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.lessThanOrEqualToSuperview().inset(24)
        }
    }
    
    private func configureButton() {
        for (index, locationType) in LocationType.allCases.enumerated() {
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
            //設置按鈕背景圖片
            button.imageView?.contentMode = .scaleAspectFill
            button.setBackgroundImage(UIImage(named: locationType.rawValue), for: .normal)
            // 添加黑色半透明的覆蓋層
            let overlayView = UIView()
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            button.addSubview(overlayView)
            overlayView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            overlayView.isUserInteractionEnabled = false
            // 設置覆蓋層的顯示優先級，使其位於按鈕的底部
            button.sendSubviewToBack(overlayView)
            // 設置按鈕圓角
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            // 添加按鈕到stackView
            stackView.addArrangedSubview(button)
            button.tag = index
            button.addTarget(self, action: #selector(selectLocationType(_:)), for: .touchUpInside)
        }
    }
}
