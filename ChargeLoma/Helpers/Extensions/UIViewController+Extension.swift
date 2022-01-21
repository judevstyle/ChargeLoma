//
//  UIViewController+Extension.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 3/26/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import NVActivityIndicatorViewExtended

extension UIViewController {
    
    func errorDialog(title: String, message: String) {
        let dialogMessage = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default,  handler: { (action) -> Void in
            
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    func ToastMsg(msg:String) {
        self.view.makeToast("\(msg)", duration: 1.5, position: .bottom)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

extension UIViewController: NVActivityIndicatorViewable {
    
    func startLoding() {
        let size = CGSize(width: 35.0, height: 35.0)
        startAnimating(size, message: "", type: .circleStrokeSpin, color: UIColor.basePrimary, backgroundColor: .blackAlpha(alpha: 0.0), textColor: .white, fadeInAnimation: nil)
    }
    
    func stopLoding() {
        stopAnimating()
    }
    
    
    func startLodingCircle() {
        let size = CGSize(width: 35.0, height: 35.0)
        startAnimating(size, message: "", type: .circleStrokeSpin,color: .whiteAlpha(alpha: 0.7), backgroundColor: .blackAlpha(alpha: 0.3), textColor: .white, fadeInAnimation: nil)
    }
}


// MARK: - KeyboardListener
extension UIViewController {
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            if let keyboardLister = self as? KeyboardListener {
                keyboardLister.keyboardDidUpdate(keyboardHeight: .zero)
            }
        } else {
            if let keyboardLister = self as? KeyboardListener {
                keyboardLister.keyboardDidUpdate(keyboardHeight: keyboardViewEndFrame.height - view.safeAreaInsets.bottom)
            }
        }
    }
    
    func registerKeyboardObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}
