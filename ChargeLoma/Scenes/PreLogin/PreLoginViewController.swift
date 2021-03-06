//
//  PreLoginViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 15/1/2565 BE.
//

import UIKit

class PreLoginViewController: UIViewController {

 
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.hidesBackButton = true
        
        guard UserDefaultsKey.UID.string == nil, UserDefaultsKey.isLoggedIn.bool == false else {
            self.navigationController?.popViewController(animated: true)
            return
        }
    }

}

extension PreLoginViewController {
    func setupUI() {
        self.titleText.text = "Charge Loma"
        self.titleText.font = .header2
        self.titleText.textColor = .baseSecondary
        
        self.btnLogin.setTitle("เข้าสู่ระบบ", for: .normal)
        self.btnLogin.titleLabel?.font = .h3Text
        
        self.btnLogin.setRounded(rounded: 8.0)
        
        self.btnLogin.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    @objc func handleLogin() {
        NavigationManager.instance.pushVC(to: .login(self, actionType: .unknown), presentation: .Present(withNav: false))
    }
}

extension PreLoginViewController: LoginDelegate {
    func didLoginSuccess(actionType: LoginActionType) {
        debugPrint("Login Success")
        self.navigationController?.popViewController(animated: true)
    }
}
