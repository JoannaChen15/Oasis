//
//  MapViewModel.swift
//  Oasis
//
//  Created by joanna on 2024/4/14.
//

import Foundation
import MapKit

protocol MapViewModelDelegate: AnyObject {
    func reloadData()
    func createAnnotation(locations: [LocationModel])
}

class MapViewModel {
    static let shared = MapViewModel()
    
    weak var delegate: MapViewModelDelegate?
    
    private let taipeiCenter = CLLocationCoordinate2D(latitude: 25.0330, longitude: 121.5654)
    
    private(set) var locations = [LocationModel]() {
        didSet { delegate?.reloadData() }
    }
    
    private(set) var favoriteLocationModels = [LocationModel]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private(set) var favoriteLocationDatas = [FavoriteLocation]()
    
    
    func fetchLandmarksForTypes() {
        locations = []
        let taipeiRegion = MKCoordinateRegion(center: taipeiCenter, latitudinalMeters: 5000, longitudinalMeters: 5000)
        for type in LocationType.allCases {
            fetchLandmarks(for: type, in: taipeiRegion) { locations in
                self.delegate?.createAnnotation(locations: locations)
                self.locations += locations
            }
        }
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
                let location = LocationModel(name: item.name ?? "未知", latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude, type: type,  favoriteStatus: FavoriteButtonStatus.unselected)
                locations.append(location)
            }
            completion(locations)
        }
    }
    
    func generateFavoriteLocationsModels(with favoriteLocationDatas: [FavoriteLocation]) -> [LocationModel] {
        var favoriteLocationModels = [LocationModel]()
        for favoriteLocationData in favoriteLocationDatas {
            let location = locations.first { $0.name == favoriteLocationData.name }
            if let location {
                location.favoriteStatus = .selected
                favoriteLocationModels.append(location)
            }
        }
        return favoriteLocationModels
    }
    
    // Core Data
        
    func getAllFavoriteLocations() {
        do {
            favoriteLocationDatas = try context.fetch(FavoriteLocation.fetchRequest())
            // 產生models
            favoriteLocationModels = generateFavoriteLocationsModels(with: favoriteLocationDatas)
        } catch {
            // error
        }
    }
    
    func createFavoriteLocation(name: String, type: String) {
        let newFavoriteLocation = FavoriteLocation(context: context)
        newFavoriteLocation.name = name
        newFavoriteLocation.type = type

        do {
            try context.save()
        } catch {
            // error
        }
    }
    
    func deleteFavoriteLocation(location: LocationModel) {
        let favoriteLocationData = favoriteLocationDatas.first { $0.name == location.name }
        guard let favoriteLocationData else { return }
        context.delete(favoriteLocationData)
        
        do {
            try context.save()
        } catch {
            // error
        }
    }
    
}
