//
//  FilterItemCollectionViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 9/1/2565 BE.
//

import UIKit

protocol FilterItemCollectionViewCellDelegate {
    func didSelectedCheckMark(vc: UICollectionView, view: CheckBoxView, isSelectedBtn: Bool, index: Int)
}

class FilterItemCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FilterItemCollectionViewCell"
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var checkbox: CheckBoxView!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    
    public var delegate: FilterItemCollectionViewCellDelegate?
    public var vc: UICollectionView!
    
    public var index: Int = 0
    
    var title: String? {
        didSet {
            titleText.text = title ?? ""
        }
    }
    
    var logoImage: String? {
        didSet {
            if let pathImage = logoImage, let urlImage = URL(string: "\(pathImage)") {
                imageLogo.kf.setImageDefault(with: urlImage)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI(){
        checkbox.delegate = self
//        bgView.backgroundColor = .gold
    }
    
    public func setIndex(_ index: Int) {
        checkbox.index = index
    }
    
}

extension FilterItemCollectionViewCell: CheckBoxViewDelegate {
    func didSelected(view: CheckBoxView, isSelectedBtn: Bool, index: Int) {
        self.delegate?.didSelectedCheckMark(vc: vc, view: view, isSelectedBtn: isSelectedBtn, index: index)
    }
}
