//
//  ModalAddPowerViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 13/2/2565 BE.
//

import UIKit

public protocol ModalAddPowerViewControllerDelegate {
    func didSubmitPower(power: Int)
}

class ModalAddPowerViewController: UIViewController {
    
    @IBOutlet weak var viewTopModal: UIView!
    @IBOutlet weak var viewBottomModal: UIView!
    @IBOutlet weak var headPower: UILabel!
    @IBOutlet weak var inputPower: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    public var delegate: ModalAddPowerViewControllerDelegate?
    
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerKeyboardObserver()
    }
    
    deinit {
       removeObserver()
    }

    private func setupUI() {
        viewTopModal.roundedTop(radius: 5)
        viewBottomModal.roundedBottom(radius: 5)
        
        btnCancel.setRounded(rounded: 5)
        btnCancel.titleLabel?.font = .bodyText
        btnCancel.tintColor = .basePrimary
        btnCancel.setBorder(width: 1.0, color: .basePrimary)
        btnCancel.setTitle("ยกเลิก", for: .normal)
        
        btnSubmit.setRounded(rounded: 5)
        btnSubmit.titleLabel?.font = .bodyText
        btnSubmit.tintColor = .white
        btnSubmit.setTitle("ยืนยัน", for: .normal)
        
        inputPower.setRounded(rounded: 5)
        inputPower.font = .bodyText
        inputPower.setPaddingLeft(padding: 8)
        inputPower.setPaddingRight(padding: 8)
        
        headPower.font = .bodyText
        headPower.textColor = .baseTextGray
        headPower.text = "กำลังไฟฟ้า (kW)"
        
        btnCancel.addTarget(self, action: #selector(didHandleCancel), for: .touchUpInside)
        btnSubmit.addTarget(self, action: #selector(didHandleSubmit), for: .touchUpInside)
    }
    
    @objc func didHandleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didHandleSubmit() {
        if let powerText = self.inputPower.text, let power = Int(powerText) {
            self.delegate?.didSubmitPower(power: power)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension ModalAddPowerViewController : KeyboardListener {
    func keyboardDidUpdate(keyboardHeight: CGFloat) {
        bottomHeight.constant = keyboardHeight
    }
}
