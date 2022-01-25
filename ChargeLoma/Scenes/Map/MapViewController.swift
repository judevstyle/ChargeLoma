//
//  MapViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import FittedSheets

public protocol MapViewControllerDelegate {
    func didEndChangeSheet(size: SheetSize)
}

public class MapViewController: UIViewController {

    @IBOutlet weak var viewMap: UIView!
    
    @IBOutlet weak var btnMapMenu: UIButton!
    @IBOutlet weak var btnMapLocation: UIButton!
    
    private let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var listStationMarker: [GMSMarker] = []
    
    var searchBar: UISearchBar!
    
    public var delegte: MapViewControllerDelegate? = nil
    
    lazy var tableSearchView : UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.setRounded(rounded: 8)
        table.delegate = self
        table.dataSource = self
        table.register(nibCellClassName: SearchResultTableViewCell.identifier)
        table.isScrollEnabled = false
        table.isHidden = true
        return table
    }()
    
    lazy var viewModel: MapProtocol = {
        let vm = MapViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.input.getStationFilter()
    }
    
    func configure(_ interface: MapProtocol) {
        self.viewModel = interface
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setBarTintColor(color: .clear)
        UIApplication.shared.statusBarStyle = .darkContent
        setupMap()
        self.fetchMarkerMap()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        mapView.clear()
        mapView.removeFromSuperview()
        mapView = nil
    }

    func setupUI() {
        setupSearchBar()
        self.btnMapMenu.addTarget(self, action: #selector(didTapMapMenuButton), for: .touchUpInside)
        self.btnMapLocation.addTarget(self, action: #selector(didTapMapLocationButton), for: .touchUpInside)
        
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
    
    func setupSearchBar() {
        //searchBar
        let customFrame = CGRect(x: 0, y: 0, width: view.frame.width - 32, height: 44)
        let titleSearchView = UIView(frame: customFrame)
        searchBar = UISearchBar(frame: customFrame)
//        searchBar.frame = customFrame
        searchBar.delegate = self
        searchBar.placeholder = ""
        searchBar.searchBarStyle = .prominent
        searchBar.compatibleSearchTextField.textColor = UIColor.lightGray
        searchBar.compatibleSearchTextField.backgroundColor = UIColor.white
        searchBar.setImage(UIImage(named: "search_icon"), for: .search, state: .normal)
        searchBar.searchTextField.isEnabled = true
        searchBar.tintColor = .gray
        searchBar.searchTextField.textColor = .gray
        searchBar.searchTextField.tintColor = .gray
        searchBar.searchTextField.clearButtonMode = .always
        searchBar.showsSearchResultsButton = true
        searchBar.setImage(UIImage(named: "menu"), for: .resultsList, state: .normal)
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "ค้นหา...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.smallText])
        
        searchBar.searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.bodyText
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.bodyText
        
        titleSearchView.addSubview(searchBar)
        self.navigationItem.titleView = titleSearchView
        
        view.addSubview(tableSearchView)
        tableSearchView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 200)
        
        
    }
}

// MARK: - Binding
extension MapViewController {
    
    func bindToViewModel() {
        viewModel.output.didStationFilterSuccess = didStationFilterSuccess()
        viewModel.output.didStationFilterError = didStationFilterError()
        
        viewModel.output.didGetPlaceAutoCompleteSuccess = didGetPlaceAutoCompleteSuccess()
        viewModel.output.didGetPlaceDetailSuccess = didGetPlaceDetailSuccess()
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
    
    func didGetPlaceAutoCompleteSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableSearchView.reloadData()
            if weakSelf.tableSearchView.isHidden == true {
                weakSelf.tableSearchView.fadeIn(0.3, onCompletion: {
                    
                })
            }
        }
    }
    
    func didGetPlaceDetailSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            guard let selectedPlace = weakSelf.viewModel.output.getLocationSelectedPlace() else { return }
            weakSelf.moveLocationToPlace(place: selectedPlace)
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
    
    private func moveLocationToPlace(place: PlaceItem) {
        guard let lat = place.geometry?.locationLat,
              let lng = place.geometry?.locationLng else { return }

        let camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: lat, longitude: lng), zoom: 15, bearing: 0, viewingAngle: 0)
        self.mapView.animate(to: camera)
        searchBar.searchTextField.text = ""
        tableSearchView.fadeOut()
        self.searchBar.endEditing(true)
    }
}

extension MapViewController : GMSMapViewDelegate {
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let markerView = marker.iconView as? MarkerStationView else { return false }
        return viewModel.input.didSelectMarkerAt(mapView, marker: marker)
    }
    
    public func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        var lat = coordinate.latitude
        var lng = coordinate.longitude
    }

    public func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let markerView = marker.iconView as? MarkerStationView else { return nil }
        let view = MarkerStationInfoView.instantiateFromNib()
        view.setupUI()
        view.setupValue(markerView.station)
        return view
    }

    public func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let markerView = marker.iconView as? MarkerStationView, let stId = markerView.station?.stId else { return }
        
//        NavigationManager.instance.pushVC(to: .detailStation(stId), presentation: .presentHalfModalAndFullScreen(rootVc: self, heightHalf: 645, completion: nil))
        
        NavigationManager.instance.pushVC(to: .stationDetail(stId), presentation: .presentHalfModalAndFullScreen(rootVc: self, heightHalf: 645, completion: nil))
    }
    
}

extension MapViewController: UISearchBarDelegate {
    
    @objc func handleTapSearch(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    public func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        NavigationManager.instance.pushVC(to: .profile)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            var request: GetPlaceAutoCompleteRequest = GetPlaceAutoCompleteRequest()
            request.input = text
            viewModel.input.getAutoComplete(request: request)
        } else {
            tableSearchView.fadeOut(0.3, onCompletion: {
                
            })
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 7.0, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
    }
}

//Event
extension MapViewController {
    @objc func didTapMapMenuButton() {
        NavigationManager.instance.pushVC(to: .mapFilter)
    }
    
    @objc func didTapMapLocationButton() {
        guard let lat = self.mapView.myLocation?.coordinate.latitude,
              let lng = self.mapView.myLocation?.coordinate.longitude else { return }

        let camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: lat, longitude: lng), zoom: 15, bearing: 0, viewingAngle: 0)
        self.mapView.animate(to: camera)
    }
}

//TableView Delegate
extension MapViewController: UITableViewDelegate, UITableViewDataSource  {
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = viewModel.output.getListResultPlace().count
        return count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier) as! SearchResultTableViewCell
        let place = viewModel.output.getListResultPlace()[indexPath.item]
        cell.place = place
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = viewModel.output.getListResultPlace()[indexPath.item]
        viewModel.input.didSelectPlace(item: place)
    }
}
