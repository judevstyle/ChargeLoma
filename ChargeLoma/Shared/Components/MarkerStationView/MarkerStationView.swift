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
    @IBOutlet weak var bgTitle: UIView!
    @IBOutlet weak var Title: UILabel!
    
    @IBOutlet weak var ImageBg: UIImageView!
    @IBOutlet weak var imageAvatar: UIImageView!
    
    public var index: Int!
    
    static func instantiate(index: Int, message: String?, imageUrl: String?) -> MarkerStationView {
        let view: MarkerStationView = initFromNib()
        view.ImageBg.image?.withRenderingMode(.alwaysTemplate)
        let pin = UIImage(named: "marker_green")!.withRenderingMode(.alwaysOriginal)
        view.ImageBg.image = pin
//        view.ImageBg.tintColor = UIColor.basePrimary
        
        
        view.imageAvatar.setRounded(rounded: view.imageAvatar.frame.width/2)
        view.imageAvatar.contentMode = .scaleAspectFill
//        if let urlImage = URL(string: "\(DomainNameConfig.TMSImagePath.urlString)\(imageUrl ?? "")") {
//            view.imageAvatar.kf.setImageDefault(with: urlImage)
//        } else {
//            view.imageAvatar.image = UIImage(named: "placeholder")?.withRenderingMode(.alwaysOriginal)
//        }
        
        view.bgTitle.setRounded(rounded: 3)
        view.Title.text = message
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.InnerView.addGestureRecognizer(tap)
        view.InnerView.isUserInteractionEnabled = true
        view.index = index
        return view
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        print("TEST")
    }
}


extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}
