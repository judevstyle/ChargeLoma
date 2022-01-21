//
//  AppDelegate.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import Firebase
import GoogleSignIn

//@main
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let shareDelegate = AppDelegate()
    var userProfileData: UserProfileData? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        GMSServices.provideAPIKey("AIzaSyDg-bwviwDVeAhD_JPJt4mdCidS9dK4uvA")
        GMSPlacesClient.provideAPIKey("AIzaSyDg-bwviwDVeAhD_JPJt4mdCidS9dK4uvA")
        UIFont.loadAllFonts
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        AuthCheck()
        
        presentSplashVC()
        return true
    }
    
    private func presentSplashVC() {
        let loadingStoryBoard = "Splash"
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: loadingStoryBoard, bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    func AuthCheck() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let uid = auth.currentUser?.uid else {
                debugPrint("has is not LoggedIn")
                AppDelegate.shareDelegate.resetClearAll()
                AppDelegate.shareDelegate.userProfileData = nil
                return
            }
            debugPrint("has isLoggedIn Success")
            UserDefaultsKey.isLoggedIn.set(value: true)
            UserDefaultsKey.UID.set(value: uid)
        }
    }
    
    public func resetClearAll() {
        UserDefaultsKey.isLoggedIn.remove()
        UserDefaultsKey.UID.remove()
        UserDefaultsKey.AccessToken.remove()
        UserDefaultsKey.TokenType.remove()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    let handled = GIDSignIn.sharedInstance().handle(url)
    return handled
    // return GIDSignIn.sharedInstance().handle(url,
    // sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
    // annotation: [:])
    }

}

