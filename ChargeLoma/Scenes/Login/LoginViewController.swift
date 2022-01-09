//
//  LoginViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 9/1/2565 BE.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        inputUsername.setRounded(rounded: 8)
        inputPassword.setRounded(rounded: 8)
        btnLogin.setRounded(rounded: 8)
        btnFacebook.setRounded(rounded: 8)
        btnGoogle.setRounded(rounded: 8)
        btnApple.setRounded(rounded: 8)
    }
}
