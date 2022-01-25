//
//  ImageListCollectionViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 22/1/2565 BE.
//

import UIKit

class ImageListCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageListCollectionViewCell"
    
    @IBOutlet weak var imageStation: UIImageView!
    
    var imageUrl: String? {
        didSet {
            setupImage()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupImage() {
        guard let imageUrl = imageUrl, let urlImage = URL(string: "\(imageUrl)") else { return }
        imageStation.kf.setImageDefault(with: urlImage)
    }

}
