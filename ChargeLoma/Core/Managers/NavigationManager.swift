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
    
    //Detail
    case detailStation(_ stId: String)
    
    //SearchStation
    case searchStation(_ delegate: SearchStationViewModelDelegate, type: TypeDirectionMap)
    
    //Profile
    case profile
    
    case mapFilter
    
    case preLogin
    
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
        case .detailStation:
            return "DetailStation"
        case .searchStation:
            return "SearchStation"
        case .profile:
            return "Profile"
        case .mapFilter:
            return "MapFilter"
        case .preLogin:
            return "PreLogin"
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
        case .detailStation:
            return "DetailStationViewController"
        case .searchStation:
            return "SearchStationViewController"
        case .profile:
            return "ProfileViewController"
        case .mapFilter:
            return "MapFilterViewController"
        case .preLogin:
            return "PreLoginViewController"
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
        case .mapFilter:
            return "Filter"
        case .go:
            return "เส้นทาง"
        case .foryou:
            return "สำหรับคุณ"
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
        rootViewcontroller?.hideKeyboardWhenTappedAround()
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            
            switch self {
            case .map:
                appearance.backgroundColor = .clear
            case .searchStation:
                appearance.backgroundColor = .white
            default:
                appearance.backgroundColor = .basePrimary
            }
            appearance.shadowColor = .clear
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
            rootViewcontroller?.navigationController?.navigationBar.layoutIfNeeded()
        }
        
        rootViewcontroller?.navigationController?.navigationBar.tintColor = .white
        
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
        case Present(withNav: Bool = true, modalTransitionStyle: UIModalTransitionStyle = .coverVertical, modalPresentationStyle: UIModalPresentationStyle = .automatic)
        case Root
        case Replace
        case Push
        case ModalNoNav(completion: (() -> Void)?)
        case ModelNav(completion: (() -> Void)?, isFullScreen: Bool = true)
        case presentFullScreen(completion: (() -> Void)?)
        case presentHalfModalAndFullScreen(rootVc: UIViewController, heightHalf: CGFloat, completion: (() -> Void)?)
        case PushInTabbar
    }
    
    init() {
        
    }
    
    func setupWithNavigationController(navigationController: UINavigationController?) {
        if let nav = navigationController {
            self.navigationController = nav
        }
    }
    
    func pushVC(to: NavigationOpeningSender, presentation: Presentation = .Push, isHiddenNavigationBar: Bool = false, animated: Bool = true) {
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
        case .detailStation(let stId):
            if let className = storyboard.instantiateInitialViewController() as? DetailStationViewController {
                className.viewModel.setStId(stId)
                viewController = className
            }
        case .searchStation(let delegate, let type):
            if let className = storyboard.instantiateInitialViewController() as? SearchStationViewController {
                className.viewModel.setDelegate(delegate: delegate, type: type)
                viewController = className
            }
        default:
            viewController = storyboard.instantiateInitialViewController() ?? to.viewController
        }
        
        viewController.navigationItem.title = to.titleNavigation
        
        viewController.hideKeyboardWhenTappedAround()
        
        self.presentVC(viewController: viewController, presentation: presentation, isHiddenNavigationBar: isHiddenNavigationBar, to: to, animated: animated)
    }
    
    private func presentVC(viewController: UIViewController, presentation: Presentation, isHiddenNavigationBar: Bool = false, to: NavigationOpeningSender, animated: Bool = true) {
        if let nav = self.navigationController {
            nav.isNavigationBarHidden = isHiddenNavigationBar
        }
        switch presentation {
        case .Push:
            if (self.navigationController.tabBarController != nil) {
                viewController.hidesBottomBarWhenPushed = true
            }
            
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController.navigationBar.tintColor = .white
            self.navigationController.pushViewController(viewController, animated: animated)
        case .PushInTabbar:
            if (self.navigationController.tabBarController != nil) {
                viewController.hidesBottomBarWhenPushed = false
            }
            
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController.navigationBar.tintColor = .white
            self.navigationController.pushViewController(viewController, animated: animated)
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
        case .presentFullScreen(let completion):
            
            let nav: UINavigationController = UINavigationController(rootViewController: viewController)
            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.isTranslucent = true
            nav.isNavigationBarHidden = true
            
            nav.view.backgroundColor = UIColor.black
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            
            self.navigationController.present(nav, animated: true, completion: completion)
        case .presentHalfModalAndFullScreen(let rootVC, let heightHalf, let completion):

            var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
            halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: rootVC, presentingViewController: viewController)
            viewController.modalPresentationStyle = .custom
            viewController.transitioningDelegate = halfModalTransitioningDelegate
            HalfModalPresentationController.heightModal = heightHalf
            self.navigationController.present(viewController, animated: true, completion: completion)
            
        case .Present(let withNav, let modalTransitionStyle, let modalPresentationStyle):
            if (self.navigationController.tabBarController != nil) {
                viewController.hidesBottomBarWhenPushed = true
            }
            
            if withNav {
                let nav: UINavigationController = UINavigationController(rootViewController: viewController)
                nav.modalTransitionStyle = modalTransitionStyle
                nav.modalPresentationStyle = modalPresentationStyle
                self.navigationController.present(nav, animated: true, completion: {
                    
                })
            } else {
                viewController.modalPresentationStyle = modalPresentationStyle
                viewController.modalPresentationStyle = modalPresentationStyle
                self.navigationController.present(viewController, animated: true, completion: {
                    
                })
            }
            
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
    
    private func getNavigationController(vc: UIViewController, isTranslucent: Bool = false, isFullScreen: Bool = false) -> UINavigationController {
        
        let nav: UINavigationController = UINavigationController(rootViewController: vc)
        
//        if #available(iOS 15.0, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithTransparentBackground()
//            
//            appearance.backgroundColor = .clear
//            appearance.shadowColor = .clear
//            appearance.shadowImage = UIImage()
//            appearance.backgroundImage = UIImage()
//            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.h2Text, NSAttributedString.Key.foregroundColor: UIColor.white]
//            
//            nav.navigationBar.scrollEdgeAppearance = appearance
//            nav.navigationBar.standardAppearance = appearance
//            nav.navigationBar.compactAppearance = appearance
//        } else {
//            
//            nav.navigationBar.barTintColor = UIColor.basePrimary
//            nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.bottom, barMetrics: .default)
//            nav.navigationBar.shadowImage = UIImage()
//            nav.navigationBar.isTranslucent = true
//            nav.navigationBar.isHidden = true
//            nav.navigationBar.barStyle = .black
//            nav.navigationBar.tintColor = .white
//            nav.navigationBar.layoutIfNeeded()
//        }
        

        return nav
    }
    
}
