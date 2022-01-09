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
        var pinImage: UIImage = UIImage(named: "marker_green")!.withRenderingMode(.alwaysOriginal)
        if station?.stationStatus == 3 {
            pinImage = UIImage(named: "marker_gray")!.withRenderingMode(.alwaysOriginal)
        } else {
            if station?.isFastCharge == true {
                pinImage = UIImage(named: "marker_orange")!.withRenderingMode(.alwaysOriginal)
            } else {
                pinImage = UIImage(named: "marker_green")!.withRenderingMode(.alwaysOriginal)
            }
        }
        view.ImageBg.image = pinImage
        

        if let pathImage = station?.provider?.logoLabel, let urlImage = URL(string: "\(pathImage)") {
            view.imageAvatar.kf.setImageDefault(with: urlImage)
        }
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        view.InnerView.addGestureRecognizer(tap)
//        view.InnerView.isUserInteractionEnabled = true
//        view.ImageBg.isUserInteractionEnabled = true
//        view.index = index
        return view
    }
    
//    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//        print("TEST")
//    }
}


extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}
