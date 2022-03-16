//
//  MarkerStationView.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation
import UIKit

class MarkerStationView: UIView {

    @IBOutlet weak var InnerView: UIView!
    @IBOutlet weak var ImageBg: UIImageView!
    @IBOutlet weak var imageAvatar: UIImageView!
    
    public var station: StationData?
    
    static func instantiate(station: StationData?, index: Int) -> MarkerStationView {
        let view: MarkerStationView = initFromNib()
        view.station = station
        
        //Flow Status Marker
        let markerOrange: UIImage? = UIImage(named: "marker_orange")
        let markerGray: UIImage? = UIImage(named: "marker_gray")
        let markerGreen: UIImage? = UIImage(named: "marker_green")
        
        var pinImage: UIImage? = markerGreen
        
        if station?.stationStatus == 3 {
            pinImage = markerGray
            view.imageAvatar.image = UIImage(named: "maintenance")
        } else if station?.stationStatus == 2 {
            pinImage = markerGray
            view.imageAvatar.image = UIImage(named: "soon")
        } else {
            if station?.isFastCharge == true {
                pinImage = markerOrange
            } else {
                pinImage = markerGreen
            }
            
            if let pathImage = station?.provider?.logoLabel, let urlImage = URL(string: "\(pathImage)") {
                view.imageAvatar.kf.setImageDefault(with: urlImage)
            }
            
        }
        
        view.ImageBg.image = pinImage

        return view
    }

}


extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}
