//
//  PlugTableViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 16/1/2565 BE.
//

import UIKit

public protocol PlugTableViewCellDelegate {
    func didHandleDelete(index: Int?)
}

class PlugTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var bgBadge: UIView!
    @IBOutlet weak var titleBadge: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    static let identifier = "PlugTableViewCell"
    
    public var delegate: PlugTableViewCellDelegate?
    public var index: Int?
    
    var itemPlugMapping: PlugMapping? {
        didSet {
            setupValue()
        }
    }
    
    var itemPlugStationData: PlugStationData? {
        didSet {
            setupValue()
        }
    }
    
    var itemPlugTypeData: PlugTypeData? {
        didSet {
            setupValue()
        }
    }
    
    var power: Int? {
        didSet {
            titleBadge.text = "\(power ?? 0) kW"
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
        self.btnDelete.isHidden = true
        btnDelete.addTarget(self, action: #selector(didHandleDelete), for: .touchUpInside)
    }
    
    func setupValue() {
        if let item = itemPlugMapping {
            if let logo = item.plugTypeMaster?.pIcon, let urlImage = URL(string: "\(logo)") {
                imageLogo.kf.setImageDefault(with: urlImage)
            }
            
            titleText.text = item.plugTypeMaster?.pTitle ?? ""
            titleBadge.text = "\(item.power ?? "") kW"
        }
        
        if let item = itemPlugStationData {
            if let logo = item.plugType?.pIcon, let urlImage = URL(string: "\(logo)") {
                imageLogo.kf.setImageDefault(with: urlImage)
            }
            
            titleText.text = item.plugType?.pTitle ?? ""
            titleBadge.text = "\(item.power ?? "") kW"
        }
        
        if let item = itemPlugTypeData {
            if let logo = item.pIcon, let urlImage = URL(string: "\(logo)") {
                imageLogo.kf.setImageDefault(with: urlImage)
            }
            
            titleText.text = item.pTitle ?? ""
            bgBadge.isHidden = true
            titleBadge.isHidden = true
        }
    }
    
    func setBaseBG() {
        self.backgroundColor = .baseBG
        self.setRounded(rounded: 5)
    }
    
    @objc func didHandleDelete() {
        self.delegate?.didHandleDelete(index: self.index)
    }
    
}
