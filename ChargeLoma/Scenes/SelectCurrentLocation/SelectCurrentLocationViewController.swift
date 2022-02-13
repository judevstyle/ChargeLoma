//
//  SelectCurrentLocationViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 13/2/2565 BE.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

public protocol SelectCurrentLocationViewControllerDelegate {
    func didSubmitEditLocation(centerMapCoordinate: CLLocationCoordinate2D)
}

class SelectCurrentLocationViewController: UIViewController {
    
    @IBOutlet weak var viewMap: UIView!
    private let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var centerMapCoordinate: CLLocationCoordinate2D!
    var marker: GMSMarker!
    
    @IBOutlet weak var btnEditLocation: UIButton!
    
    public var delegate: SelectCurrentLocationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        setupMap()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        mapView.clear()
        mapView.removeFromSuperview()
        mapView = nil
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
    
    func setupUI() {
        btnEditLocation.setTitle("แก้ไขพิกัด", for: .normal)
        btnEditLocation.tintColor = .white
        btnEditLocation.setRounded(rounded: 5)
        btnEditLocation.titleLabel?.font = .bodyText
        btnEditLocation.addTarget(self, action: #selector(handleDidEditLocation), for: .touchUpInside)
    }
    
    @objc func handleDidEditLocation() {
        self.delegate?.didSubmitEditLocation(centerMapCoordinate: self.centerMapCoordinate)
        self.navigationController?.popViewController(animated: true)
    }

}

extension SelectCurrentLocationViewController : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        self.centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        self.placeMarkerOnCenter(centerMapCoordinate: centerMapCoordinate)
    }
    
    func placeMarkerOnCenter(centerMapCoordinate: CLLocationCoordinate2D) {
        if marker == nil {
            marker = GMSMarker()
        }
        marker.position = centerMapCoordinate
        marker.map = self.mapView
    }
}


extension SelectCurrentLocationViewController: CLLocationManagerDelegate {
    
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
