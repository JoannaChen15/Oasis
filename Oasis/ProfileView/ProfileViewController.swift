//
//  ProfileViewController.swift
//  Oasis
//
//  Created by joanna on 2024/4/1.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureCollectionView()
        configureCompositionalLayout()

    }
    
    func configureNavigation() {
        navigationItem.title = "個人檔案"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        // 添加右側按鈕
        let settingButton = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(settings))
        navigationItem.rightBarButtonItem = settingButton
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DiaryListCollectionViewCell.self, forCellWithReuseIdentifier: DiaryListCollectionViewCell.cellIdentifier)
        collectionView.register(LocationTypeCell.self, forCellWithReuseIdentifier: LocationTypeCell.cellIdentifier)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func settings() {
        
    }
    
}

extension ProfileViewController {

    func configureCompositionalLayout(){
        let layout = UICollectionViewCompositionalLayout {sectionIndex,enviroment in
            switch sectionIndex {
            case 0 :
                return AppLayouts.shared.locationTypeSection()
            default:
                return AppLayouts.shared.diaryListSection()
            }
        }
        //    layout.register(SectionDecorationView.self, forDecorationViewOfKind: "SectionBackground")
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return 5
        default:
            return 5
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationTypeCell.cellIdentifier, for: indexPath) as? LocationTypeCell else {fatalError("Unable deque cell...")}
            return cell

        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryListCollectionViewCell.cellIdentifier, for: indexPath) as? DiaryListCollectionViewCell else { fatalError("Unable deque cell...") }
            return cell
        }
        
    }
    
}
