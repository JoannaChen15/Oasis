//
//  MapViewController.swift
//  Oasis
//
//  Created by joanna on 2024/4/1.
//

import UIKit
import SnapKit
import MapKit

class MapViewController: UIViewController {

    private let mapView = MKMapView()
    
    private let locationContainerView = UIView()
    private var containerOriginalCenter = CGPoint.zero
    private var containerBottomOffset = CGFloat()
    private var containerTop = CGPoint.zero
    private var containerBottom = CGPoint.zero
    
    private let locationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private var annotations = [MKPointAnnotation]()
    private var hasSelectFirstAnnotation = false
    
    private let networkManager = NetworkManager()
    
    let mapViewModel = MapViewModel.shared
    
    var locations: [LocationModel] {
        mapViewModel.locations
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        fetchLandmarksForTypes()
        configureLocationContainerView()
        configureLocationCollectionView()
        mapViewModel.delegate = self
        mapViewModel.fetchLandmarksForTypes()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerBottomOffset = 140
        containerTop = locationContainerView.center
        containerBottom = CGPoint(x: locationContainerView.center.x ,y: locationContainerView.center.y + containerBottomOffset)
    }
    
    func setupMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        mapView.delegate = self
//        mapView.showsUserLocation = true
    }
    
    private func fetchLandmarks(for type: LocationType, in region: MKCoordinateRegion, completion: @escaping (_ locations: [LocationModel]) -> Void) {
        
        var locations = [LocationModel]()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = type.rawValue // 搜尋的地標類型
        request.region = region // 搜尋的區域
        
        // 設置感興趣的地點類別
        let naturalPointOfInterests: [MKPointOfInterestCategory] = [.beach, .campground, .marina, .nationalPark, .park]
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: naturalPointOfInterests)
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("搜尋失敗: \(error)")
                }
                return
            }
            
            // 處理搜尋結果
            for item in response.mapItems {
                let location = LocationModel(name: item.name ?? "未知", latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude, favoriteStatus: FavoriteButtonStatus.unselected)
                locations.append(location)
            }
            completion(locations)
        }
    }
    
    func createAnnotation(locations: [LocationModel]) {
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotation.title = location.name
            mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
    }
    
    func fetchLandmarksForTypes() {
        locations = []
        let taipeiRegion = MKCoordinateRegion(center: taipeiCenter, latitudinalMeters: 5000, longitudinalMeters: 5000)
        for type in LocationType.allCases {
            fetchLandmarks(for: type, in: taipeiRegion) { locations in
                self.createAnnotation(locations: locations)
                self.locations += locations
            }
        }
    }
    
    func configureLocationContainerView() {
        view.addSubview(locationContainerView)
        locationContainerView.layer.cornerRadius = 20
        locationContainerView.backgroundColor = .systemBackground
        locationContainerView.snp.makeConstraints { make in
            make.height.equalTo(220)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        let handleView = UIView()
        let handleTriggerView = UIView()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        
        locationContainerView.addSubview(handleTriggerView)
        handleTriggerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        handleTriggerView.addGestureRecognizer(panGesture)
        
        handleTriggerView.addSubview(handleView)
        handleView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.height.equalTo(5)
            make.width.equalTo(48)
        }
        handleView.backgroundColor = .systemGray5
        handleView.layer.cornerRadius = 2.5
    }
    
    func configureLocationCollectionView() {
        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
        locationCollectionView.register(LocationCell.self, forCellWithReuseIdentifier: "LocationCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        locationCollectionView.collectionViewLayout = layout
        
        
        locationContainerView.addSubview(locationCollectionView)
        locationCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(44)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        locationCollectionView.backgroundColor = .clear
        locationCollectionView.isPagingEnabled = true
        locationCollectionView.showsHorizontalScrollIndicator = false
    }

    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began:
            containerOriginalCenter = locationContainerView.center
        case .changed:
            let cappedTranslationY = max(-3, min(100, translation.y))
            locationContainerView.center.y = containerOriginalCenter.y + cappedTranslationY
        case .ended:
            let velocity = sender.velocity(in: view).y
            let targetCenter = velocity > 0 ? containerBottom : containerTop
            UIView.animate(withDuration: 0.25) {
                self.locationContainerView.center = targetCenter
            }
        default:
            break
        }
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        guard let firstAnnotation = mapView.annotations.first else { return }
        if hasSelectFirstAnnotation { return }
        // 選取第一個地標
        mapView.selectAnnotation(firstAnnotation, animated: true)
        // 以地標點為中心，設置初始地圖範圍
        mapView.setRegion(MKCoordinateRegion(center: firstAnnotation.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000), animated: true)
        hasSelectFirstAnnotation = true
    }
    
    func mapView(_: MKMapView, didSelect view: MKAnnotationView) {
        // 選取地標點切換顯示的LocationCell
        guard let annotation = view.annotation else { return }
        guard let index = locations.firstIndex(where: { $0.name == annotation.title }) else { return }
        let indexPath = IndexPath(item: index, section: 0)
        locationCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        // 抓取天氣資料
        let location = locations[index]
        location.fetchWeatherData { weatherData in
            // 設置天氣資料
            location.weatherData = weatherData
            self.locationCollectionView.reloadItems(at: [indexPath])
        }
    }
}

extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = locationCollectionView.dequeueReusableCell(withReuseIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let location = locations[indexPath.row]
        cell.setupWith(locationModel: location)
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 結束滾動後取得當前 cell 的 indexPath
        guard let visibleIndexPath = locationCollectionView.indexPathsForVisibleItems.first else { return }
        // 取得相對應的地標
        let annotation = annotations[visibleIndexPath.item]
        // 選取地標
        mapView.selectAnnotation(annotation, animated: true)
        // 以地標點為中心，重新設置地圖範圍
        mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000), animated: true)
    }
    
}

extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = locationCollectionView.frame.width
        let height = locationCollectionView.frame.height
        return CGSize(width: width, height: height)
    }
}

extension MapViewController: LocationCellDelegate {
    
    func didTabFavoriteButton(location: LocationModel) {
        // 按下按鈕後找到按的是第幾筆Location
        guard let index = locations.firstIndex(of: location) else { return }
        // 改變Location的最愛狀態
        switch locations[index].favoriteStatus {
        case .unselected:
            locations[index].favoriteStatus = .selected
        case .selected:
            locations[index].favoriteStatus = .unselected
        }
        // 通知collectionView重畫
        locationCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
   
}

extension MapViewController: MapViewModelDelegate {
    func reloadData() {
        locationCollectionView.reloadData()
    }
    
    func createAnnotation(locations: [LocationModel]) {
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotation.title = location.name
            mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
    }
}
