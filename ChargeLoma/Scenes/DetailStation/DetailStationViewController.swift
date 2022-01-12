//
//  DetailStationViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 10/1/2565 BE.
//

import UIKit
import GoogleMaps
import GooglePlaces

class DetailStationViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewIndicator: UIView!
    @IBOutlet weak var imagePosterView: UIImageView!
    @IBOutlet weak var titleBadgeCount: UILabel!
    @IBOutlet weak var viewBadgeCount: UIView!
    
    @IBOutlet weak var logoStationImageView: UIImageView!
    
    @IBOutlet weak var titleStationValue: UILabel!
    @IBOutlet weak var adressStationValue: UILabel!
    
    @IBOutlet weak var distanceValue: UILabel!
    @IBOutlet weak var timeValue: UILabel!
    
    @IBOutlet weak var btnNavigate: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var viewMap: UIView!
    
    @IBOutlet weak var headDesc: UILabel!
    @IBOutlet weak var descValue: UILabel!
    @IBOutlet weak var serviceCharge: UILabel!
    
    @IBOutlet weak var headPlug: UILabel!
    
    private let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    
    private var lastContentOffset: CGFloat = 0
    
    lazy var viewModel: DetailStationProtocol = {
        let vm = DetailStationViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.getDetailStation()
    }
    
    func configure(_ interface: DetailStationProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        setupMap()
//        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    private func setupUI() {
        
        self.scrollView.delegate = self
        
        self.view.roundedTop(radius: 20)
        self.view.layer.shadowColor = UIColor.lightGray.cgColor
        self.view.layer.shadowOffset = .zero
        self.view.layer.shadowRadius = 20
        self.view.layer.shadowOpacity = 0.2
        
        self.automaticallyAdjustsScrollViewInsets = false;
        self.scrollView.contentInset = .zero
        self.scrollView.scrollIndicatorInsets = .zero
        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollView.contentInsetAdjustmentBehavior = .never
        self.scrollView.insetsLayoutMarginsFromSafeArea = true
        self.scrollView.verticalScrollIndicatorInsets = .zero
        
        imagePosterView.roundedTop(radius: 20)
        imagePosterView.layer.masksToBounds = true
        viewIndicator.setRounded(rounded: 5)
        
        viewBadgeCount.setRounded(rounded: 4)
        titleBadgeCount.font = .biggerTinyBold
        
        titleStationValue.font = .h3Bold
        titleStationValue.textColor = .black
        adressStationValue.font = .smallText
        adressStationValue.textColor = .baseTextGray
        
        distanceValue.font = .extraSmallText
        distanceValue.textColor = .baseTextGray
        timeValue.font = .extraSmallText
        timeValue.textColor = .baseTextGray
        
        headDesc.font = .bodyBold
        headPlug.font = .bodyBold
        descValue.font = .smallText
        descValue.textColor = .baseTextGray
        serviceCharge.font = .smallText
        serviceCharge.textColor = .baseTextGray
        
        headDesc.text = "รายละเอียด"
        headPlug.text = "หัวจ่าย"
        serviceCharge.text = "ค่าบริการ \(0.0) บาท"
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 13.663491595353403, longitude: 100.6061463206966, zoom: 7.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.viewMap.frame.width, height: self.viewMap.frame.height), camera: camera)
        mapView.delegate = self
        self.viewMap.isUserInteractionEnabled = false
        self.viewMap.addSubview(mapView)
        mapView.isUserInteractionEnabled = false
        
        //initializing CLLocationManager
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    

}

extension DetailStationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
//             scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
//         }
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move up
            debugPrint("Scroll UP")
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
           // move down
            debugPrint("Scroll Down")
        }

        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
        debugPrint("Position Scroll \(self.lastContentOffset)")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
}

extension DetailStationViewController: HalfModalPresentable {
    public func transitionFullScreenEnd() {
        viewIndicator.isHidden = true
        scrollView.isScrollEnabled = true
        debugPrint("isScrollEnabled")
    }

    public func transitionHalfScreenEnd() {
        viewIndicator.isHidden = false
//        scrollView.isScrollEnabled = false
        debugPrint("isNoScrollEnabled")
    }
}

// MARK: - Binding
extension DetailStationViewController {
    
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
        imagePosterView.kf.setImageDefault(with: URL(string: "123")!)
        guard let station = viewModel.output.getDataStation() else { return }
        imagePosterView.setPlaceholderImageView()
        
        if let posterImage = station.stationImg, let urlImage = URL(string: "\(posterImage)") {
            imagePosterView.kf.setImageDefault(with: urlImage)
        }

        if let logoImage = station.provider?.logoLabel, let urlImage = URL(string: "\(logoImage)") {
            logoStationImageView.kf.setImageDefault(with: urlImage)
        }
        titleStationValue.text = station.stationName ?? ""
        adressStationValue.text = station.addr ?? ""
        
        distanceValue.text = "ไม่พบพิกัดผู้ใช้งาน"
        timeValue.text = station.servicetimeOpen ?? ""

        if let lat = station.lat, let lng = station.lng {
            debugPrint("sss")
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 9.0)
            mapView.animate(to: camera)
        }
        
        setupMarker(item: station)
        
        
        descValue.text = station.stationName ?? "-"
        serviceCharge.text = "ค่าบริการ \(station.serviceRate ?? 0.0) บาท"
    }
    
    func setupMarker(item: StationData) {
        let position = CLLocationCoordinate2D(latitude: item.lat ?? 0.0, longitude: item.lng ?? 0.0)
        let marker = GMSMarker(position: position)
        marker.snippet = "\(index)"
        marker.isTappable = true
        marker.iconView =  MarkerStationView.instantiate(station: item, index: 0)
        marker.tracksViewChanges = true
        marker.map = self.mapView
    }
}

extension DetailStationViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {

    }
}

//implementing extension from CLLocationManagerDelegate
extension DetailStationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 7, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
        
    }
    
}
