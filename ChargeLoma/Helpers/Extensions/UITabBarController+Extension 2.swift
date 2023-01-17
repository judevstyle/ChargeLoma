//
//  UITabBarController+Extension.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 16/2/2565 BE.
//

import Foundation
import UIKit

extension UITabBarController {
    
    func registerNotiSwitchLanguage(selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: .LanguageDidChange, object: nil)
    }
    
    func removeObserverDeinit() {
        NotificationCenter.default.removeObserver(self)
    }
}
