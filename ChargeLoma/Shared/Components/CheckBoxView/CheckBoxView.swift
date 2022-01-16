//
//  CheckBoxView.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 9/1/2565 BE.
//

import Foundation
import UIKit

protocol CheckBoxViewDelegate {
    func didSelected(view: CheckBoxView, isSelectedBtn: Bool, index: Int)
}

class CheckBoxView: UIView {
    
    let nibName = "CheckBoxView"
    var contentView:UIView?

    @IBOutlet weak var btnCheckBox: UIButton!
    
    public var delegate: CheckBoxViewDelegate?
    
    public var isSelectedBtn: Bool = false
    public var index: Int = 0
    public var isEnableCheckBox = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupUI()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setupUI() {
        self.btnCheckBox.contentHorizontalAlignment = .fill
        self.btnCheckBox.contentVerticalAlignment = .fill
        self.btnCheckBox.addTarget(self, action: #selector(checkMarkTapped(_:)), for: .touchUpInside)
        
        onClickCheckBox()
    }
    
    public func onClickCheckBox() {
        //Default
        if self.isSelectedBtn {
            self.setSelected()
        } else {
            self.setUnselected()
        }
    }
    
    @objc func checkMarkTapped(_ sender: UIButton) {
        if isEnableCheckBox == true {
            UIView.animate(withDuration: 0.1, delay: 0.05, options: .curveLinear, animations: {
                sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

            }) { (success) in
                UIView.animate(withDuration: 0.1, delay: 0.05, options: .curveLinear, animations: {
                    if !self.isSelectedBtn {
                        self.setSelected()
                    } else {
                        self.setUnselected()
                    }
                    self.delegate?
                        .didSelected(view: self, isSelectedBtn: self.isSelectedBtn, index: self.index)
                    sender.transform = .identity
                }, completion: nil)
            }
        }
    }
    
    func setSelected() {
        self.isSelectedBtn = true
        btnCheckBox.setImage(UIImage.init(systemName: "checkmark.square.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnCheckBox.tintColor = .basePrimary
        btnCheckBox.imageView?.contentMode = .scaleAspectFit
    }

    func setUnselected() {
        self.isSelectedBtn = false
        btnCheckBox.setImage(UIImage.init(named: "check-box-empty")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnCheckBox.tintColor = .lightGray
        btnCheckBox.imageView?.contentMode = .scaleAspectFit
    }
    
}
