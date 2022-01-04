//
//  ToastManager.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 7/23/21.
//

import Foundation
import UIKit
import Toast_Swift

final class ToastManager: NSObject {
    static var shared = ToastManager()
    
    func toastCallAPI(title: String) {
        let duration: TimeInterval = 2.0
        let position: ToastPosition = .bottom
        if #available(iOS 13.0, *) {
            if let weakSelf = UIApplication.shared.windows.first!.rootViewController?.topMostViewController() {
                weakSelf.view.makeToast(title, duration: duration, position: position)
            }
        } else {
            if let weakSelf = UIApplication.shared.keyWindow!.rootViewController?.topMostViewController() {
                weakSelf.view.makeToast(title, duration: duration, position: position)
            }
        }
    }
}


extension UIViewController {
    @objc func topMostViewController() -> UIViewController {
        // Handling Modal views
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
        // Handling UIViewController's added as subviews to some other views.
        else {
            for view in self.view.subviews
            {
                // Key property which most of us are unaware of / rarely use.
                if let subViewController = view.next {
                    if subViewController is UIViewController {
                        let viewController = subViewController as! UIViewController
                        return viewController.topMostViewController()
                    }
                }
            }
            return self
        }
    }
}

extension UITabBarController {
    override func topMostViewController() -> UIViewController {
        return self.selectedViewController!.topMostViewController()
    }
}

extension UINavigationController {
    override func topMostViewController() -> UIViewController {
        return self.visibleViewController!.topMostViewController()
    }
}
