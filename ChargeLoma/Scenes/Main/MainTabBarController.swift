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
        registerNotiSwitchLanguage(selector: #selector(languageDidChange))
        
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
    
    @objc func languageDidChange() {
        debugPrint("Main Tab languageDidChange")
//        localizeTabBar()
    }
    
    deinit {
       removeObserverDeinit()
    }
    
//    func localizeTabBar() {
//        tabBar.items![0].title = Wording.MainTabbar.Home.localized
//        tabBar.items![1].title = Wording.MainTabbar.Go.localized
//        tabBar.items![2].title = Wording.MainTabbar.ForYou.localized
//        tabBar.items![3].title = Wording.MainTabbar.Add.localized
//        tabBar.items![4].title = Wording.MainTabbar.Me.localized
//    }
    
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
        return true
    }
}
