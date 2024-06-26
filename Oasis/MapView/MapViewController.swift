//
//  MapViewController.swift
//  Oasis
//
//  Created by joanna on 2024/4/1.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation

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
        configureUI()
        mapViewModel.delegate = self
        mapViewModel.fetchLandmarksForTypes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerBottomOffset = 140
        containerTop = locationContainerView.center
        containerBottom = CGPoint(x: locationContainerView.center.x ,y: locationContainerView.center.y + containerBottomOffset)
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
        guard let firstAnnotation = mapView.annotations.first(where: { $0 is MKPointAnnotation }) else { return }
        if hasSelectFirstAnnotation { return }
        // 選取第一個地標
        mapView.selectAnnotation(firstAnnotation, animated: true)
        // 以地標點為中心，設置初始地圖範圍
        mapView.setRegion(MKCoordinateRegion(center: firstAnnotation.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000), animated: true)
        hasSelectFirstAnnotation = true
    }
    
    func mapView(_: MKMapView, didSelect view: MKAnnotationView) {
        // 取消選取使用者位置
        if view.annotation is MKUserLocation {
            mapView.deselectAnnotation(view.annotation, animated: false)
        }
        
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
    func didTapFavoriteButton(location: LocationModel) {
        // 震動反饋
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        
        // 按下按鈕後找到按的是第幾筆Location
        guard let index = locations.firstIndex(of: location) else { return }
        // 改變Location的最愛狀態
        switch locations[index].favoriteStatus {
        case .unselected:
            locations[index].favoriteStatus = .selected
            // 新增CoreData資料
            mapViewModel.createFavoriteLocation(name: location.name, type: location.type.rawValue)
        case .selected:
            locations[index].favoriteStatus = .unselected
            // 刪除CoreData資料
            mapViewModel.deleteFavoriteLocation(location: location)
        }
        mapViewModel.getAllFavoriteLocations()
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

extension MapViewController {
    private func configureUI() {
        configureMapView()
        configureLocationContainerView()
        configureLocationCollectionView()
    }
    
    private func configureMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        mapView.delegate = self
        
        // 取得定位權限
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
    }
    
    private func configureLocationContainerView() {
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
    
    private func configureLocationCollectionView() {
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
}
