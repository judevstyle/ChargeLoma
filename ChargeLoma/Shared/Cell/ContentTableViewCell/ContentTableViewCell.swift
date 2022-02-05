//
//  ContentTableViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 15/1/2565 BE.
//

import UIKit

class ContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var bgBadge: UIView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var titlsBadge: UILabel!
    
    static let identifier = "ContentTableViewCell"
    
    var item: InformationItem? {
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
        self.bgBadge.setRounded(rounded: self.bgBadge.frame.height/2)
        titleText.font = .bodyBold
        titlsBadge.font = .extraSmallText
    }
    
    func setupValue() {
        titleText.text = item?.title ?? ""
        if let updateDate = item?.updatedDate {
            titlsBadge.isHidden = false
            bgBadge.isHidden = false
            titlsBadge.text = updateDate.convertToDate()?.getFormattedDate(format: "MMM dd, HH:mm")
        } else {
            titlsBadge.isHidden = true
            bgBadge.isHidden = true
        }
        
        if let poster = item?.image, let urlImage = URL(string: "\(poster)") {
            posterImageView.kf.setImageDefault(with: urlImage)
        }
    }
}
