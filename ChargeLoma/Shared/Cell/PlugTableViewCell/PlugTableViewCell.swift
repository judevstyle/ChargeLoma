//
//  PlugTableViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 16/1/2565 BE.
//

import UIKit

class PlugTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var bgBadge: UIView!
    @IBOutlet weak var titleBadge: UILabel!
    
    static let identifier = "PlugTableViewCell"
    
    var item: PlugMapping? {
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

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.titleText.font = .h3Text
        self.titleText.textColor = .baseTextGray
        self.bgBadge.setRounded(rounded: 8)
        self.titleBadge.font = .h3Text
    }
    
    func setupValue() {
        if let logo = item?.plugTypeMaster?.pIcon, let urlImage = URL(string: "\(logo)") {
            imageLogo.kf.setImageDefault(with: urlImage)
        }
        
        titleText.text = item?.plugTypeMaster?.pTitle ?? ""
        titleBadge.text = "\(item?.power ?? "") kW"
    }
}
