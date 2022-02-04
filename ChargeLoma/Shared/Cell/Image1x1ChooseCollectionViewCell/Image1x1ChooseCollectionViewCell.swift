//
//  Image1x1ChooseCollectionViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 2/2/2565 BE.
//

import UIKit

class Image1x1ChooseCollectionViewCell: UICollectionViewCell {

    static let identifier = "Image1x1ChooseCollectionViewCell"
    
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        bgView.setRounded(rounded: 5)
    }
}
