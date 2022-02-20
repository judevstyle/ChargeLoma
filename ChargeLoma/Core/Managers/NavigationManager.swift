//
//  NavigationManager.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import Foundation
import UIKit
import FittedSheets

public enum NavigationOpeningSender {
    case splash
    case login(_ delegate: LoginDelegate, actionType: LoginActionType)
    
    //Main Tabbar
    case main
    case map
    case go
    case addlocation(stationData: StationData? = nil, isFromPushNavigation: Bool = false, delegate: AddLocationViewControllerDelegate? = nil)
    case foryou
    case me
    
    //Detail
    case stationDetail(_ stId: String, isFromPushNavigation: Bool)
    
    //SearchStation
    case searchStation(_ delegate: SearchStationViewModelDelegate, type: TypeDirectionMap)
    
    //Profile
    case profile
    
    case mapFilter
    
    case preLogin
    
    case galleryPhoto(listImage: [String])
    
    case imageListFullScreen(listImage: [String], index: Int?)
    
    case addReview(_ stId: String, delegate: AddReviewViewControllerDelegate? = nil)
    
    case choosePlug(_ stId: String, delegate: ChoosePlugViewModelDelegate)
    
    case seeAllReview(items: [ReviewData]? = [], uid: String? = nil)
    
    case informationDetail(item: InformationItem?)
    
    case chooseProvider(items: [ProviderData]? = nil, delegate: ChooseProviderViewModelDelegate)
    
    case seeAllFavorite
    
    case selectCurrentLocation(delegate: SelectCurrentLocationViewControllerDelegate)
    
    case modalAddPower(delegate: ModalAddPowerViewControllerDelegate)
    
    case switchLanguage
    
    case usersHit
    
    case about
    
    case editProfile(isRegister: Bool, delegate: EditProfileViewControllerDelegate? = nil)
    
    case baseAddLocation
    
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
        case .searchStation:
            return "SearchStation"
        case .profile:
            return "Profile"
        case .mapFilter:
            return "MapFilter"
        case .preLogin:
            return "PreLogin"
        case .galleryPhoto:
            return "GalleryPhoto"
        case .stationDetail:
            return "StationDetail"
        case .imageListFullScreen:
            return "ImageListFullScreen"
        case .addReview:
            return "AddReview"
        case .choosePlug:
            return "ChoosePlug"
        case .seeAllReview:
            return "SeeAllReview"
        case .informationDetail:
            return "InformationDetail"
        case .chooseProvider:
            return "ChooseProvider"
        case .seeAllFavorite:
            return "SeeAllFavorite"
        case .selectCurrentLocation:
            return "SelectCurrentLocation"
        case .modalAddPower:
            return "ModalAddPower"
        case .switchLanguage:
            return "SwitchLanguage"
        case .usersHit:
            return "UsersHit"
        case .about:
            return "About"
        case .editProfile:
            return "EditProfile"
        case .baseAddLocation:
            return "BaseAddLocation"
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
        case .searchStation:
            return "SearchStationViewController"
        case .profile:
            return "ProfileViewController"
        case .mapFilter:
            return "MapFilterViewController"
        case .preLogin:
            return "PreLoginViewController"
        case .galleryPhoto:
            return "GalleryPhotoViewController"
        case .stationDetail:
            return "StationDetailViewController"
        case .imageListFullScreen:
            return "ImageListFullScreenViewController"
        case .addReview:
            return "AddReviewViewController"
        case .choosePlug:
            return "ChoosePlugViewController"
        case .seeAllReview:
            return "SeeAllReviewViewController"
        case .informationDetail:
            return "InformationDetailViewController"
        case .chooseProvider:
            return "ChooseProviderViewController"
        case .seeAllFavorite:
            return "SeeAllFavoriteViewController"
        case .selectCurrentLocation:
            return "SelectCurrentLocationViewController"
        case .modalAddPower:
            return "ModalAddPowerViewController"
        case .switchLanguage:
            return "SwitchLanguageViewController"
        case .usersHit:
            return "UsersHitViewController"
        case .about:
            return "AboutViewController"
        case .editProfile:
            return "EditProfileViewController"
        case .baseAddLocation:
            return "BaseAddLocationViewController"
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
            return Wording.NavigationTitle.NavigationTitle_Filter.localized
        case .go:
            return Wording.NavigationTitle.NavigationTitle_Go.localized
        case .foryou:
            return Wording.NavigationTitle.NavigationTitle_ForYou.localized
        case .galleryPhoto:
            return Wording.NavigationTitle.NavigationTitle_GalleryPhoto.localized
        case .profile:
            return Wording.NavigationTitle.NavigationTitle_Profile.localized
        case .addReview:
            return Wording.NavigationTitle.NavigationTitle_Review.localized
        case .choosePlug:
            return Wording.NavigationTitle.NavigationTitle_ChoosePlugType.localized
        case .seeAllReview:
            return Wording.NavigationTitle.NavigationTitle_Review.localized
        case .informationDetail:
            return Wording.NavigationTitle.NavigationTitle_InformationDetail.localized
        case .addlocation:
            return Wording.NavigationTitle.NavigationTitle_AddStation.localized
        case .seeAllFavorite:
            return Wording.NavigationTitle.NavigationTitle_Favorite.localized
        case .selectCurrentLocation:
            return Wording.NavigationTitle.NavigationTitle_SelectCurrentLocation.localized
        case .about:
            return Wording.NavigationTitle.NavigationTitle_About.localized
        case .editProfile:
            return Wording.NavigationTitle.NavigationTitle_EditProfile.localized
        case .usersHit:
            return Wording.NavigationTitle.NavigationTitle_TopReview.localized
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
    
    public var navColor: UIColor {
        switch self {
        case .galleryPhoto, .addReview, .choosePlug, .addlocation:
            return .basePrimary
        default:
            return .clear
        }
    }
}

class NavigationManager {
    static let instance:NavigationManager = NavigationManager()
    
    var navigationController: UINavigationController!
    var rootViewController: UIViewController!
    var currentPresentation: Presentation = .Root
    var mainTabBarController: UITabBarController!
    public var lastIndexTabbar: Int = 0
    public var selectedIndexTabbar: Int = 0
    
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
        case PushStationDetail
        case switchTabbar(index: Int)
        case presentModelHeight(completion: (() -> Void)?, height: CGFloat)
        case presentBackground
    }
    
    init() {
        
    }
    
    func setupWithNavigationController(_ vc: UIViewController?) {
        if let nav = vc?.navigationController {
            self.navigationController = nav
        }
        
        if let vc = vc {
            self.rootViewController = vc
        }
    }
    
    func setupTabbarController(_ tabbar: UITabBarController?) {
        self.mainTabBarController = tabbar
    }
    
    func refreshTabbar() {
        let mapVC = getTabbarNavigation(logoImage: "map", title: Wording.MainTabbar.Home.localized, sender: .map)
        let goVC = getTabbarNavigation(logoImage: "car", title: Wording.MainTabbar.Go.localized, sender: .go)
        let foryouVC = getTabbarNavigation(logoImage: "passion", title: Wording.MainTabbar.ForYou.localized, sender: .foryou)
        let addLocationVC = getTabbarNavigation(logoImage: "plus", title: Wording.MainTabbar.Add.localized, sender: .baseAddLocation)
        let meVC = getTabbarNavigation(logoImage: "user", title: Wording.MainTabbar.Me.localized, sender: .me)
        self.mainTabBarController.viewControllers = [mapVC, goVC, foryouVC, addLocationVC, meVC]
    }
    
    private func getTabbarNavigation(logoImage: String, title: String, sender: NavigationOpeningSender) -> UINavigationController {
      return  tabBarNavigation(unselectImage: UIImage(named: logoImage), selectImage: UIImage(named: logoImage), title: title, badgeValue: nil, navigationTitle: "", navigationOpeningSender: sender)
    }
    
    fileprivate func tabBarNavigation(unselectImage: UIImage?, selectImage: UIImage?, title: String?, badgeValue: String?,navigationTitle: String?, navigationOpeningSender: NavigationOpeningSender) -> UINavigationController {

        let navController = navigationOpeningSender.navController
        navController.tabBarItem.image = unselectImage
        navController.tabBarItem.selectedImage =  selectImage
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 8, right: 0)
        navController.tabBarItem.title = title
        navController.tabBarItem.badgeColor = .red
        navController.tabBarItem.badgeValue = badgeValue
        navController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.smallText], for: .normal)
        return navController
    }
    
    func pushVC(to: NavigationOpeningSender, presentation: Presentation = .Push, isHiddenNavigationBar: Bool = false, animated: Bool = true) {
        let loadingStoryBoard = to.storyboardName
        
        let storyboard = UIStoryboard(name: loadingStoryBoard, bundle: nil)
        var viewController: UIViewController = UIViewController()
        
        switch to {
        case .login(let delegate, let actionType):
            if let className = storyboard.instantiateInitialViewController() as? LoginViewController {
                className.delegate = delegate
                className.actionType = actionType
                viewController = className
            }
        case .stationDetail(let stId, let isFromPushNavigation):
            if let className = storyboard.instantiateInitialViewController() as? StationDetailViewController {
                className.viewModel.setStId(stId)
                className.isFromPushNavigation = isFromPushNavigation
                viewController = className
            }
        case .searchStation(let delegate, let type):
            if let className = storyboard.instantiateInitialViewController() as? SearchStationViewController {
                className.viewModel.setDelegate(delegate: delegate, type: type)
                viewController = className
            }
        case .imageListFullScreen(let listImage ,let index):
            if let className = storyboard.instantiateInitialViewController() as? ImageListFullScreenViewController {
                className.viewModel.setListImage(listImage: listImage)
                className.viewModel.setSelectedIndex(index: index)
                viewController = className
            }
        case .galleryPhoto(let listImage):
            if let className = storyboard.instantiateInitialViewController() as? GalleryPhotoViewController {
                className.listImageStation = listImage
                viewController = className
            }
        case .choosePlug(let stId, let delegate):
            if let className = storyboard.instantiateInitialViewController() as? ChoosePlugViewController {
                className.viewModel.setupPrepare(stId, delegate: delegate)
                viewController = className
            }
        case .addReview(let stId, let delegate):
            if let className = storyboard.instantiateInitialViewController() as? AddReviewViewController {
                className.viewModel.setStId(stId)
                className.delegate = delegate
                viewController = className
            }
        case .seeAllReview(let items, let uid):
            if let className = storyboard.instantiateInitialViewController() as? SeeAllReviewViewController {
                className.viewModel.setListReview(items: items)
                className.viewModel.setUID(uid: uid)
                viewController = className
            }
        case .informationDetail(let item):
            if let className = storyboard.instantiateInitialViewController() as? InformationDetailViewController {
                className.informationItem = item
                viewController = className
            }
        case .chooseProvider(let items, let delegate):
            if let className = storyboard.instantiateInitialViewController() as? ChooseProviderViewController {
                className.viewModel.input.setupPrepare(delegate: delegate)
                className.viewModel.input.setProviderMaster(listProvider: items ?? [])
                viewController = className
            }
        case .modalAddPower(let delegate):
            if let className = storyboard.instantiateInitialViewController() as? ModalAddPowerViewController {
                className.delegate = delegate
                viewController = className
            }
        case .selectCurrentLocation(let delegate):
            if let className = storyboard.instantiateInitialViewController() as? SelectCurrentLocationViewController {
                className.delegate = delegate
                viewController = className
            }
        case .editProfile(let isRegister, let delegate):
            if let className = storyboard.instantiateInitialViewController() as? EditProfileViewController {
                className.isRegister = isRegister
                className.delegate = delegate
                viewController = className
            }
        case .addlocation(let stationData, let isFromPushNavigation, let delegate):
            if let className = storyboard.instantiateInitialViewController() as? AddLocationViewController {
                className.isFromPushNavigation = isFromPushNavigation
                className.delegate = delegate
                className.viewModel.input.setStationData(stationData: stationData)
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
            self.pushViewController(vc: viewController, animated: animated, to: to)
        case .PushStationDetail:
            
            if (self.navigationController.tabBarController != nil) {
                viewController.hidesBottomBarWhenPushed = true
            }
            self.pushViewController(vc: viewController, animated: animated, to: to)
            
        case .PushInTabbar:
            if (self.navigationController.tabBarController != nil) {
                viewController.hidesBottomBarWhenPushed = false
            }
            let topVC = UIApplication.getTopViewController()
            if let nav = topVC?.navigationController {
                nav.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                nav.navigationBar.tintColor = .white
                nav.pushViewController(viewController, animated: animated)
            } else {
                self.navigationController.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                self.navigationController.navigationBar.tintColor = .white
                self.navigationController.pushViewController(viewController, animated: animated)
            }
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
            let nav: UINavigationController = self.getNavigationController(vc: viewController, to: to)
            nav.view.backgroundColor = UIColor.black
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            let topVC = UIApplication.getTopViewController()
            topVC?.present(nav, animated: true, completion: completion)
        case .presentHalfModalAndFullScreen(let rootVC, let heightHalf, let completion):
            let nav = self.getNavigationController(vc: viewController)
            
            let options: SheetOptions = SheetOptions(pullBarHeight: 36, useInlineMode: nil)
            let sheet = SheetViewController(
                controller: nav,
                sizes: [.fixed(heightHalf), .fullscreen],
                options: options)
            sheet.delegate = viewController as? SheetViewControllerDelegate
            sheet.overlayColor = .clear
            
            let topVC = UIApplication.getTopViewController()
            topVC?.present(sheet, animated: true, completion: completion)
        case .Present(let withNav, let modalTransitionStyle, let modalPresentationStyle):
            if (self.navigationController.tabBarController != nil) {
                viewController.hidesBottomBarWhenPushed = true
            }
            
            if withNav {
                let nav: UINavigationController = self.getNavigationController(vc: viewController, to: to)
                nav.modalTransitionStyle = modalTransitionStyle
                nav.modalPresentationStyle = modalPresentationStyle
                
                let topVC = UIApplication.getTopViewController()
                topVC?.present(nav, animated: true, completion: nil)
            } else {
                viewController.modalTransitionStyle = modalTransitionStyle
                viewController.modalPresentationStyle = modalPresentationStyle
                let topVC = UIApplication.getTopViewController()
                topVC?.present(viewController, animated: true, completion: nil)
            }
            
        case .switchTabbar(index: let index):
            self.mainTabBarController.selectedIndex = index
        case .presentModelHeight(let completion, let height):
            let options: SheetOptions = SheetOptions(pullBarHeight: 0, useInlineMode: nil)
            let sheet = SheetViewController(
                controller: viewController,
                sizes: [.fixed(height)],
                options: options)
            sheet.overlayColor = UIColor.black.withAlphaComponent(0.5)
            let topVC = UIApplication.getTopViewController()
            topVC?.present(sheet, animated: true, completion: completion)
        case .presentBackground:
            let nav: UINavigationController = self.getNavigationController(vc: viewController, to: to)
            nav.view.backgroundColor = UIColor.black
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            let topVC = UIApplication.getTopViewController()
            topVC?.present(nav, animated: true, completion: nil)
        }
        self.currentPresentation = presentation
    }
    
    func switchTabbar(index: Int) {
        self.presentVC(viewController: UIViewController(), presentation: .switchTabbar(index: index), to: .splash)
    }
    
    func switchLastTabbar() {
        self.presentVC(viewController: UIViewController(), presentation: .switchTabbar(index: self.lastIndexTabbar), to: .splash)
        didSelectTabbar(index: self.lastIndexTabbar)
    }
    
    func didSelectTabbar(index: Int?) {
        if let index = index {
            lastIndexTabbar = selectedIndexTabbar
            selectedIndexTabbar = index
        }
    }
    
    func pushViewController(vc: UIViewController, animated: Bool, to: NavigationOpeningSender) {
        let topVC = UIApplication.getTopViewController()
        if let nav = topVC?.navigationController {
            nav.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            nav.navigationBar.tintColor = .white
            
            switch to {
            case .me, .stationDetail:
                nav.setBarTintColor(color: .clear, complete: {
                    nav.pushViewController(vc, animated: animated)
                })
                break
            default:
                nav.pushViewController(vc, animated: animated)
            }
        } else {
            self.navigationController.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController.navigationBar.tintColor = .white

            switch to {
            case .me, .stationDetail:
                self.navigationController?.setBarTintColor(color: .clear, complete: {
                    self.navigationController.pushViewController(vc, animated: animated)
                })
                break
            default:
                self.navigationController.pushViewController(vc, animated: animated)
            }
        }
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
    
    private func getNavigationController(vc: UIViewController, isTranslucent: Bool = false, isFullScreen: Bool = false, to: NavigationOpeningSender = .main) -> UINavigationController {
        
        let nav: UINavigationController = UINavigationController(rootViewController: vc)
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            
            appearance.backgroundColor = to.navColor
            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            appearance.backgroundImage = UIImage()
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.h2Text, NSAttributedString.Key.foregroundColor: UIColor.white]
            
            nav.navigationBar.scrollEdgeAppearance = appearance
            nav.navigationBar.standardAppearance = appearance
            nav.navigationBar.compactAppearance = appearance
        } else {
            
            nav.navigationBar.barTintColor = to.navColor
            nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.bottom, barMetrics: .default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.isTranslucent = true
            nav.navigationBar.isHidden = true
            nav.navigationBar.barStyle = .black
            nav.navigationBar.tintColor = .white
            nav.navigationBar.layoutIfNeeded()
        }
        

        return nav
    }
    
}
