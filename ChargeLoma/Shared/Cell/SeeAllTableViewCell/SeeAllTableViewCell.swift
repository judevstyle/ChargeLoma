//
//  SeeAllTableViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 2/2/2565 BE.
//

import UIKit

class SeeAllTableViewCell: UITableViewCell {
    
    static let identifier = "SeeAllTableViewCell"

    @IBOutlet weak var buttonSeeAll: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var title: String? {
        didSet {
            buttonSeeAll.setTitle("\(title ?? "")", for: .normal)
        }
    }
    
    func setupUI() {
        buttonSeeAll.titleLabel?.font = .bodyText
        buttonSeeAll.titleLabel?.textColor = .basePrimary
    }

    @IBAction func didSeeAll(_ sender: Any) {
    }
}
