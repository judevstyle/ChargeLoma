//
//  ProfileTableViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 20/1/2565 BE.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    static let identifier = "ProfileTableViewCell"
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.selectionStyle = .none
        titleText.font = .h3Text
        titleText.textColor = .baseTextGray
    }
    
}
