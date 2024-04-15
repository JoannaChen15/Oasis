//
//  ChooseLocationController.swift
//  Oasis
//
//  Created by joanna on 2024/4/13.
//

import UIKit
import SnapKit

class ChooseLocationController: UIViewController {
    
    private let navigationBar = UINavigationBar()
    private let locationTableView = UITableView()
    
    var selectedLocationType: LocationType!
    
    let locations = MapViewModel.shared.locations
    
    var selectedTypeOfLocations = [LocationModel]() {
        didSet {
            locationTableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getSelectedTypeOfLocation()
    }
    
    @objc func cancelAction() {
        dismiss(animated: true)
    }
    
    func getSelectedTypeOfLocation() {
        selectedTypeOfLocations = []
        for location in locations {
            if location.type == selectedLocationType {
                selectedTypeOfLocations.append(location)
            }
        }
    }
}

extension ChooseLocationController {
    private func configure() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.isTranslucent = false
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        // 設置導航欄的標題
        let navigationItem = UINavigationItem(title: "選擇地點")
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
    
    private func configureTableView() {
        view.addSubview(locationTableView)
        locationTableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        locationTableView.delegate = self
        locationTableView.dataSource = self
        locationTableView.register(ChooseLocationCell.self, forCellReuseIdentifier: ChooseLocationCell.cellIdentifier)
    }
}

extension ChooseLocationController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTypeOfLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueReusableCell(withIdentifier: ChooseLocationCell.cellIdentifier, for: indexPath) as! ChooseLocationCell
        let location = selectedTypeOfLocations[indexPath.row]
        cell.setupWith(location: location)
        return cell

    }
}
