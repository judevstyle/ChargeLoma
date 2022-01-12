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
    
    var item: PlugTypeData? {
        didSet {
            setupValue()
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
    
    func setupValue(){
        titleText.text = item?.pTitle ?? ""
        
        if let pathImage = item?.pIcon, let urlImage = URL(string: "\(pathImage)") {
            imageLogo.kf.setImageDefault(with: urlImage)
        }
    }
    
}

extension FilterItemCollectionViewCell: CheckBoxViewDelegate {
    func didSelected(view: CheckBoxView, isSelectedBtn: Bool, index: Int) {
        self.delegate?.didSelectedCheckMark(vc: vc, view: view, isSelectedBtn: isSelectedBtn, index: index)
    }
    
}
