//
//  MapViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {

    @IBOutlet weak var viewMap: UIView!
    
    private let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var listStationMarker: [GMSMarker] = []
    
    var searchBar: UISearchBar!
    
    lazy var viewModel: MapProtocol = {
        let vm = MapViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.input.getStationFilter()
    }
    
    func configure(_ interface: MapProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setBarTintColor(color: .clear)
        UIApplication.shared.statusBarStyle = .darkContent
        setupMap()
//        viewModel.input.getStationFilter()
        
        self.viewMap.addSubview(mapView)
        self.fetchMarkerMap()
    }

    override func viewDidDisappear(_ animated: Bool) {
        mapView.clear()
        mapView.removeFromSuperview()
        mapView = nil
    }

    func setupUI() {
        NavigationManager.instance.setupWithNavigationController(navigationController: self.navigationController)
        setupSearchBar()
//        setupHandleTapView()
//        self.edgesForExtendedLayout = []
        
    }
    
//    func setupHandleTapView() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapView))
//        tap.cancelsTouchesInView = false
//        self.mapView.addGestureRecognizer(tap)
//    }
//
//    @objc func handleTapView() {
//        debugPrint("Test")
//    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 13.663491595353403, longitude: 100.6061463206966, zoom: 9.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.viewMap.frame.width, height: self.viewMap.frame.height), camera: camera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.viewMap.isUserInteractionEnabled = true
        self.viewMap.addSubview(mapView)
        self.viewMap.clipsToBounds = true
        
        //initializing CLLocationManager
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func setupSearchBar() {
        //searchBar
        let customFrame = CGRect(x: 0, y: 0, width: 0, height: 37.0)
        searchBar = UISearchBar(frame: customFrame)
        searchBar.delegate = self
        searchBar.placeholder = ""
        searchBar.searchBarStyle = .prominent
        searchBar.compatibleSearchTextField.textColor = UIColor.gray
        searchBar.compatibleSearchTextField.backgroundColor = UIColor.white
        searchBar.setImage(UIImage(named: "search_icon"), for: .search, state: .normal)
        searchBar.searchTextField.isEnabled = true
        searchBar.tintColor = .gray
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.showsSearchResultsButton = true
        searchBar.setImage(UIImage(named: "menu"), for: .resultsList, state: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapSearch(_:)))
        searchBar.searchTextField.addGestureRecognizer(tap)
        searchBar.isUserInteractionEnabled = true
        
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.bodyText
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.bodyText
        
        self.navigationItem.titleView = searchBar
    }
}

// MARK: - Binding
extension MapViewController {
    
    func bindToViewModel() {
        viewModel.output.didStationFilterSuccess = didStationFilterSuccess()
        viewModel.output.didStationFilterError = didStationFilterError()
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
}

extension MapViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let markerView = marker.iconView as? MarkerStationView else { return false }
        return viewModel.input.didSelectMarkerAt(mapView, marker: marker)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        var lat = coordinate.latitude
        var lng = coordinate.longitude
    
//        debugPrint("Tap \(lat)")
    }

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let markerView = marker.iconView as? MarkerStationView else { return nil }
        let view = MarkerStationInfoView.instantiateFromNib()
        view.setupUI()
        view.setupValue(markerView.station)
        return view
    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        debugPrint("didTapInfoWindowOf")
        guard let markerView = marker.iconView as? MarkerStationView, let stId = markerView.station?.stId else { return }
        NavigationManager.instance.pushVC(to: .stationDetail(stId), presentation: .presentHalfModalAndFullScreen(rootVc: self, heightHalf: 650, completion: {
            
        }))
    }
    
}

extension MapViewController: UISearchBarDelegate {
    
    @objc func handleTapSearch(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.searchBar.endEditing(true)
        NavigationManager.instance.pushVC(to: .searchStation, presentation: .Present(modalTransitionStyle: .crossDissolve, modalPresentationStyle: .fullScreen))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        NavigationManager.instance.pushVC(to: .profile)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
        
    }
    
}

