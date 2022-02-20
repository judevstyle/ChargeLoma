//
//  FavoriteTableViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/1/2565 BE.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class FavoriteTableViewCell: UITableViewCell {
    
    static let identifier = "FavoriteTableViewCell"
    
    @IBOutlet weak var logoMarker: UIImageView!
    @IBOutlet weak var innerMarker: UIImageView!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descText: UILabel!
    @IBOutlet weak var distanceText: UILabel!
    
    @IBOutlet weak var bgBadge: UIView!
    @IBOutlet weak var titleBadge: UILabel!
    
    private let locationManager = CLLocationManager()
    
    var favorite: StationFavoriteData? {
        didSet {
            setupValue()
            setupDistance()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI() {
        bgBadge.setRounded(rounded: 8)
    }
    
    func setupValue() {
        //Flow Status Marker
        let markerOrange: UIImage? = UIImage.imageNamed(name: "marker_orange", cache: true)
        let markerGray: UIImage? = UIImage.imageNamed(name: "marker_gray", cache: true)
        let markerGreen: UIImage? = UIImage.imageNamed(name: "marker_green", cache: true)
        
        var pinImage: UIImage? = markerGreen
        
        if favorite?.station?.stationStatus == 3 {
            pinImage = markerGray
            innerMarker.image = UIImage.imageNamed(name: "maintenance", cache: true)
        } else if favorite?.station?.stationStatus == 2 {
            pinImage = markerGray
            innerMarker.image = UIImage.imageNamed(name: "soon", cache: true)
        } else {
//            if favorite?.station?.isFastCharge == true {
//                pinImage = markerOrange
//            } else {
//                pinImage = markerGreen
//            }
            pinImage = markerOrange
            
            if let pathImage = favorite?.station?.provider?.logoLabel, let urlImage = URL(string: "\(pathImage)") {
                innerMarker.kf.setImageDefault(with: urlImage)
            }
            
        }
        logoMarker.image = pinImage
        
    
        titleText.text = favorite?.station?.stationName ?? ""
        titleText.font = .h3Bold
        titleText.textColor = .baseTextGray
        
        descText.text = favorite?.station?.plugDesc ?? ""
        descText.font = .bodyText
        descText.textColor = .baseTextGray
        
        distanceText.text = ""
        distanceText.font = .smallText
        distanceText.textColor = .baseTextGray
        
        titleBadge.font = .bodyBold
        titleBadge.text = ""
        
        if let rating = favorite?.station?.rating, rating != 0 {
            debugPrint("rating \(rating)")
            titleBadge.text = String(format:"%.1f", rating)
            titleBadge.sizeToFit()
            bgBadge.isHidden = false
        } else {
            bgBadge.isHidden = true
        }
    }
    
    func setupDistance() {
        distanceText.text = ""
        
        //initializing CLLocationManager
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
}

extension FavoriteTableViewCell: CLLocationManagerDelegate {
    
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
        
        if let station = favorite?.station, let lat = station.lat, let lng = station.lng {
            let placeLocation = CLLocation(latitude: lat, longitude: lng)
            let distanceInMeters = location.distance(from: placeLocation)
            let distanceInKiloMeters = distanceInMeters/1000.0
            let unitKm = Wording.StationDetail.StationDetail_Unit_km.localized
            distanceText.text = String(format: "%0.2f \(unitKm).", distanceInKiloMeters)
            distanceText.sizeToFit()
        }
        
        locationManager.stopUpdatingLocation()
    }
}
