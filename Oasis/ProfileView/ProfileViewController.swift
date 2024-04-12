//
//  ProfileViewController.swift
//  Oasis
//
//  Created by joanna on 2024/4/1.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var diaryListHeaderView = DiaryListHeaderView()
    var headerViewModel = DiaryListHeaderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureCollectionView()
        configureCompositionalLayout()
        configureDiaryListHeaderView()
    }
    
    func configureNavigation() {
        // 設置標題文本的字體和重量
        let titleFont = UIFont.systemFont(ofSize: 17, weight: .regular) // 設置標題字體大小和粗細
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.primary
        ]
        // 配置導航欄的標準外觀
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = titleTextAttributes
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemGray]
        navBarAppearance.backgroundColor = .systemBackground
        navBarAppearance.shadowColor = .clear
        
        // 設置導航欄的標準外觀和滾動到邊緣時的外觀
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.title = "個人檔案"
        // 添加右側按鈕
        let settingButton = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(settings))
        navigationItem.rightBarButtonItem = settingButton
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserInfoCell.self, forCellWithReuseIdentifier: UserInfoCell.cellIdentifier)
        collectionView.register(DiaryListHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: DiaryListHeaderView.headerIdentifier)
        collectionView.register(DiaryListCollectionViewCell.self, forCellWithReuseIdentifier: DiaryListCollectionViewCell.cellIdentifier)
        collectionView.register(LocationTypeCell.self, forCellWithReuseIdentifier: LocationTypeCell.cellIdentifier)
        
//        collectionView.register(ListViewCell.self, forCellWithReuseIdentifier: ListViewCell.cellIdentifier)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureDiaryListHeaderView() {
        view.addSubview(diaryListHeaderView)
        diaryListHeaderView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        diaryListHeaderView.delegate = self
        diaryListHeaderView.isHidden = true
        diaryListHeaderView.viewModel = headerViewModel
        headerViewModel.stickyHeaderViewDelegate = diaryListHeaderView
    }
    
    @objc func settings() {
        
    }
    
}

extension ProfileViewController {

    func configureCompositionalLayout(){
        let layout = UICollectionViewCompositionalLayout {sectionIndex,enviroment in
            switch sectionIndex {
            case 0 :
                return AppLayouts.shared.userInfoSection()
            case 1 :
                return AppLayouts.shared.locationTypeSection()
            default :
                return AppLayouts.shared.diaryListSection()
//            default:
//                return AppLayouts.shared.listViewSection()
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
            return 1
        case 1 :
            return 5
        default :
            return 2
//        default:
//            return 2
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoCell.cellIdentifier, for: indexPath) as? UserInfoCell else {fatalError("Unable deque cell...")}
            return cell
        case 1 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationTypeCell.cellIdentifier, for: indexPath) as? LocationTypeCell else {fatalError("Unable deque cell...")}
            return cell
        default :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryListCollectionViewCell.cellIdentifier, for: indexPath) as? DiaryListCollectionViewCell else { fatalError("Unable deque cell...") }
            return cell
//        default:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListViewCell.cellIdentifier, for: indexPath) as? ListViewCell else { fatalError("Unable deque cell...") }
//            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == "Header" {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DiaryListHeaderView.headerIdentifier, for: indexPath) as! DiaryListHeaderView
            header.delegate = self
            header.viewModel = headerViewModel
            headerViewModel.collectionViewSectionDelegate = header
            return header
        } else {
            fatalError("Unexpected supplementary element kind")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offestY = scrollView.contentOffset.y
        if abs(offestY) > 282 {
            diaryListHeaderView.isHidden = false
        } else {
            diaryListHeaderView.isHidden = true
        }
    }
    
}

extension ProfileViewController: ChangeListContentDelegate {
    func changeListContent() {
        
    }
}
