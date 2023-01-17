//
//  UINavigationBar+Extension.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 7/1/2565 BE.
//

import Foundation
import UIKit

extension UINavigationBar {

    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}

extension UINavigationController {
    
    func setBarTintColor(color: UIColor, complete: (() -> Void)? = nil) {
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = color
            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            appearance.backgroundImage = UIImage()
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.h2Text, NSAttributedString.Key.foregroundColor: UIColor.white]
            
            self.navigationBar.scrollEdgeAppearance = appearance
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.compactAppearance = appearance
            DispatchQueue.main.async {
                complete?()
            }
        } else {
            
            self.navigationBar.barTintColor = color
            self.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.bottom, barMetrics: .default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.isTranslucent = true
            self.navigationBar.isHidden = true
            self.navigationBar.barStyle = .black
            self.navigationBar.tintColor = .white
            self.navigationBar.layoutIfNeeded()
            
            DispatchQueue.main.async {
                complete?()
            }
        }
    }
    
}
