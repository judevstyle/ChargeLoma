//
//  SearchResultTableViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 12/1/2565 BE.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultTableViewCell"

    @IBOutlet weak var titleText: UILabel!
    
    var place: PlaceItem? {
        didSet {
            setupValue()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        titleText.font = .smallText
        titleText.textColor = .baseTextGray
    }
    
    private func setupValue() {
        titleText.text = place?.structuredFormatting?.mainText ?? ""
    }
    
}
