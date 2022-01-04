//
//  KeyboardListener.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 6/15/21.
//

import UIKit

protocol KeyboardListener: class {
    func registerKeyboardObserver()
    func keyboardDidUpdate(keyboardHeight: CGFloat)
    func removeObserver()
}
