//
//  NavigationManager.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import Foundation
import UIKit

public enum NavigationOpeningSender {
    case splash
    case login
    
    //Main Tabbar
    case main
    case map
    case go
    case addlocation
    case foryou
    case me
    
    public var storyboardName: String {
        switch self {
        case .splash:
            return "Splash"
        case .login:
            return "Login"
        case .main:
            return "Main"
        case .map:
            return "Map"
        case .go:
            return "Go"
        case .addlocation:
            return "AddLocation"
        case .foryou:
            return "ForYou"
        case .me:
            return "Me"
        }
    }
    
    public var classNameString: String {
        switch self {
        case .splash:
            return "SplashViewController"
        case .login:
            return "LoginViewController"
        case .main:
            return "MainTabBarController"
        case .map:
            return "MapViewController"
        case .go:
            return "GoViewController"
        case .addlocation:
            return "AddLocationViewController"
        case .foryou:
            return "ForYouViewController"
        case .me:
            return "MeViewController"
        }
    }
    
    public var viewController: UIViewController {
        switch self {
        default:
            return UIViewController()
        }
    }
    
    public var titleNavigation: String {
        switch self {
        default:
            return ""
        }
    }
    
    public var navController: UINavigationController {
        
        let loadingStoryBoard = self.storyboardName
        let storyboard = UIStoryboard(name: loadingStoryBoard, bundle: nil)
        let rootViewcontroller = storyboard.instantiateInitialViewController()
        let navController = UINavigationController(rootViewController: rootViewcontroller ?? UIViewController())
        rootViewcontroller?.navigationItem.title = titleNavigation
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            
            switch self {
            case .map:
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = .clear
            default:
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = .basePrimary
            }
            
            appearance.shadowImage = UIImage()
            appearance.backgroundImage = UIImage()
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.h2Text, NSAttributedString.Key.foregroundColor: UIColor.white]
            
            rootViewcontroller?.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            rootViewcontroller?.navigationController?.navigationBar.standardAppearance = appearance
            rootViewcontroller?.navigationController?.navigationBar.compactAppearance = appearance
        } else {
            
            rootViewcontroller?.navigationController?.navigationBar.barTintColor = UIColor.basePrimary
            rootViewcontroller?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.bottom, barMetrics: .default)
            rootViewcontroller?.navigationController?.navigationBar.shadowImage = UIImage()
            rootViewcontroller?.navigationController?.navigationBar.isTranslucent = true
            rootViewcontroller?.navigationController?.navigationBar.isHidden = true
            rootViewcontroller?.navigationController?.navigationBar.barStyle = .black
            rootViewcontroller?.navigationController?.navigationBar.tintColor = .white
        }
        
        switch self {
        case .map:
            return navController
        default:
            return navController
        }
    }
}

class NavigationManager {
    static let instance:NavigationManager = NavigationManager()
    
    var navigationController: UINavigationController!
    var currentPresentation: Presentation = .Root
    
    enum Presentation {
        case Root
        case Replace
        case Push
        case ModalNoNav(completion: (() -> Void)?)
        case ModelNav(completion: (() -> Void)?, isFullScreen: Bool)
        case PopupSheet(completion: (() -> Void)?)
        case presentFullSceen(completion: (() -> Void)?)
        
    }
    
    init() {
        
    }

    
    func setupWithNavigationController(navigationController: UINavigationController?) {
        if let nav = navigationController {
            self.navigationController = nav
        }
    }
    
    func pushVC(to: NavigationOpeningSender, presentation: Presentation = .Push, isHiddenNavigationBar: Bool = false) {
        let loadingStoryBoard = to.storyboardName
        
        let storyboard = UIStoryboard(name: loadingStoryBoard, bundle: nil)
        var viewController: UIViewController = UIViewController()
        
        switch to {
//        case .productDetailBottomSheet(let items, let delegate):
//            if let className = storyboard.instantiateInitialViewController() as? ProductDetailBottomSheetViewController {
//                className.viewModel.input.setProductItems(items: items)
//                className.viewModel.input.setDelegate(delegate: delegate)
//                viewController = className
//            }
        default:
            viewController = storyboard.instantiateInitialViewController() ?? to.viewController
        }
        
        viewController.navigationItem.title = to.titleNavigation
        
        viewController.hideKeyboardWhenTappedAround()
        
        self.presentVC(viewController: viewController, presentation: presentation, isHiddenNavigationBar: isHiddenNavigationBar, to: to)
    }
    
    private func presentVC(viewController: UIViewController, presentation: Presentation, isHiddenNavigationBar: Bool = false, to: NavigationOpeningSender) {
        if let nav = self.navigationController {
            nav.isNavigationBarHidden = isHiddenNavigationBar
        }
        switch presentation {
        case .Push:
            if (self.navigationController.tabBarController != nil) {
                viewController.hidesBottomBarWhenPushed = true
            }
            
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController.pushViewController(viewController, animated: true)
            
        case .Root:
            let storyboard = UIStoryboard(name: to.storyboardName, bundle: nil)
            let initialViewController = storyboard.instantiateInitialViewController()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        case .ModalNoNav(let completion):
            let vc: UIViewController = viewController
            self.navigationController.present(vc, animated: true, completion: completion)
        case .Replace:
            var viewControllers = Array(self.navigationController.viewControllers.dropLast())
            viewControllers.append(viewController)
            self.navigationController.setViewControllers(viewControllers, animated: true)
        case .ModelNav(let completion, let isFullScreen):
            let nav: UINavigationController = getNavigationController(vc: viewController, isTranslucent: false, isFullScreen: isFullScreen)
            self.navigationController.present(nav, animated: true, completion: completion)
        case .PopupSheet(completion: let completion):
            viewController.view.backgroundColor = UIColor.blackAlpha(alpha: 0.2)
            viewController.modalPresentationStyle = .overFullScreen
            viewController.modalTransitionStyle = .crossDissolve
            self.navigationController.present(viewController, animated: true, completion: completion)
        case .presentFullSceen(let completion):
            
            let nav: UINavigationController = UINavigationController(rootViewController: viewController)
            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.isTranslucent = true
            
            nav.view.backgroundColor = UIColor.black
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            
            self.navigationController.present(nav, animated: true, completion: completion)
        }
        self.currentPresentation = presentation
    }
    
    func setRootViewController(rootView: NavigationOpeningSender, withNav: Bool = true, isTranslucent: Bool = false, isAnimate: Bool = false, options: UIView.AnimationOptions = .curveEaseIn) {
        if isAnimate == true {
            UIView.transition(
                 with: UIApplication.shared.keyWindow!,
                 duration: 0.25,
                 options: options,
                 animations: {
                    let storyboard = UIStoryboard(name: rootView.storyboardName, bundle: nil)
                    if let vc = storyboard.instantiateInitialViewController() {
                        let nav: UINavigationController = self.getNavigationController(vc: vc, isTranslucent: isTranslucent)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        if withNav {
                            appDelegate.window?.rootViewController = nav
                        } else {
                            appDelegate.window?.rootViewController = vc
                        }
                        appDelegate.window?.makeKeyAndVisible()
                    }
             })
        } else {
            let storyboard = UIStoryboard(name: rootView.storyboardName, bundle: nil)
            if let vc = storyboard.instantiateInitialViewController() {
                let nav: UINavigationController = getNavigationController(vc: vc, isTranslucent: isTranslucent)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if withNav {
                    appDelegate.window?.rootViewController = nav
                } else {
                    appDelegate.window?.rootViewController = vc
                }
                appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    private func getNavigationController(vc: UIViewController, isTranslucent: Bool, isFullScreen: Bool = false) -> UINavigationController {
        let nav: UINavigationController = UINavigationController(rootViewController: vc)
        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = isTranslucent == true ? true : false
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.h3Bold, NSAttributedString.Key.foregroundColor: UIColor.white]
        nav.navigationBar.barTintColor = UIColor.gold
        
        if isFullScreen == true {
            nav.modalPresentationStyle = .overFullScreen
        }
        return nav
    }
    
}
