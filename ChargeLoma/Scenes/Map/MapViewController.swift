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
import SPPermissions
import SPPermissionsLocationWhenInUse
//import SPPermissionsLocationAlways

public protocol MapViewControllerDelegate {
    func didEndChangeSheet(size: SheetSize)
}

public class MapViewController: UIViewController {

    @IBOutlet weak var viewMap: UIView!
    
    @IBOutlet weak var btnMapMenu: UIButton!
    @IBOutlet weak var btnMapLocation: UIButton!
    
    private let locationManager = CLLocationManager()
    var mapView: GMSMapView? = nil
    var listStationMarker: [GMSMarker] = []
    public var delegte: MapViewControllerDelegate? = nil
    var changeLanguage: Language = Language.current
    
    @IBOutlet var inputSearchText: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuProfile: UIImageView!
    @IBOutlet var btnClearInputSearch: UIButton!
    
    lazy var viewModel: MapProtocol = {
        let vm = MapViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func configure(_ interface: MapProtocol) {
        self.viewModel = interface
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.statusBarStyle = .darkContent
        setupMap()
        viewModel.input.getStationFilter()
        
        if changeLanguage != Language.current {
            changeLanguage = Language.current
            NavigationManager.instance.refreshTabbar()
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        mapView?.clear()
        mapView?.removeFromSuperview()
        mapView?.stopRendering()
        mapView = nil
    }

    func setupUI() {
        setupTableView()
        setupSearchBar()
        self.btnMapMenu.setImage(UIImage(named: "filter")?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.btnMapMenu.contentVerticalAlignment = .fill
        self.btnMapMenu.contentHorizontalAlignment = .fill
        self.btnMapMenu.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        self.btnMapMenu.setRounded(rounded: self.btnMapMenu.frame.width/2)
        self.btnMapMenu.addTarget(self, action: #selector(didTapMapMenuButton), for: .touchUpInside)
        
        self.btnMapLocation.setImage(UIImage(named: "gps")?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.btnMapLocation.contentVerticalAlignment = .fill
        self.btnMapLocation.contentHorizontalAlignment = .fill
        self.btnMapLocation.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        self.btnMapLocation.setRounded(rounded: self.btnMapLocation.frame.width/2)
        self.btnMapLocation.addTarget(self, action: #selector(didTapMapLocationButton), for: .touchUpInside)
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 13.663491595353403, longitude: 100.6061463206966, zoom: 7.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.viewMap.frame.width, height: self.viewMap.frame.height), camera: camera)
        mapView?.delegate = self
        mapView?.isMyLocationEnabled = true
        self.viewMap.isUserInteractionEnabled = true
        self.viewMap.clipsToBounds = true
        if let mapView = self.mapView {
            self.viewMap.addSubview(mapView)
        }
        
        //initializing CLLocationManager
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func setupTableView() {
        tableView.backgroundColor = .white
        tableView.setRounded(rounded: 8)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibCellClassName: SearchResultTableViewCell.identifier)
        tableView.isScrollEnabled = false
        tableView.isHidden = true
    }
    
    func setupSearchBar() {
        self.navigationItem.titleView = nil
        //searchBar
        inputSearchText.backgroundColor = .white
        inputSearchText.setRounded(rounded: 8)
        inputSearchText.tintColor = .basePrimary
        inputSearchText.textColor = .baseTextGray
        inputSearchText.setPaddingLeft(padding: 30)
        inputSearchText.setPaddingRight(padding: 30)
        inputSearchText.font = UIFont.h3Text
        inputSearchText.placeholder = ""
        inputSearchText.clearButtonMode = .always
        inputSearchText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        btnClearInputSearch.isHidden = true

        menuProfile.isUserInteractionEnabled = true
        let tapMenu: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapMenu))
        menuProfile.addGestureRecognizer(tapMenu)
        
        btnClearInputSearch.addTarget(self, action: #selector(handleClearInputSearch), for: .touchUpInside)
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
            weakSelf.tableView.reloadData()
            if weakSelf.tableView.isHidden == true {
                weakSelf.tableView.fadeIn(0.3, onCompletion: {
                    
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
            marker.tracksViewChanges = false
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
        self.mapView?.animate(to: camera)
        tableView.fadeOut()
    }
}

extension MapViewController : GMSMapViewDelegate {
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let markerView = marker.iconView as? MarkerStationView else { return false }
        return viewModel.input.didSelectMarkerAt(mapView, marker: marker)
    }
    
    public func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        view.endEditing(true)
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
        
        NavigationManager.instance.pushVC(to: .stationDetail(stId, isFromPushNavigation: false), presentation: .presentHalfModalAndFullScreen(rootVc: self, heightHalf: 645, completion: nil))
//        NavigationManager.instance.pushVC(to: .bGSheet(stId), presentation: .presentBackground)
    }
    
}

extension MapViewController: UISearchBarDelegate {
    
    @objc func handleTapMenu(_ sender: UITapGestureRecognizer? = nil) {
        NavigationManager.instance.pushVC(to: .profile)
    }
    
    @objc func handleClearInputSearch() {
        inputSearchText.clearText()
        textFieldDidChange(inputSearchText)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            var request: GetPlaceAutoCompleteRequest = GetPlaceAutoCompleteRequest()
            request.input = text
            btnClearInputSearch.isHidden = false
            menuProfile.isHidden = true
            viewModel.input.getAutoComplete(request: request)
        } else {
            btnClearInputSearch.isHidden = true
            menuProfile.isHidden = false
            tableView.fadeOut(0.3, onCompletion: {
                
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
        mapView?.isMyLocationEnabled = true
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView?.camera = GMSCameraPosition(target: location.coordinate, zoom: 14.0, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
    }
}

//Event
extension MapViewController {
    @objc func didTapMapMenuButton() {
        NavigationManager.instance.pushVC(to: .mapFilter)
    }
    
    @objc func didTapMapLocationButton() {

        if SPPermissions.Permission.locationWhenInUse.authorized {
            debugPrint("authorized")
            guard let lat = self.mapView?.myLocation?.coordinate.latitude,
                  let lng = self.mapView?.myLocation?.coordinate.longitude else { return }

            let camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: lat, longitude: lng), zoom: 14.0, bearing: 0, viewingAngle: 0)
            self.mapView?.animate(to: camera)
        } else {
            debugPrint("Non authorized")
            let permissions: [SPPermissions.Permission] = [.locationWhenInUse]
            let controller = SPPermissions.native(permissions)
            controller.present(on: self)
        }
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
