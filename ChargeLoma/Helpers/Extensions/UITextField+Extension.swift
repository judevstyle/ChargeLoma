//
//  UITextField+Extension.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 13/1/2565 BE.
//

import Foundation
import UIKit

extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector,setDate: Date) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        datePicker.locale = Locale(identifier: "th")
        datePicker.setDate(setDate, animated: false)
        self.inputView = datePicker //3
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    func setInputViewTimePicker(target: Any, selector: Selector,setDate: Date) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = UIDatePicker.Mode.time
        datePicker.locale = Locale(identifier: "da_DK")
        datePicker.setDate(setDate, animated: false)
        self.inputView = datePicker //3
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    

    
    func setPaddingLeft(padding: CGFloat){
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 5))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    
    func setPaddingRight(padding: CGFloat){
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 5))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setTextFieldBottom() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
    }
    
}
