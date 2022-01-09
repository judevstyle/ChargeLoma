//
//  StationDetailViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 5/1/2565 BE.
//

import UIKit
import GoogleMaps
import GooglePlaces

class StationDetailViewController: UIViewController {

    @IBOutlet weak var viewIndicator: UIView!
    @IBOutlet weak var imagePosterView: UIImageView!
    @IBOutlet weak var titleBadgeCount: UILabel!
    @IBOutlet weak var viewBadgeCount: UIView!
    
    @IBOutlet weak var logoStationImageView: UIImageView!
    
    @IBOutlet weak var titleStationValue: UILabel!
    @IBOutlet weak var adressStationValue: UILabel!
    
    @IBOutlet weak var distanceValue: UILabel!
    @IBOutlet weak var timeValue: UILabel!
    
    @IBOutlet weak var navigateButton: UIButton!
    
    @IBOutlet weak var viewMap: UIView!
    private let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    
    lazy var viewModel: StationDetailProtocol = {
        let vm = StationDetailViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.getStationDetail()
    }
    
    func configure(_ interface: StationDetailProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        setupMap()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mapView.clear()
        mapView.removeFromSuperview()
        mapView = nil
    }
    
    func setupUI() {
        
        NavigationManager.instance.setupWithNavigationController(navigationController: self.navigationController)
        self.view.backgroundColor = .white
        self.view.roundedTop(radius: 20)
        self.view.layer.shadowColor = UIColor.lightGray.cgColor
        self.view.layer.shadowOffset = .zero
        self.view.layer.shadowRadius = 20
        self.view.layer.shadowOpacity = 0.2
        
        imagePosterView.roundedTop(radius: 20)
        imagePosterView.layer.masksToBounds = true
        viewIndicator.setRounded(rounded: 5)
        
        viewBadgeCount.setRounded(rounded: 4)
        titleBadgeCount.font = .biggerTinyBold
        
        titleStationValue.font = .h3Bold
        titleStationValue.textColor = .black
        adressStationValue.font = .extraSmallText
        adressStationValue.textColor = .baseTextGray
        
        distanceValue.font = .extraSmallText
        timeValue.font = .extraSmallText
        
        navigateButton.alignTextBelow()
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 13.663491595353403, longitude: 100.6061463206966, zoom: 9.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.viewMap.frame.width, height: self.viewMap.frame.height), camera: camera)
        mapView.delegate = self
        self.viewMap.isUserInteractionEnabled = true
        self.viewMap.addSubview(mapView)
        self.viewMap.clipsToBounds = true
        
        //initializing CLLocationManager
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func handleNavigateButton(_ sender: Any) {
        debugPrint("Navigate")
    }
    @IBAction func handleFavoriteBtn(_ sender: Any) {
        NavigationManager.instance.pushVC(to: .login, presentation: .ModalNoNav(completion: nil))
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//        let rootViewcontroller = storyboard.instantiateInitialViewController() ?? UIViewController()
//        self.navigationController?.present(rootViewcontroller, animated: true, completion: nil)
    }
    
}

extension StationDetailViewController: HalfModalPresentable {
    public func transitionFullScreenEnd() {
        viewIndicator.isHidden = true
    }
    
    public func transitionHalfScreenEnd() {
        viewIndicator.isHidden = false
    }
}

// MARK: - Binding
extension StationDetailViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetStationSuccess = didGetStationSuccess()
        viewModel.output.didGetStationError = didGetStationError()
    }
    
    func didGetStationSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setupValue()
        }
    }
    
    func didGetStationError() -> (() -> Void) {
        return { [weak self] in
            guard let weakSelf = self else { return }
        }
    }
    
    private func setupValue() {
//        imagePosterView.kf.setImageDefault(with: URL(string: "123")!)
        guard let station = viewModel.output.getDataStation() else { return }
        imagePosterView.setPlaceholderImageView()
            
        if let pathImage = station.provider?.logoLabel, let urlImage = URL(string: "\(pathImage)") {
            logoStationImageView.kf.setImageDefault(with: urlImage)
        }
        titleStationValue.text = station.stationName ?? ""
        adressStationValue.text = station.addr ?? ""
    }
}

extension StationDetailViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {

    }
}

//implementing extension from CLLocationManagerDelegate
extension StationDetailViewController: CLLocationManagerDelegate {
    
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

