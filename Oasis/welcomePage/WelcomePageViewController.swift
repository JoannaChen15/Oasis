//
//  WelcomePageViewController.swift
//  Oasis
//
//  Created by joanna on 2024/4/28.
//

import UIKit

class WelcomePageViewController: UIViewController {
    
    private let logoImageView = UIImageView()
    private let mainLabel = UILabel()
    private let detailLabel = UILabel()
    private let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @objc func start() {
        let basicInfoViewController = BasicInfoViewController()
        navigationController?.pushViewController(basicInfoViewController, animated: true)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureMainLabel()
        configureLogoImageView()
        configureDetailLabel()
        configureStartButton()
    }
    
    private func configureMainLabel() {
        view.addSubview(mainLabel)
        mainLabel.text = "台北探秘日記"
        mainLabel.textColor = .primary
        mainLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        mainLabel.textAlignment = .center
        mainLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(26)
        }
    }
    
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(60)
            make.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide).inset(50)
            make.bottom.equalTo(mainLabel.snp.top).offset(-50)
        }
    }
    
    private func configureDetailLabel() {
        view.addSubview(detailLabel)
        detailLabel.text = "探索城市中的綠洲，透過地點打卡寫日記"
        detailLabel.textColor = .primary
        detailLabel.textAlignment = .center
        detailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainLabel.snp.bottom).offset(10)
        }
    }
    
    private func configureStartButton() {
        view.addSubview(startButton)
        startButton.setTitle("開始使用", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        startButton.backgroundColor = .primary
        startButton.layer.cornerRadius = 30
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.greaterThanOrEqualTo(detailLabel.snp.bottom).offset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.width.equalToSuperview().inset(60)
            make.height.equalTo(60)
        }
        startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
    }
    
}
