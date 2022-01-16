//
//  MarkerStationInfoView.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 4/1/2565 BE.
//

import Foundation
import UIKit

class MarkerStationInfoView: UIView {
    
    @IBOutlet weak var InnerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var rateValue: UILabel!
    @IBOutlet weak var rateDesc: UILabel!

    
    func setupUI() {
//        InnerView.setShadowBoxView()
        InnerView.setRounded(rounded: 8)
        
        
        topView.roundedTop(radius: 8)
        bottomView.roundedBottom(radius: 8)
        
        titleText.font = .bodyText
        rateValue.font = .bodyText
        rateDesc.font = .bodyText
        titleText.tintColor = .white
        rateValue.tintColor = .baseTextGray
        rateDesc.tintColor = .baseTextGray
    }
    
    func setupValue(_ item: StationData?) {
        titleText.text = item?.stationName ?? ""
        if let rating = item?.rating {
            rateValue.text = "\(rating)"
        } else {
            rateValue.text = "-"
        }
        rateDesc.text = item?.plugDesc ?? ""
    }
    
}
