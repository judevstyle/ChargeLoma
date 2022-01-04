//
//  MapViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet weak var viewMap: UIView!
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
        UIApplication.shared.statusBarStyle = .darkContent
        setupMap()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mapView.clear()
        mapView.removeFromSuperview()
        mapView = nil
    }

    func setupUI() {
        setupSearchBar()
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 13.663491595353403, longitude: 100.6061463206966, zoom: 9.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.viewMap.frame.width, height: self.viewMap.frame.height), camera: camera)
        mapView.delegate = self
        self.viewMap.isUserInteractionEnabled = true
        self.viewMap.addSubview(mapView)
    }
    
    func setupSearchBar() {
        //searchBar
        let customFrame = CGRect(x: 0, y: 0, width: 0, height: 37.0)
        searchBar = UISearchBar(frame: customFrame)
        searchBar.delegate = self
        searchBar.placeholder = ""
        searchBar.compatibleSearchTextField.textColor = UIColor.gray
        searchBar.compatibleSearchTextField.backgroundColor = UIColor.white
        searchBar.setImage(UIImage(named: "search_icon"), for: .search, state: .normal)
        searchBar.searchTextField.isEnabled = true
        searchBar.tintColor = .gray
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.showsSearchResultsButton = true
        searchBar.setImage(UIImage(named: "menu"), for: .resultsList, state: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapSearch(_:)))
        searchBar.addGestureRecognizer(tap)
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
            marker.iconView =  MarkerStationView.instantiate(index: index, message: "test", imageUrl: "")
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
//        guard let markerView = marker.iconView as? MarkerMapView else { return false }
//        return viewModel.input.didSelectMarkerAt(mapView, marker: marker)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        var lat = coordinate.latitude
        var lng = coordinate.longitude
        
//        DispatchQueue.global().async {
//
//        }
    }
    
}

extension MapViewController: UISearchBarDelegate {
    
    @objc func handleTapSearch(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        debugPrint("handleTapSearch")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.searchBar.endEditing(true)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        debugPrint("Test")
    }
}
    

