//
//  BaseAddLocationViewController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 19/2/2565 BE.
//

import UIKit

class BaseAddLocationViewController: UIViewController {

    public var isShouldPushAddlocation: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationManager.instance.setupWithNavigationController(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard UserDefaultsKey.UID.string != nil, UserDefaultsKey.isLoggedIn.bool == true else {
            NavigationManager.instance.pushVC(to: .preLogin, presentation: .PushInTabbar, animated: false)
            return
        }
        if isShouldPushAddlocation {
            NavigationManager.instance.pushVC(to: .addlocation(isFromPushNavigation: true, delegate: self))
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        isShouldPushAddlocation = true
    }
}

extension BaseAddLocationViewController: AddLocationViewControllerDelegate {
    func dismissAddLocationView() {
        isShouldPushAddlocation = false
        NavigationManager.instance.switchLastTabbar()
    }
}
