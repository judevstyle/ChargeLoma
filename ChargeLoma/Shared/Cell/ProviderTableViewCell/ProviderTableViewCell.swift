//
//  ProviderTableViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 9/2/2565 BE.
//

import UIKit

class ProviderTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descText: UILabel!
    
    static let identifier = "ProviderTableViewCell"
    
    var provider: ProviderData? {
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
        titleText.font = .h3Bold
        titleText.textColor = .baseSecondary
        
        descText.font = .smallText
        descText.textColor = .baseTextGray

    }
    
    func setupValue() {
        titleText.text = provider?.name ?? ""
        descText.text = provider?.desv ?? ""
        
        if let logo = provider?.icon, let urlImage = URL(string: "\(logo)") {
            logoImage.kf.setImageDefault(with: urlImage)
        }
        
    }
    
}
