//
//  MainTabBarController.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        NavigationManager.instance.setupTabbarController(self)
        
        setupUI()
        setupTabbar()
    }
    
    private func setupUI() {
        tabBar.tintColor = UIColor.basePrimary
        tabBar.unselectedItemTintColor = .darkGray
        tabBar.backgroundColor = UIColor.baseTabbarBG
        tabBar.isTranslucent = false
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()

        tabBar.layer.shadowColor = UIColor.darkGray.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = .zero
        tabBar.layer.shadowRadius = 2
    }
    
    private func setupTabbar() {
        NavigationManager.instance.refreshTabbar()
    }

    deinit {
       removeObserverDeinit()
    }
    
}


extension MainTabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.lastIndex(of: viewController)
        switch index {
        case 0:
            UIApplication.shared.statusBarStyle = .darkContent
        default:
            UIApplication.shared.statusBarStyle = .lightContent
        }
        NavigationManager.instance.didSelectTabbar(index: index)
        return true
    }
}
