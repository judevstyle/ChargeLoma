//
//  StationDetailViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 19/1/2565 BE.
//

import UIKit
import FittedSheets
import GoogleMaps
import GooglePlaces
import CoreLocation

class StationDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    @IBOutlet weak var headReview: UILabel!
    @IBOutlet weak var tableReview: UITableView!
    @IBOutlet weak var tableReviewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var spaceScrollViewWithBottom: NSLayoutConstraint!
    
    public var isFromPushNavigation: Bool = false
    
    @IBOutlet weak var topPosterImageConstant: NSLayoutConstraint!
    @IBOutlet weak var leftPosterImageConstant: NSLayoutConstraint!
    @IBOutlet weak var rightPosterImageConstant: NSLayoutConstraint!
    
    lazy var viewModel: StationDetailProtocol = {
        let vm = StationDetailViewModel(vc: self)
        self.configure(vm)
        self.bindToViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupCheckBox()
        viewModel.input.getStationDetail()
    }
    
    func configure(_ interface: StationDetailProtocol) {
        self.viewModel = interface
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        setupMap()
        self.sheetViewController?.handleScrollView(self.scrollView)
        reloadStationLocation()
    }

    override func viewDidDisappear(_ animated: Bool) {
        mapView.clear()
        mapView.removeFromSuperview()
        mapView = nil
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableReviewHeight?.constant = self.tableReview.contentSize.height
    }
    
    private func setupUI() {
        self.sheetViewController?.handleScrollView(self.scrollView)
        self.automaticallyAdjustsScrollViewInsets = false;
        self.scrollView.contentInset = .zero
        self.scrollView.scrollIndicatorInsets = .zero
        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollView.contentInsetAdjustmentBehavior = .never
        self.scrollView.insetsLayoutMarginsFromSafeArea = true
        self.scrollView.verticalScrollIndicatorInsets = .zero
        
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
        
        self.titleNavigate.font = .bodyText
        self.titleFavorite.font = .bodyText
        self.titleShare.font = .bodyText
        
        self.btnNavigate.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.btnNavigate.tintColor = .basePrimary
        self.btnFavorite.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.btnFavorite.tintColor = .baseTextGray
        self.btnShare.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.btnShare.tintColor = .basePrimary
        
        
        self.btnNavigate.addTarget(self, action: #selector(handleNavigateButton), for: .touchUpInside)
        self.btnFavorite.addTarget(self, action: #selector(handleFavoriteButton), for: .touchUpInside)
        self.btnShare.addTarget(self, action: #selector(handleShareButton), for: .touchUpInside)
        
        self.btnEdit.setRounded(rounded: 8)
        self.btnEdit.setBorder(width: 1.0, color: .basePrimary)
        self.btnEdit.tintColor = .basePrimary
        self.btnEdit.titleLabel?.font = .bodyBold
        self.btnEdit.backgroundColor = .white
        self.btnEdit.setTitle("แก้ไขข้อมูล", for: .normal)
        
        imagePosterView.setRounded(rounded: 8)
        imagePosterView.layer.masksToBounds = true
        imagePosterView.setPlaceholderImageView()
        imagePosterView.isUserInteractionEnabled = true
        let tapPosterFullScreen = UITapGestureRecognizer(target: self, action: #selector(self.handleTapPosterFullScreen(_:)))
        imagePosterView.addGestureRecognizer(tapPosterFullScreen)
        
        viewBadgeCount.setRounded(rounded: 4)
        titleBadgeCount.font = .extraSmallText
        
        titleStationValue.font = .h2Bold
        titleStationValue.textColor = .black
        adressStationValue.font = .bodyText
        adressStationValue.textColor = .baseTextGray
        
        distanceValue.font = .smallText
        distanceValue.textColor = .baseTextGray
        timeValue.font = .smallText
        timeValue.textColor = .baseTextGray
        
        headDesc.font = .h3Bold
        headPlug.font = .h3Bold
        descValue.font = .bodyText
        descValue.textColor = .baseTextGray
        serviceCharge.font = .bodyText
        serviceCharge.textColor = .baseTextGray
        
        headDesc.text = "รายละเอียด"
        headPlug.text = "หัวจ่าย"
        serviceCharge.text = "ค่าบริการ \(0.0) บาท"
        
        self.bgBottomBar.alpha = 1.0
//        self.bgBottomBar.setShadowBoxView()
        
        self.btnWriteReview.backgroundColor = .basePrimary
        self.btnWriteReview.titleLabel?.textColor = .white
        self.btnWriteReview.tintColor = .white
        self.btnWriteReview.titleLabel?.font = .h3Bold
        self.btnWriteReview.setRounded(rounded: 8.0)
        self.btnWriteReview.addTarget(self, action: #selector(handleBtnAddReview), for: .touchUpInside)
        
        self.bgRating.setRounded(rounded: 8)
        self.titleRating.font = .h3Bold
        self.titleRating.tintColor = .white
        
        
        headReview.font = .h3Bold
        headReview.text = "รีวิวจากผู้ใช้บริการ"
        
        
        if isFromPushNavigation {
            topPosterImageConstant.constant = 0
            leftPosterImageConstant.constant = 0
            rightPosterImageConstant.constant = 0
            setBgBottomBar(isHidden: false, isAnimate: false)
        }
        
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 13.663491595353403, longitude: 100.6061463206966, zoom: 7.0)
        mapView = GMSMapView.map(withFrame: self.viewMap.bounds, camera: camera)
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        self.viewMap.addSubview(mapView)
        mapView.clipsToBounds = true
        self.viewMap.clipsToBounds = true
        mapView.autoresizingMask = .flexibleHeight
        mapView.autoresizingMask = .flexibleWidth
        let tapMapView = UITapGestureRecognizer(target: self, action: #selector(self.handleTapMapLocation))
        self.viewMap.isUserInteractionEnabled = true
        viewMap.addGestureRecognizer(tapMapView)
    }
    
    func setupTableView() {
        plugTableViewHeight.constant = 0
        plugTableView.delegate = self
        plugTableView.dataSource = self
        plugTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        plugTableView.registerCell(identifier: PlugTableViewCell.identifier)
        
        
        tableReviewHeight.constant = 0
        tableReview.delegate = self
        tableReview.dataSource = self
        tableReview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableReview.estimatedRowHeight = 80
        tableReview.rowHeight = UITableView.automaticDimension
        tableReview.registerCell(identifier: ReviewTableViewCell.identifier)
        tableReview.registerCell(identifier: SeeAllTableViewCell.identifier)
    }
    
    func setupCheckBox() {
        headService.text = "สิ่งอำนวยความสะดวกอื่นๆ"
        headService.font = .h3Bold
        
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
        if let listImage = viewModel.output.getListStrImageStation(), listImage.count > 0 {
            NavigationManager.instance.pushVC(to: .galleryPhoto(listImage: listImage), presentation: .Present(withNav: true, modalTransitionStyle: .crossDissolve, modalPresentationStyle: .overFullScreen))
        }
    }
    
    @objc func handleTapPosterFullScreen(_ sender: UITapGestureRecognizer? = nil) {
        if let listImage = viewModel.output.getListStrImageStation(), listImage.count > 0 {
            NavigationManager.instance.pushVC(to: .imageListFullScreen(listImage: [listImage[0]], index: 0), presentation: .Present(withNav: true, modalTransitionStyle: .crossDissolve, modalPresentationStyle: .overFullScreen))
        }
    }

  
    func setBgBottomBar(isHidden: Bool, isAnimate: Bool) {
        self.bgBottomBar.isHidden = false
        self.bgBottomBar.alpha = 0.0
        
        if isAnimate == true {
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                if isHidden == true {
                    self.bgBottomBar.alpha = 0.0
                    self.spaceScrollViewWithBottom.constant = 0
                } else {
                    self.bgBottomBar.alpha = 1.0
                    self.spaceScrollViewWithBottom.constant = 61
                }
            }, completion: nil)
        } else {
            if isHidden == true {
                self.bgBottomBar.alpha = 0.0
                self.spaceScrollViewWithBottom.constant = 0
            } else {
                self.bgBottomBar.alpha = 1.0
                self.spaceScrollViewWithBottom.constant = 61
            }
        }
    }
}


// MARK: - Binding
extension StationDetailViewController {
    
    func bindToViewModel() {
        viewModel.output.didGetStationSuccess = didGetStationSuccess()
        viewModel.output.didGetFavoriteSuccess = didGetFavoriteSuccess()
        viewModel.output.didGetImageStationSuccess = didGetImageStationSuccess()
        viewModel.output.didGetReviewSuccess = didGetReviewSuccess()
    }
    
    func didGetStationSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            self.setupValue()
            self.plugTableView.reloadData()
            
            //initializing CLLocationManager
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func didGetFavoriteSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            self.reloadFavorite()
        }
    }
    
    func didGetImageStationSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            let listImage = self.viewModel.output.getListImageStation()
            if listImage.count > 0 {
                if let posterImage = listImage[0].imgPath, let urlImage = URL(string: "\(posterImage)") {
                    self.imagePosterView.kf.setImageDefault(with: urlImage)
                }
                
                self.titleBadgeCount.text = "\(listImage.count)"
            } else {
                if let station = self.viewModel.output.getDataStation(), let posterImage = station.stationImg, let urlImage = URL(string: "\(posterImage)") {
                    self.imagePosterView.kf.setImageDefault(with: urlImage)
                }
            }
        }
    }
    
    func didGetReviewSuccess() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            self.tableReview.reloadData()
            self.tableReview.layoutIfNeeded()
        }
    }
    
    private func setupValue() {
        guard let station = self.viewModel.output.getDataStation() else { return }
        if let logoImage = station.provider?.icon, let urlImage = URL(string: "\(logoImage)") {
            logoStationImageView.kf.setImageDefault(with: urlImage)
        }
        titleStationValue.text = station.stationName ?? ""
        adressStationValue.text = station.addr ?? ""
        
        distanceValue.text = "ไม่พบพิกัดผู้ใช้งาน"
        timeValue.text = station.servicetimeOpen ?? ""
        
        descValue.text = station.stationDesc ?? "-"
        serviceCharge.text = "ค่าบริการ \(station.serviceRate ?? 0.0) บาท"
        
        titleRating.text = String(format:"%.1f", station.rating ?? 0.0)
        
        checkMethodService()
        
        reloadStationLocation()
    }
    
    func checkMethodService()  {
        guard let station = self.viewModel.output.getDataStation() else { return }
        self.cbParking.setCheckBox(isSelected: station.isServiceParking ?? false)
        self.cbFoodShop.setCheckBox(isSelected: station.isServiceFood ?? false)
        self.cbCoffeeShop.setCheckBox(isSelected: station.isServiceCoffee ?? false)
        self.cbToilet.setCheckBox(isSelected: station.isServiceRestroom ?? false)
        self.cbMarket.setCheckBox(isSelected: station.isServiceShoping ?? false)
        self.cbSleep.setCheckBox(isSelected: station.isServiceRestarea ?? false)
        self.cbWifi.setCheckBox(isSelected: station.isServiceWifi ?? false)
        self.cbOther.setCheckBox(isSelected: station.isServiceOther ?? false)
    }
    
    func reloadStationLocation() {
        guard let station = self.viewModel.output.getDataStation() else { return }
        if let lat = station.lat, let lng = station.lng {
            let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let marker = GMSMarker(position: position)
            marker.isTappable = true
            marker.iconView =  MarkerStationView.instantiate(station: station, index: 0)
            marker.tracksViewChanges = true
            marker.map = mapView
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 17.0)
            mapView.animate(to: camera)
        }
    }
}

//MARK: - Navigate Flow
extension StationDetailViewController {
    func reloadFavorite() {
        let isFavorite: Bool = viewModel.output.getIsFavorite()
        if isFavorite == true {
            self.btnFavorite.setImage(UIImage(named: "btn_favorite_fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.btnFavorite.tintColor = .basePrimary
        } else {
            self.btnFavorite.setImage(UIImage(named: "btn_favorite")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.btnFavorite.tintColor = .baseTextGray
        }
    }
    
    @objc func handleNavigateButton() {
        openDirectionGoogleMap()
    }
    
    @objc func handleFavoriteButton() {
        guard UserDefaultsKey.UID.string != nil, UserDefaultsKey.isLoggedIn.bool == true else {
            NavigationManager.instance.pushVC(to: .login(self, actionType: .favorite), presentation: .Present(withNav: false))
            return
        }
        
        if viewModel.output.getIsFavorite() == true {
            viewModel.input.deleteFavorite()
        } else {
            viewModel.input.postFavorite()
        }
    }
    
    @objc func handleTapMapLocation() {
        openCenterGoogleMap()
    }
    
    @objc func handleShareButton() {
        guard let station = viewModel.output.getDataStation() else { return }
        if let lat = station.lat, let lng = station.lng {
            let items = [URL(string: "http://maps.google.com/maps?q=\(lat),\(lng)")!]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(ac, animated: true)
        }
    }
    
    func openDirectionGoogleMap() {
        guard let station = viewModel.output.getDataStation() else { return }
        if let lat = station.lat, let lng = station.lng {
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
                if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(lat),\(lng)&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }}
            else {
                //Open in browser
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(lng)&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination)
                }
            }
        }
    }
    
    func openCenterGoogleMap() {
        guard let station = viewModel.output.getDataStation() else { return }
        if let lat = station.lat, let lng = station.lng {
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
                if let url = URL(string: "comgooglemaps-x-callback://?q=&center=\(lat),\(lng)&views=satellite,traffic&zoom=15") {
                    UIApplication.shared.open(url, options: [:])
                }}
            else {
                //Open in browser
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?q=&center=\(lat),\(lng)&views=satellite,traffic&zoom=15") {
                    UIApplication.shared.open(urlDestination)
                }
            }
        }
    }
    
    @objc func handleBtnAddReview() {
        guard UserDefaultsKey.UID.string != nil, UserDefaultsKey.isLoggedIn.bool == true else {
            NavigationManager.instance.pushVC(to: .login(self, actionType: .writeReview), presentation: .Present(withNav: false))
            return
        }
        
        if let stId = viewModel.output.getDataStation()?.stId {
            NavigationManager.instance.pushVC(to: .addReview(stId), presentation: .presentFullScreen(completion: nil))
        }
    }
}

extension StationDetailViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
    }
}

extension StationDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case plugTableView:
            let count = viewModel.output.getNumberOfRowsInSection(tableView, section: section, type: .plugTableView)
            let height = viewModel.output.getItemViewCellHeight(type: .plugTableView)
            plugTableViewHeight.constant = (CGFloat(count)*height)
            return count
        case tableReview:
            let count = viewModel.output.getNumberOfRowsInSection(tableView, section: section, type: .reviewTableView)
            return count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case plugTableView:
            return viewModel.output.getItemViewCell(tableView, indexPath: indexPath, type: .plugTableView)
        case tableReview:
            let cell = viewModel.output.getItemViewCell(tableView, indexPath: indexPath, type: .reviewTableView)
            if indexPath.row == 5 {
//                tableReview.separatorStyle = .none
            } else {
                tableReview.separatorStyle = .singleLine
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case plugTableView:
            return viewModel.output.getItemViewCellHeight(type: .plugTableView)
        case tableReview:
            return viewModel.output.getItemViewCellHeight(type: .reviewTableView)
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}

extension StationDetailViewController: LoginDelegate {
    func didLoginSuccess(actionType: LoginActionType) {
        switch actionType {
        case .writeReview:
            if let stId = viewModel.output.getDataStation()?.stId {
                DispatchQueue.main.async {
                    NavigationManager.instance.pushVC(to: .addReview(stId), presentation: .presentFullScreen(completion: nil))
                }
            }
        case .favorite:
            self.viewModel.input.postFavorite()
        default:
            break
        }
    }
}

extension StationDetailViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }

        if let station = self.viewModel.output.getDataStation(), let lat = station.lat, let lng = station.lng {
            let placeLocation = CLLocation(latitude: lat, longitude: lng)
            let distanceInMeters = location.distance(from: placeLocation)
            let distanceInKiloMeters = distanceInMeters/1000.0
            let timePerMin = distanceInKiloMeters/10.0
            distanceValue.text = String(format: "%0.2f km. (%0.2f นาที)", distanceInKiloMeters, timePerMin)
        }
        
        locationManager.stopUpdatingLocation()
    }
}

extension StationDetailViewController: SheetViewControllerDelegate {
    func sizeModalSheetDidChange(size: SheetSize) {
        self.setBgBottomBar(isHidden: size == .fullscreen ? false : true, isAnimate: true)
    }
}
