//
//  ProfileViewController.swift
//  Oasis
//
//  Created by joanna on 2024/4/1.
//

import UIKit
import SnapKit
import CoreData


class ProfileViewController: UIViewController {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var diaryListHeaderView = DiaryListHeaderView()
    var headerViewModel = DiaryListHeaderViewModel()
    
    let mapViewModel = MapViewModel.shared
    var locations: [LocationModel] {
        mapViewModel.locations
    }
    var favoriteLocationModels = [LocationModel]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var diaryModels = [Diary]()
    private var locationTypeCellModels = [LocationTypeCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapViewModel.getAllFavoriteLocations()
        favoriteLocationModels = mapViewModel.favoriteLocationModels
        getAllDiaries()
    }
    
    @objc func settings() {
        let setupController = ProfileSetupViewController()
        navigationController?.pushViewController(setupController, animated: true)
    }
    
    func generateLocationTypeCellModels(diarys: [Diary]) -> [LocationTypeCellModel] {
        // 計算類別數量
        var locationTypeCounts = [String: Int]()
        for diary in diarys {
            guard let locationType = diary.locationType else { continue }
            if let count = locationTypeCounts[locationType] {
                locationTypeCounts[locationType] = count + 1
            } else {
                locationTypeCounts[locationType] = 1
            }
        }
        
        // 產生models
        var locationTypeCellModels = [LocationTypeCellModel(type: nil, count: diaryModels.count)]
        for (type, count) in locationTypeCounts {
            locationTypeCellModels.append(LocationTypeCellModel(type: LocationType(rawValue: type), count: count))
        }
        return locationTypeCellModels
    }
    
    // Core Data
    
    func getAllDiaries() {
        // 依日期從新到舊排序
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        // 創建請求
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            diaryModels = try context.fetch(fetchRequest)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.locationTypeCellModels = self.generateLocationTypeCellModels(diarys: self.diaryModels)
                self.collectionView.reloadData()
            }
        } catch {
            // error
        }
    }

}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return 1
        case 1 :
            return locationTypeCellModels.count
        default :
            if self.diaryListHeaderView.diaryButton.isSelected {
                return diaryModels.count
            } else {
                return favoriteLocationModels.count
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoCell.cellIdentifier, for: indexPath) as? UserInfoCell else {fatalError("Unable deque cell...")}
            cell.setupWithUserDefaults()
            cell.delegate = self
            return cell
        case 1 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationTypeCell.cellIdentifier, for: indexPath) as? LocationTypeCell else {fatalError("Unable deque cell...")}
            let locationTypeCellModel = locationTypeCellModels[indexPath.row]
            cell.setupWith(locationTypeCellModel: locationTypeCellModel)
            return cell
        default :
            if self.diaryListHeaderView.diaryButton.isSelected {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryListCollectionViewCell.cellIdentifier, for: indexPath) as? DiaryListCollectionViewCell else { fatalError("Unable deque cell...") }
                let diaryModel = diaryModels[indexPath.row]
                cell.setupWith(diaryModel: diaryModel)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteLocationCell.cellIdentifier, for: indexPath) as? FavoriteLocationCell else { fatalError("Unable deque cell...") }
                let favoriteLocationModel = favoriteLocationModels[indexPath.row]
                cell.setupWith(favoriteLocationModel: favoriteLocationModel)
                cell.delegate = self
                return cell
            }
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
        if abs(offestY) > 248 {
            diaryListHeaderView.isHidden = false
        } else {
            diaryListHeaderView.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            if self.diaryListHeaderView.diaryButton.isSelected {
                let diaryDetailController = DiaryDetailController()
                let diaryModel = diaryModels[indexPath.row]
                diaryDetailController.setupWith(diaryModel: diaryModel)
                navigationController?.pushViewController(diaryDetailController, animated: true)
            } else {
                return
            }
        default:
            break
        }
    }

}

extension ProfileViewController: UserInfoCellDelegate {
    func editProfile() {
        let setupController = ProfileSetupViewController()
        navigationController?.pushViewController(setupController, animated: true)
    }
}

extension ProfileViewController: FavoriteLocationCellDelegate {
    func didTapNewDiaryButton(location: LocationModel) {
        let newDiaryViewController = NewDiaryViewController()
        newDiaryViewController.favoriteLocation = location
        newDiaryViewController.doneButtonDelegate = self
        let newDiaryViewNavigation = UINavigationController(rootViewController: newDiaryViewController)
        newDiaryViewNavigation.modalPresentationStyle = .fullScreen
        present(newDiaryViewNavigation, animated: true, completion: nil)
    }
    
    func didTapFavoriteButton(location: LocationModel) {
        // 按下按鈕後找到按的是第幾筆Location
        guard let index = locations.firstIndex(of: location) else { return }
        // 改變Location的最愛狀態
        locations[index].favoriteStatus = .unselected
        
        // 刪除CoreData資料
        mapViewModel.deleteFavoriteLocation(location: location)
        mapViewModel.getAllFavoriteLocations()
        favoriteLocationModels = mapViewModel.favoriteLocationModels

        // 通知collectionView重畫
        collectionView.reloadData()
    }
}

extension ProfileViewController: ChangeListContentDelegate {
    func changeListContent() {
        collectionView.reloadData()
    }
}

extension ProfileViewController {
    private func configureUI() {
        configureNavigation()
        configureCollectionView()
        configureCompositionalLayout()
        configureDiaryListHeaderView()
    }
    
    private func configureNavigation() {
        // 設置標題文本的字體和重量
        let titleFont = UIFont.systemFont(ofSize: 17, weight: .regular) // 設置標題字體大小和粗細
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.primary
        ]
        // 配置導航欄的標準外觀
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = titleTextAttributes
        navBarAppearance.backgroundColor = .systemBackground
        navBarAppearance.shadowColor = .clear
        
        // 設置導航欄的標準外觀和滾動到邊緣時的外觀
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.title = "個人檔案"
        // 添加右側按鈕
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain,  target: self, action: #selector(settings))
        navigationItem.rightBarButtonItem = settingButton
    }
        
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserInfoCell.self, forCellWithReuseIdentifier: UserInfoCell.cellIdentifier)
        collectionView.register(LocationTypeCell.self, forCellWithReuseIdentifier: LocationTypeCell.cellIdentifier)
        collectionView.register(DiaryListHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: DiaryListHeaderView.headerIdentifier)
        collectionView.register(DiaryListCollectionViewCell.self, forCellWithReuseIdentifier: DiaryListCollectionViewCell.cellIdentifier)
        collectionView.register(FavoriteLocationCell.self, forCellWithReuseIdentifier: FavoriteLocationCell.cellIdentifier)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureCompositionalLayout(){
        let layout = UICollectionViewCompositionalLayout {sectionIndex,enviroment in
            switch sectionIndex {
            case 0 :
                return AppLayouts.shared.userInfoSection()
            case 1 :
                return AppLayouts.shared.locationTypeSection()
            default :
                if self.diaryListHeaderView.diaryButton.isSelected {
                    return AppLayouts.shared.diaryListSection()
                } else {
                    return AppLayouts.shared.favoriteLocationSection()
                }
            }
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func configureDiaryListHeaderView() {
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
}

extension ProfileViewController: DiaryListDelegate {
    func updateDiaryList() {
        getAllDiaries()
    }
}

extension ProfileViewController: DiaryCompletionDelegate {
    func goToDiaryList() {
        diaryListHeaderView.viewModel.buttonTapped(type: .diary)
    }
}
