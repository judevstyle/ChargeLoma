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
        
        
        tabBar.tintColor = UIColor.basePrimary
        tabBar.unselectedItemTintColor = UIColor.black
        tabBar.backgroundColor = UIColor.baseTabbarBG
        tabBar.isTranslucent = false
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()

        tabBar.layer.shadowColor = UIColor.darkGray.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = .zero
        tabBar.layer.shadowRadius = 2
        
        let mapVC = tabBarNavigation(unselectImage: UIImage(named: "map"), selectImage: UIImage(named: "map"), title: "แผนที่", badgeValue: nil, navigationTitle: "แผนที่", navigationOpeningSender: .map)

        let goVC = tabBarNavigation(unselectImage: UIImage(named: "car"), selectImage: UIImage(named: "car"), title: "ไป", badgeValue: nil, navigationTitle: "Favorite", navigationOpeningSender: .go)

        let foryouVC = tabBarNavigation(unselectImage: UIImage(named: "passion"), selectImage: UIImage(named: "passion"), title: "สำหรับคุณ", badgeValue: nil, navigationTitle: "", navigationOpeningSender: .foryou)

        let addLocationVC = tabBarNavigation(unselectImage: UIImage(named: "plus"), selectImage: UIImage(named: "plus"), title: "เพิ่มสถานี", badgeValue: nil, navigationTitle: "", navigationOpeningSender: .addlocation)
        
        let meVC = tabBarNavigation(unselectImage: UIImage(named: "user"), selectImage: UIImage(named: "user"), title: "ฉัน", badgeValue: nil, navigationTitle: "", navigationOpeningSender: .addlocation)
        
        viewControllers = [mapVC, goVC, foryouVC, addLocationVC, meVC]
    }
    
    
    fileprivate func tabBarNavigation(unselectImage: UIImage?, selectImage: UIImage?, title: String?, badgeValue: String?,navigationTitle: String?, navigationOpeningSender: NavigationOpeningSender) -> UINavigationController {

        let navController = navigationOpeningSender.navController
        navController.tabBarItem.image = unselectImage
        navController.tabBarItem.selectedImage =  selectImage
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        navController.tabBarItem.title = title
        navController.tabBarItem.badgeColor = .red
        navController.tabBarItem.badgeValue = badgeValue
        navController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.biggerTinyText], for: .normal)

        //navigationController
        
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor.basePrimary
//        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.h2Text, NSAttributedString.Key.foregroundColor: UIColor.white]
//        rootViewcontroller?.navigationController?.navigationBar.standardAppearance = appearance;
//        rootViewcontroller?.navigationController?.navigationBar.scrollEdgeAppearance = rootViewcontroller?.navigationController?.navigationBar.standardAppearance
        
//        if #available(iOS 15.0, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithTransparentBackground()
//            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.h2Text, NSAttributedString.Key.foregroundColor: UIColor.white]
//            appearance.backgroundColor = .clear
//            appearance.shadowImage = UIImage()
//            appearance.backgroundImage = UIImage()
//
//            rootViewcontroller?.navigationController?.navigationBar.scrollEdgeAppearance = appearance
//            rootViewcontroller?.navigationController?.navigationBar.standardAppearance = appearance
//            rootViewcontroller?.navigationController?.navigationBar.compactAppearance = appearance
//        } else {
//            rootViewcontroller?.navigationController?.navigationBar.barTintColor = UIColor.gold
//            rootViewcontroller?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.bottom, barMetrics: .default)
//            rootViewcontroller?.navigationController?.navigationBar.shadowImage = UIImage()
//            rootViewcontroller?.navigationController?.navigationBar.isTranslucent = false
//            rootViewcontroller?.navigationController?.navigationBar.isHidden = true
//            rootViewcontroller?.navigationController?.navigationBar.barStyle = .black
//            rootViewcontroller?.navigationController?.navigationBar.tintColor = .white
//        }
        
        return navController
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
        return true
    }
}
