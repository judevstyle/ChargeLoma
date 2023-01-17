//
//  TopReviewTableViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 17/2/2565 BE.
//

import UIKit

class TopReviewTableViewCell: UITableViewCell {

    static let identifier = "TopReviewTableViewCell"
    
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countReview: UILabel!
    
    public var index: Int = 0
    
    var item: TopReviewData? {
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
    
    private func setupUI() {
        noLabel.font = .bodyText
        noLabel.textColor = .white
        
        nameLabel.font = .bodyBold
        nameLabel.textColor = .basePrimary
        
        countReview.font = .bodyText
        countReview.textColor = .baseTextGray
        
        userImage.setPlaceholderImageView()
        userImage.setRounded(rounded: userImage.frame.width/2)
    }
    
    func setupValue() {
        noLabel.text = "\(self.index+1)"
        nameLabel.text = item?.User?.displayName ?? ""
        countReview.text = "\(item?.countReview ?? 0) ครั้ง"
        
        if (item?.User?.avatar?.length())! < 40 {
            if let logo = item?.User?.avatar, let urlImage = URL(string: "https://api.chargeloma.com/\(logo)") {
                userImage.kf.setImageDefault(with: urlImage)
            }
        }else{
            if let logo = item?.User?.avatar, let urlImage = URL(string: "\(logo)") {
                userImage.kf.setImageDefault(with: urlImage)
            }
            
        }
            
       
    }
    
}
