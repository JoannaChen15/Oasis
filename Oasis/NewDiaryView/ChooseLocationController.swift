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
    private let searchBar = UISearchBar()
    private let locationTableView = UITableView()
    
    var selectedLocationType: LocationType!
    
    let locations = MapViewModel.shared.locations
    
    var selectedTypeOfLocations = [LocationModel]() {
        didSet {
            locationTableView.reloadData()
        }
    }
    var filteredLocations = [LocationModel]()
    
    var didSelectCellHandler: ((String) -> Void)? // 接收資料的閉包
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getSelectedTypeOfLocation()
        filteredLocations = selectedTypeOfLocations
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
    
    func search(_ searchTerm: String) {
        if searchTerm.isEmpty {
            filteredLocations = selectedTypeOfLocations
        } else {
            filteredLocations = selectedTypeOfLocations.filter {
                $0.name.contains(searchTerm)
            }
        }
        locationTableView.reloadData()
    }
    
}

extension ChooseLocationController {
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureSearchBar()
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
    
    private func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.left.equalTo(8)
        }
        searchBar.tintColor = .primary
        searchBar.searchTextField.textColor = .primary
        // 消除上下的線
        UISearchBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.placeholder = "搜尋"
        searchBar.delegate = self
    }
    
    private func configureTableView() {
        view.addSubview(locationTableView)
        locationTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        locationTableView.delegate = self
        locationTableView.dataSource = self
        locationTableView.register(ChooseLocationCell.self, forCellReuseIdentifier: ChooseLocationCell.cellIdentifier)
    }
}

extension ChooseLocationController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueReusableCell(withIdentifier: ChooseLocationCell.cellIdentifier, for: indexPath) as! ChooseLocationCell
        let location = filteredLocations[indexPath.row]
        cell.setupWith(location: location)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationName = filteredLocations[indexPath.row].name
        // 調用閉包並傳遞按鈕資料
        didSelectCellHandler?(locationName)
        dismiss(animated: true)
    }
}

extension ChooseLocationController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text ?? ""
        search(searchTerm)
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
            self.searchBar.layoutIfNeeded()
        }.startAnimation()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchTerm = searchText
        search(searchTerm)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        search("")
    }
}
