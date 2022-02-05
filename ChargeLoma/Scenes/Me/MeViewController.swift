//
//  MeViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import UIKit

class MeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationManager.instance.setupWithNavigationController(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard UserDefaultsKey.UID.string != nil, UserDefaultsKey.isLoggedIn.bool == true else {
            debugPrint("sss")
            NavigationManager.instance.pushVC(to: .preLogin, presentation: .PushInTabbar, animated: false)
            return
        }
    }
    
}
