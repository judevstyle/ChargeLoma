//
//  RegisterViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 20/1/2565 BE.
//

import UIKit
import Firebase
import GoogleSignIn

public protocol RegisterDelegate {
    func didRegisterSuccess(email: String, password: String)
}

class RegisterViewController: UIViewController {
    
    public var delegate: RegisterDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
