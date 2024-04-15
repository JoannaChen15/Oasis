//
//  ChooseDateController.swift
//  Oasis
//
//  Created by joanna on 2024/4/15.
//

import UIKit

class ChooseDateController: UIViewController {
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    let datePicker = UIDatePicker()
    
    var selectedDate: Date?
    
    var buttonHandler: ((Date) -> Void)? // 接收按鈕資料的閉包
         
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitleAndButton()
        configureDatePicker()
    }
    
    private func changeCloseButton() {
        closeButton.backgroundColor = .tintColor
        closeButton.tintColor = .tintColor
        closeButton.setImage(UIImage(), for: .normal)
        closeButton.titleLabel?.textColor = .systemBackground
        closeButton.setTitle("儲存", for: .normal)
        closeButton.snp.remakeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.equalTo(36)
            make.width.equalTo(72)
        }
        closeButton.removeTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(confirmDate), for: .touchUpInside)
        // 添加動畫效果
        UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
            self.view.layoutIfNeeded()
        }.startAnimation()
    }
    
    // 日期選擇器值變化事件的監聽器
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        changeCloseButton()
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
    
    @objc func confirmDate() {
        if let selectedDate {
            buttonHandler?(selectedDate)
            dismiss(animated: true)
        }
    }
}

extension ChooseDateController {
    private func configureTitleAndButton() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        titleLabel.text = "選擇日期"
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        titleLabel.textColor = .primary
        
        view.addSubview(closeButton)
        closeButton.backgroundColor = .systemGray6
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .systemGray
        closeButton.layer.cornerRadius = 18
        closeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.size.equalTo(36)
        }
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    private func configureDatePicker() {
        view.backgroundColor = .systemBackground
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.locale = Locale(identifier: "zh_TW")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
}
