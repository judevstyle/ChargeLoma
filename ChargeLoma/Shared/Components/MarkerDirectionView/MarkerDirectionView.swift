//
//  MarkerDirectionView.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 17/1/2565 BE.
//

import Foundation
import UIKit

class MarkerDirectionView: UIView {


    @IBOutlet weak var InnerView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    
    static func instantiate() -> MarkerDirectionView {
        let view: MarkerDirectionView = initFromNib()
        var pinImage: UIImage = UIImage(named: "pin-marker")!.withRenderingMode(.alwaysOriginal)
        view.bgImage.image = pinImage
        return view
    }
}
