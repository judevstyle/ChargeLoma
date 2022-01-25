//
//  DetailStationViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 10/1/2565 BE.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FittedSheets

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
    
    @IBOutlet weak var iconLocation: UIImageView!
    
    @IBOutlet weak var iconTime: UIImageView!
    
    @IBOutlet weak var titleNavigate: UILabel!
    @IBOutlet weak var titleFavorite: UILabel!
    @IBOutlet weak var titleShare: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var plugTableView: UITableView!
    @IBOutlet weak var plugTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var headService: UILabel!
    
    @IBOutlet weak var cbParking: CheckBoxView!
    @IBOutlet weak var titleParking: UILabel!
    
    @IBOutlet weak var cbFoodShop: CheckBoxView!
    @IBOutlet weak var titleFoodShop: UILabel!
    
    @IBOutlet weak var cbCoffeeShop: CheckBoxView!
    @IBOutlet weak var titleCoffeShop: UILabel!
    
    @IBOutlet weak var cbToilet: CheckBoxView!
    @IBOutlet weak var titleToilet: UILabel!
    
    @IBOutlet weak var cbMarket: CheckBoxView!
    @IBOutlet weak var titleMarket: UILabel!
    
    @IBOutlet weak var cbSleep: CheckBoxView!
    @IBOutlet weak var titleSleep: UILabel!
    
    @IBOutlet weak var cbWifi: CheckBoxView!
    @IBOutlet weak var titleWifi: UILabel!
    
    @IBOutlet weak var cbOther: CheckBoxView!
    @IBOutlet weak var titleOther: UILabel!
    
    private let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    
    private var lastContentOffset: CGFloat = 0
    
    @IBOutlet weak var bgBottomBar: UIView!
    @IBOutlet weak var bgRating: UIView!
    @IBOutlet weak var titleRating: UILabel!
    
    @IBOutlet weak var btnWriteReview: UIButton!
    
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
        setupTableView()
        setupCheckBox()
    }
    
    private func setupUI() {
        self.scrollView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false;
        self.scrollView.contentInset = .zero
        self.scrollView.scrollIndicatorInsets = .zero
        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollView.contentInsetAdjustmentBehavior = .never
        self.scrollView.insetsLayoutMarginsFromSafeArea = true
        self.scrollView.verticalScrollIndicatorInsets = .zero
        
        self.view.roundedTop(radius: 20)
        self.view.layer.shadowColor = UIColor.lightGray.cgColor
        self.view.layer.shadowOffset = .zero
        self.view.layer.shadowRadius = 20
        self.view.layer.shadowOpacity = 0.2
        
        let tapImageSeeAll = UITapGestureRecognizer(target: self, action: #selector(self.handleTapSeeAllGalleryPhoto(_:)))
        self.viewBadgeCount.addGestureRecognizer(tapImageSeeAll)
        self.viewBadgeCount.isUserInteractionEnabled = true
        
        self.iconTime.image = UIImage(named: "clock")?.withRenderingMode(.alwaysTemplate)
        self.iconLocation.image = UIImage(named: "compass")?.withRenderingMode(.alwaysTemplate)
        self.iconTime.tintColor = .basePrimary
        self.iconLocation.tintColor = .basePrimary
        
        self.titleNavigate.textColor = .basePrimary
        self.titleFavorite.textColor = .basePrimary
        self.titleShare.textColor = .basePrimary
        self.titleNavigate.text = "นำทาง"
        self.titleFavorite.text = "ชื่นชอบ"
        self.titleShare.text = "แชร์"
        
        self.titleNavigate.font = .smallText
        self.titleFavorite.font = .smallText
        self.titleShare.font = .smallText
        
        self.btnNavigate.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.btnNavigate.tintColor = .basePrimary
        self.btnFavorite.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.btnFavorite.tintColor = .baseTextGray
        self.btnShare.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.btnShare.tintColor = .basePrimary
        
        self.btnEdit.setRounded(rounded: 8)
        self.btnEdit.setBorder(width: 1.0, color: .basePrimary)
        self.btnEdit.tintColor = .basePrimary
        self.btnEdit.titleLabel?.font = .bodyBold
        self.btnEdit.backgroundColor = .white
        self.btnEdit.setTitle("แก้ไขข้อมูล", for: .normal)
        
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
        
        self.bgBottomBar.alpha = 0.0
        
        self.btnWriteReview.backgroundColor = .basePrimary
        self.btnWriteReview.titleLabel?.textColor = .white
        self.btnWriteReview.tintColor = .white
        self.btnWriteReview.titleLabel?.font = .bodyText
        self.btnWriteReview.setRounded(rounded: 8.0)
        
        self.bgRating.setRounded(rounded: 8)
        self.titleRating.font = .bodyText
        self.titleRating.tintColor = .white
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 13.663491595353403, longitude: 100.6061463206966, zoom: 7.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.viewMap.frame.width, height: self.viewMap.frame.height), camera: camera)
        mapView.delegate = self
        self.viewMap.addSubview(mapView)
        mapView.isUserInteractionEnabled = false

    }
    
    func setupTableView() {
        plugTableViewHeight.constant = 0
        plugTableView.delegate = self
        plugTableView.dataSource = self
        plugTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        plugTableView.registerCell(identifier: PlugTableViewCell.identifier)
    }

    func setupCheckBox() {
        headService.text = "สิ่งอำนวยความสะดวกอื่นๆ"
        headService.font = .bodyBold
        
        self.cbParking.isEnableCheckBox = false
        self.cbFoodShop.isEnableCheckBox = false
        self.cbCoffeeShop.isEnableCheckBox = false
        self.cbToilet.isEnableCheckBox = false
        self.cbMarket.isEnableCheckBox = false
        self.cbSleep.isEnableCheckBox = false
        self.cbWifi.isEnableCheckBox = false
        self.cbOther.isEnableCheckBox = false
        
        self.titleParking.text = "ที่จอดรถ"
        self.titleFoodShop.text = "ร้านอาหาร"
        self.titleCoffeShop.text = "ร้านกาแฟ"
        self.titleToilet.text = "ห้องน้ำ"
        self.titleMarket.text = "ร้านค้า"
        self.titleSleep.text = "ที่พักผ่อน"
        self.titleWifi.text = "Wifi"
        self.titleOther.text = "อื่นๆ"
        
        self.titleParking.font = .bodyText
        self.titleParking.textColor = .darkGray
        
        self.titleFoodShop.font = .bodyText
        self.titleFoodShop.textColor = .darkGray
        
        self.titleCoffeShop.font = .bodyText
        self.titleCoffeShop.textColor = .darkGray
        
        self.titleToilet.font = .bodyText
        self.titleToilet.textColor = .darkGray
        
        self.titleMarket.font = .bodyText
        self.titleMarket.textColor = .darkGray
        
        self.titleSleep.font = .bodyText
        self.titleSleep.textColor = .darkGray
        
        self.titleWifi.font = .bodyText
        self.titleWifi.textColor = .darkGray
        
        self.titleOther.font = .bodyText
        self.titleOther.textColor = .darkGray
    }
    
    @objc func handleTapSeeAllGalleryPhoto(_ sender: UITapGestureRecognizer? = nil) {
        debugPrint("handleTapSeeAllGalleryPhoto")
//        NavigationManager.instance.pushVC(to: .galleryPhoto, presentation: .ModelNav(completion: nil, isFullScreen: true))
        self.present(GalleryPhotoViewController(), animated: true, completion: nil)
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
            weakSelf.plugTableView.reloadData()
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
        
        setupMarker(item: station)
        
        
        descValue.text = station.stationName ?? "-"
        serviceCharge.text = "ค่าบริการ \(station.serviceRate ?? 0.0) บาท"
    }
    
    func setupMarker(item: StationData) {
        if let lat = item.lat, let lng = item.lng {
            let position = CLLocationCoordinate2D(latitude: item.lat ?? 0.0, longitude: item.lng ?? 0.0)
            let marker = GMSMarker(position: position)
            marker.snippet = "\(index)"
            marker.isTappable = true
            marker.iconView =  MarkerStationView.instantiate(station: item, index: 0)
            marker.tracksViewChanges = true
            marker.map = self.mapView
            
            debugPrint("Station")
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 15.0)
            self.mapView.animate(to: camera)
        }
    }
}

extension DetailStationViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {

    }
}

extension DetailStationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case plugTableView:
            let count = viewModel.output.getNumberOfRowsInSection(tableView, section: section, type: .plugTableView)
            let height = viewModel.output.getItemViewCellHeight(type: .plugTableView)
            plugTableViewHeight.constant = (CGFloat(count)*height)
            return count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case plugTableView:
            return viewModel.output.getItemViewCell(tableView, indexPath: indexPath, type: .plugTableView)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case plugTableView:
            return viewModel.output.getItemViewCellHeight(type: .plugTableView)
        default:
            return 0
        }
    }
}
