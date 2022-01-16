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
    
    @IBOutlet weak var titleLogo: UILabel!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        inputUsername.setRounded(rounded: 8)
        inputUsername.backgroundColor = UIColor.baseBG
        inputPassword.setRounded(rounded: 8)
        inputPassword.backgroundColor = UIColor.baseBG
        
        let attributedUsername = NSAttributedString(
            string: "อีเมล",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.basePrimary, NSAttributedString.Key.font: UIFont.h3Text]
        )
        
        let attributedPassword = NSAttributedString(
            string: "รหัสผ่าน",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.basePrimary, NSAttributedString.Key.font: UIFont.h3Text]
        )
        inputUsername.attributedPlaceholder = attributedUsername
        inputPassword.attributedPlaceholder = attributedPassword
        inputUsername.textAlignment = .center
        inputPassword.textAlignment = .center
        
        self.titleLogo.text = "Charge Loma"
        self.titleLogo.font = .header1
        self.titleLogo.textColor = .baseSecondary
        
        self.btnRegister.setTitle("Register", for: .normal)
        self.btnRegister.titleLabel?.font = .h3Text
        self.btnRegister.titleLabel?.textColor = .basePrimary
        
        self.btnLogin.setTitle("เข้าสู่ระบบ", for: .normal)
        self.btnLogin.titleLabel?.font = .h3Text
        
        self.btnLogin.setRounded(rounded: 8.0)
        
        self.btnLogin.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    @objc func handleLogin() {
       
    }
}
