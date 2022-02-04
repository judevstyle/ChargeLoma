//
//  FilterItemTextCollectionViewCell.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 1/2/2565 BE.
//

import UIKit

protocol FilterItemTextCollectionViewCellDelegate {
    func didSelectedCheckMark(vc: UICollectionView, view: CheckBoxView, isSelectedBtn: Bool, index: Int)
}

class FilterItemTextCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FilterItemTextCollectionViewCell"

    @IBOutlet var bgView: UIView!
    @IBOutlet weak var checkbox: CheckBoxView!
    @IBOutlet weak var titleText: UILabel!
    
    public var delegate: FilterItemTextCollectionViewCellDelegate?
    public var vc: UICollectionView!
    
    public var index: Int = 0
    
    var title: String? {
        didSet {
            titleText.text = title ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI(){
        checkbox.delegate = self
    }
    
    public func setIndex(_ index: Int) {
        checkbox.index = index
    }
}

extension FilterItemTextCollectionViewCell: CheckBoxViewDelegate {
    func didSelected(view: CheckBoxView, isSelectedBtn: Bool, index: Int) {
        self.delegate?.didSelectedCheckMark(vc: vc, view: view, isSelectedBtn: isSelectedBtn, index: index)
    }
}
