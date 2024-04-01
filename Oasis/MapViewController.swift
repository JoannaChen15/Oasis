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
    
    private var mapView = MKMapView()
    private let taipeiRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.0330, longitude: 121.5654), latitudinalMeters: 50000, longitudinalMeters: 50000)
    
//    private var locations = [Location]()
    private var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        getNaturalLandmark(in: taipeiRegion) { locations in
            self.createAnnotation(locations: locations)
        }
        
    }
    
    func setupMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        mapView.setRegion(taipeiRegion, animated: true)
//        mapView.showsUserLocation = true
    }
    
    func getNaturalLandmark(in region: MKCoordinateRegion, completion: @escaping (_ locations: [Location]) -> Void) {
        var locations = [Location]()
        for landmarkType in LandmarkType.allCases {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = landmarkType.rawValue // 搜尋的地標類型
            request.region = region // 搜尋的區域
            
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
                    let location = Location(name: item.name ?? "未知", latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude)
                    locations.append(location)
                }
                completion(locations)
            }
        }
    }
    
    func createAnnotation(locations: [Location]) {
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotation.title = location.name
            mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
    }

}

private enum LandmarkType: String, CaseIterable {
    case mountains
    case hiking
    case campground
    case beach
}
