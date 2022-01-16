//
//  GoViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class GoViewController: UIViewController {

    @IBOutlet var viewMap: UIView!
    @IBOutlet weak var viewTop: UIView!
    
    @IBOutlet weak var iconGPS: UIImageView!
    @IBOutlet weak var lineBetweenGPSToPin: UIView!
    @IBOutlet weak var iconPin: UIImageView!
    
    @IBOutlet weak var headTitleStart: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    
    @IBOutlet weak var headTitleEnd: UILabel!
    @IBOutlet weak var btnEnd: UIButton!
    
    private let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var listStationMarker: [GMSMarker] = []
    
    var sourceLocation: CLLocationCoordinate2D? = nil
    var destinationLocation: CLLocationCoordinate2D? = nil
    
    lazy var viewModel: GoProtocol = {
        let vm = GoViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.input.getStationFilter()
    }
    
    func configure(_ interface: GoProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupMap()
        self.fetchMarkerMap()
    }

    override func viewDidDisappear(_ animated: Bool) {
        mapView.clear()
        mapView.removeFromSuperview()
        mapView = nil
    }
    
    func setupUI() {
        NavigationManager.instance.setupWithNavigationController(navigationController: self.navigationController)
        headTitleStart.font = .smallText
        headTitleEnd.font = .smallText
        headTitleStart.textColor = .baseTextGray
        headTitleEnd.textColor = .baseTextGray
        
        headTitleStart.text = "จุดเริ่มต้น"
        headTitleEnd.text = "ปลายทาง"
        btnStart.setTitle("ตำแหน่งปัจจุบัน", for: .normal)
        btnEnd.setTitle("เลือกจุดหมาย", for: .normal)
        
        btnStart.titleLabel?.font = .bodyText
        btnEnd.titleLabel?.font = .bodyText
        btnStart.titleLabel?.textColor = .baseTextGray
        btnEnd.titleLabel?.textColor = .baseTextGray
        
        btnStart.addTarget(self, action: #selector(handleBtnStart), for: .touchUpInside)
        btnEnd.addTarget(self, action: #selector(handleBtnEnd), for: .touchUpInside)
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 13.663491595353403, longitude: 100.6061463206966, zoom: 7.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.viewMap.frame.width, height: self.viewMap.frame.height), camera: camera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        self.viewMap.isUserInteractionEnabled = true
        self.viewMap.addSubview(mapView)
        self.viewMap.clipsToBounds = true
        
        //initializing CLLocationManager
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    @objc func handleBtnStart() {
        NavigationManager.instance.pushVC(to: .searchStation(self, type: .sourceLocation), presentation: .presentFullScreen(completion: {}))
    }
    
    @objc func handleBtnEnd() {
        NavigationManager.instance.pushVC(to: .searchStation(self, type: .destinationLocation), presentation: .presentFullScreen(completion: {}))
    }
}

// MARK: - Binding
extension GoViewController {
    
    func bindToViewModel() {
        viewModel.output.didStationFilterSuccess = didStationFilterSuccess()
        viewModel.output.didStationFilterError = didStationFilterError()
        viewModel.output.didGetDirectionSuccess = didGetDirectionSuccess()
    }
    
    func didStationFilterSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.fetchMarkerMap()
        }
    }
    
    func didStationFilterError() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
        }
    }
    
    func didGetDirectionSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.renderPolylineMap()
        }
    }
    
    func fetchMarkerMap() {
        self.listStationMarker.removeAll()
        let markers = viewModel.output.getListStation()
        markers.enumerated().forEach({ (index, item) in
            let position = CLLocationCoordinate2D(latitude: item.lat ?? 0.0, longitude: item.lng ?? 0.0)
            let marker = GMSMarker(position: position)
            marker.snippet = "\(index)"
            marker.isTappable = true
            marker.iconView =  MarkerStationView.instantiate(station: item, index: index)
            marker.tracksViewChanges = true
            listStationMarker.append(marker)
        })
        
        self.listStationMarker.enumerated().forEach({ (index, item) in
            item.map = self.mapView
        })
    }
    
    func renderPolylineMap() {
        let routes = viewModel.output.getListRoute()
        for route in routes {
            let path = GMSPath.init(fromEncodedPath: route.points ?? "")
            let polyline = GMSPolyline.init(path: path)
            polyline.strokeColor = .basePrimary
            polyline.strokeWidth = 5
            polyline.map = self.mapView
        }
        moveToDirection()
    }
    
    func moveToDirection() {
        guard let sourceLocation = self.sourceLocation, let destinationLocation = self.destinationLocation else { return }
        
        let minLatitude: Double = sourceLocation.latitude > destinationLocation.latitude ? destinationLocation.latitude : sourceLocation.latitude
        let maxLatitude: Double = sourceLocation.latitude < destinationLocation.latitude ? destinationLocation.latitude : sourceLocation.latitude
        let minLongitude: Double = sourceLocation.longitude > destinationLocation.longitude ? destinationLocation.longitude : sourceLocation.longitude
        let maxLongitude: Double = sourceLocation.longitude < destinationLocation.longitude ? destinationLocation.longitude : sourceLocation.longitude

        let location = CLLocationCoordinate2D(latitude: (maxLatitude + minLatitude) * 0.5, longitude: (maxLongitude + minLongitude) * 0.5)
        
        let camera = GMSCameraPosition(target: location, zoom: 15, bearing: 0, viewingAngle: 0)
        self.mapView.animate(to: camera)
    }
}

extension GoViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {

    }

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let markerView = marker.iconView as? MarkerStationView else { return nil }
        let view = MarkerStationInfoView.instantiateFromNib()
        view.setupUI()
        view.setupValue(markerView.station)
        return view
    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let markerView = marker.iconView as? MarkerStationView, let stId = markerView.station?.stId else { return }
        NavigationManager.instance.pushVC(to: .detailStation(stId), presentation: .presentHalfModalAndFullScreen(rootVc: self, heightHalf: 350, completion: {
            
        }))
    }
}

extension GoViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 7.0, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
    }
}

extension GoViewController: SearchStationViewModelDelegate {
    func didSuccessSelectedLocation(placeItem: PlaceItem?, type: TypeDirectionMap) {
        guard let placeItem = placeItem, let latitude = placeItem.geometry?.locationLat, let longitude = placeItem.geometry?.locationLng else { return }
        debugPrint(placeItem)
        switch type {
        case .sourceLocation:
            self.sourceLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.btnStart.setTitle(placeItem.structuredFormatting?.mainText ?? "", for: .normal)
        case .destinationLocation:
            self.destinationLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.btnEnd.setTitle(placeItem.structuredFormatting?.mainText ?? "", for: .normal)
        }
        checkLocationMap()
    }

    func checkLocationMap() {
        guard let sourceLocation = self.sourceLocation, let destinationLocation = self.destinationLocation else { return }
        viewModel.input.getDirection(sourceLocation: sourceLocation, destinationLocation: destinationLocation)
        
    }
}
