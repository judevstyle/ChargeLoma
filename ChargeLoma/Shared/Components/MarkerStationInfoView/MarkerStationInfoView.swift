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
        InnerView.setShadowBoxView()
        InnerView.setRounded(rounded: 8)
        
        
        topView.roundedTop(radius: 8)
        bottomView.roundedBottom(radius: 8)
        
        titleText.font = .extraSmallText
        rateValue.font = .extraSmallText
        rateDesc.font = .extraSmallText
        titleText.tintColor = .white
        rateValue.tintColor = .black
        rateDesc.tintColor = .black
    }
    
    func setupValue(_ item: StationData?) {
        titleText.text = item?.stationName ?? ""
        rateValue.text = "\(item?.rating ?? 0.0)"
        rateDesc.text = item?.plugDesc ?? ""
    }
    
}
