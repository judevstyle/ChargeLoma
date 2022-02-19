//
//  UnderlinedTextField.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 19/2/2565 BE.
//

import Foundation
import UIKit

class UnderlinedTextField: UITextField {
    private let defaultUnderlineColor = UIColor.baseTextGray
    private let bottomLine = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        borderStyle = .none
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = defaultUnderlineColor

        self.addSubview(bottomLine)
        bottomLine.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 1).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    public func setUnderlineColor(color: UIColor = .red) {
        bottomLine.backgroundColor = color
    }

    public func setDefaultUnderlineColor() {
        bottomLine.backgroundColor = defaultUnderlineColor
    }
}

extension UnderlinedTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setUnderlineColor(color: .basePrimary)
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        setUnderlineColor(color: .baseTextGray)
    }
}
