//
//  ListViewCell.swift
//  Oasis
//
//  Created by joanna on 2024/4/9.
//

//import UIKit
//
//class ListViewCell: UICollectionViewCell {
//    
//    //MARK: Properities
//    
//    static let cellIdentifier = "ListViewCell"
//    
//    private let tableView = UITableView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureUI()
//    }
//    
//    func configureUI(){
//
//        contentView.addSubview(tableView)
//        
//        tableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(DiaryListTableViewCell.self, forCellReuseIdentifier: DiaryListTableViewCell.cellIdentifier)
//        
//        tableView.showsVerticalScrollIndicator = false
//        tableView.backgroundColor = .tintColor
//
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
//
//extension ListViewCell: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryListTableViewCell", for: indexPath) as! DiaryListTableViewCell
//        return cell
//        
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150 // 返回固定高度
//    }
//    
//    
//}
