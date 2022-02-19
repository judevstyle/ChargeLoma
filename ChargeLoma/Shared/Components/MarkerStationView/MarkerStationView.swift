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
        let markerOrange: UIImage? = UIImage.imageNamed(name: "marker_orange", cache: true)
        let markerGray: UIImage? = UIImage.imageNamed(name: "marker_gray", cache: true)
        let markerGreen: UIImage? = UIImage.imageNamed(name: "marker_green", cache: true)
        
        var pinImage: UIImage? = markerGreen
        if station?.stationStatus == 3 {
            pinImage = markerGray
        } else {
            if station?.is24hr == true {
                pinImage = markerOrange
            } else {
                pinImage = markerGreen
            }
        }
        view.ImageBg.image = pinImage
        

        if let pathImage = station?.provider?.logoLabel, let urlImage = URL(string: "\(pathImage)") {
            view.imageAvatar.kf.setImageDefault(with: urlImage)
        }

        return view
    }

}


extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}
