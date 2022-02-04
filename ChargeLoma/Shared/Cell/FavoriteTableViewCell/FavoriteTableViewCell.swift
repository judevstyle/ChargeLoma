//
//  FavoriteTableViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/1/2565 BE.
//

import UIKit
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
    
    var favorite: StationFavoriteData? {
        didSet {
            setupValue()
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
        var pinImage: UIImage = UIImage(named: "marker_green")!.withRenderingMode(.alwaysOriginal)
        if favorite?.station?.stationStatus == 3 {
            pinImage = UIImage(named: "marker_gray")!.withRenderingMode(.alwaysOriginal)
        } else {
            if favorite?.station?.is24hr == true {
                pinImage = UIImage(named: "marker_orange")!.withRenderingMode(.alwaysOriginal)
            } else {
                pinImage = UIImage(named: "marker_green")!.withRenderingMode(.alwaysOriginal)
            }
        }
        logoMarker.image = pinImage
        

        if let pathImage = favorite?.station?.provider?.logoLabel, let urlImage = URL(string: "\(pathImage)") {
            innerMarker.kf.setImageDefault(with: urlImage)
        }
    
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
        
        if let rating = favorite?.station?.rating, rating != 0 {
            titleBadge.text = String(format:"%.1f", rating)
        } else {
            bgBadge.isHidden = true
        }
        
    }
    
}
