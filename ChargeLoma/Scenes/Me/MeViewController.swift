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
    
        NavigationManager.instance.setupWithNavigationController(navigationController: self.navigationController)
        NavigationManager.instance.pushVC(to: .preLogin, presentation: .PushInTabbar, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
    }
    
}
