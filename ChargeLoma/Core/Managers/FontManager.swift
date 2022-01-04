//
//  FontManager.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import Foundation
import SwiftUI
import UIKit

let DISPATCH_CONFIG = DispatchQueue.init(label: "InitConfig")

//MARK: - Font Parts
public extension UIFont {
    
    enum Family: String {
        case text           = "Kanit-Regular"
        case bold           = "Kanit-Bold"
        case light          = "Kanit-Light"
        case medium         = "Kanit-Medium"
        
        //easy to change default app font family
        static let defaultFamily = Family.text
    }
    
    enum CustomWeight: String {
        case regular    = "regular"
        case bold       = "bold"
        case light      = "light"
        case medium     = "medium"
    }
    
//    private class DummyClass {}
    
    //MARK: - load framework font in application
    static let loadAllFonts: () = {
        DISPATCH_CONFIG.async {
            registerFontWith(filenameString: Family.bold.rawValue)
            registerFontWith(filenameString: Family.text.rawValue)
            registerFontWith(filenameString: Family.light.rawValue)
            registerFontWith(filenameString: Family.medium.rawValue)

        }
    }()

    //MARK: - Make custom font bundle register to framework
    private static func registerFontWith(filenameString: String) {
        let frameworkBundle = ConfigBundle.ChargeLoma
        let pathForResourceString = frameworkBundle.path(forResource: filenameString, ofType: "ttf")
        let fontData = NSData(contentsOfFile: pathForResourceString!)
        let dataProvider = CGDataProvider(data: fontData!)
        let fontRef = CGFont(dataProvider!)
        var errorRef: Unmanaged<CFError>? = nil

        if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
            NSLog("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
    
    private class func stringName(_ lang: Language, _ weight: CustomWeight) -> String {
        /**
        Define incompatible family, weight  here
        in this case set defaults compatible values
        */
        let familyName: String
        
        switch (lang, weight) {
        case (.english, .regular), (.thai, .regular):
            familyName = Family.text.rawValue
        case (.english, .bold), (.thai, .bold):
            familyName = Family.bold.rawValue
        case (.english, .light), (.thai, .light):
            familyName = Family.light.rawValue
        case (.english, .medium), (.thai, .medium):
            familyName = Family.medium.rawValue
        default:
            familyName = Family.text.rawValue
        }
        
        return familyName
    }
}

//MARK: - Initializers UIFont UIKit
public extension UIFont {
    /// Sets the font of the text displayed by the Font
    ///
    /// Use this method to change the font of the text rendered by a UIFont.
    ///
    /// For example:
    ///
    ///     label.text = "Example UIFont"
    ///     label.font = UIFont.titleBar
    ///
    
    static var currentLang: Language {
        return Language.current
    }
    
    static var titleBar: UIFont { UIFont(38.0, .bold, currentLang) }
    static var header1: UIFont  { UIFont(36.0, .bold, currentLang) }
    static var header2: UIFont  { UIFont(36.0, .regular, currentLang) }
    static var header3: UIFont  { UIFont(34.0, .bold, currentLang) }
    static var header4: UIFont  { UIFont(34.0, .regular, currentLang) }
    static var header5: UIFont  { UIFont(32.0, .bold, currentLang) }
    static var header6: UIFont  { UIFont(32.0, .regular, currentLang) }
    static var header7: UIFont  { UIFont(30.0, .bold, currentLang) }
    static var header8: UIFont  { UIFont(30.0, .regular, currentLang) }
    static var header9: UIFont  { UIFont(28.0, .bold, currentLang) }
    static var header10: UIFont { UIFont(28.0, .regular, currentLang) }
    static var titleBold: UIFont { UIFont(24.0, .bold, currentLang) }
    static var titleText: UIFont  { UIFont(24.0, .regular, currentLang ) }
    static var h1Bold: UIFont   { UIFont(22.0, .bold, currentLang) }
    static var h1Text: UIFont   { UIFont(22.0, .regular, currentLang) }
    static var h2Bold: UIFont   { UIFont(20.0, .bold, currentLang) }
    static var h2Text: UIFont   { UIFont(20.0, .regular, currentLang) }
    static var h3Bold: UIFont   { UIFont(18.0, .bold, currentLang) }
    static var h3Text: UIFont   { UIFont(18.0, .regular, currentLang) }
    static var h3Medium: UIFont   { UIFont(18.0, .medium, currentLang) }
    static var bodyBold: UIFont { UIFont(16.0, .bold, currentLang) }
    static var bodyText: UIFont { UIFont(16.0, .regular, currentLang) }
    static var smallBold: UIFont { UIFont(14.0, .bold, currentLang) }
    static var smallText: UIFont { UIFont(14.0, .regular, currentLang) }
    static var extraSmallBold: UIFont { UIFont(12.0, .bold, currentLang) }
    static var extraSmallText: UIFont { UIFont(12.0, .regular, currentLang) }
    static var biggerTinyBold: UIFont { UIFont(11.0, .bold, currentLang) }
    static var biggerTinyText: UIFont { UIFont(11.0, .regular, currentLang) }
    static var tinyBold: UIFont { UIFont(10.0, .bold, currentLang) }
    static var tinyText: UIFont { UIFont(10.0, .regular, currentLang) }
    static var semiBold: UIFont { UIFont(8.0, .bold, currentLang) }
    static var semiText: UIFont { UIFont(8.0, .regular, currentLang) }
    
    convenience init(_ size: CGFloat, _ weight: CustomWeight, _ currentLang: Language) {
        switch currentLang {
        case .english, .thai:
            self.init(name: UIFont.stringName(currentLang, weight), size: size)!
        default:
            // set default font name of device.
            // if the user changes the language outside the case.
            let nameSystem = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium).familyName
            self.init(name: nameSystem, size: size)!
        }
    }
    
    convenience init(_ size: CGFloat, _ weight: CustomWeight) {
        self.init(size, weight, Language.current)
    }
}

//MARK: - Initializers Font SwiftUI
@available(iOS 13.0, *)
public extension Font {
    /// Sets the font of the text displayed by the Font
    ///
    /// Use this method to change the font of the text rendered by a Font.
    ///
    /// For example:
    ///
    ///     Text("Example font").font(Font.titleBar)
    ///
    /// - Parameters:
    ///     - font: font syle.
    ///
    
    static var currentLang: Language {
        return Language.current
    }
    
    static var titleBar: Font { Font(38.0, .bold, currentLang) }
    static var header1: Font  { Font(36.0, .bold, currentLang) }
    static var header2: Font  { Font(36.0, .regular, currentLang) }
    static var header3: Font  { Font(34.0, .bold, currentLang) }
    static var header4: Font  { Font(34.0, .regular, currentLang) }
    static var header5: Font  { Font(32.0, .bold, currentLang) }
    static var header6: Font  { Font(32.0, .regular, currentLang) }
    static var header7: Font  { Font(30.0, .bold, currentLang) }
    static var header8: Font  { Font(30.0, .regular, currentLang) }
    static var header9: Font  { Font(28.0, .bold, currentLang) }
    static var header10: Font { Font(28.0, .regular, currentLang) }
    static var titleBold: Font { Font(24.0, .bold, currentLang) }
    static var titleText: Font  { Font(24.0, .regular, currentLang ) }
    static var h1Bold: Font   { Font(22.0, .bold, currentLang) }
    static var h1Text: Font   { Font(22.0, .regular, currentLang) }
    static var h2Bold: Font   { Font(20.0, .bold, currentLang) }
    static var h2Text: Font   { Font(20.0, .regular, currentLang) }
    static var h3Bold: Font   { Font(18.0, .bold, currentLang) }
    static var h3Text: Font   { Font(18.0, .regular, currentLang) }
    static var bodyBold: Font { Font(16.0, .bold, currentLang) }
    static var bodyText: Font { Font(16.0, .regular, currentLang) }
    static var smallBold: Font { Font(14.0, .bold, currentLang) }
    static var smallText: Font { Font(14.0, .regular, currentLang) }
    static var extraSmallBold: Font { Font(12.0, .bold, currentLang) }
    static var extraSmallText: Font { Font(12.0, .regular, currentLang) }
    static var tinyBold: Font { Font(10.0, .bold, currentLang) }
    static var tinyText: Font { Font(10.0, .regular, currentLang) }
    static var semiBold: Font { Font(8.0, .bold, currentLang) }
    static var semiText: Font { Font(8.0, .regular, currentLang) }
    
    init() {
        self.init(UIFont.bodyText)
    }
    
    init(_ size: CGFloat, _ weight: UIFont.CustomWeight) {
        self.init(UIFont(size, weight))
    }
        
    init(_ size: CGFloat, _ weight: UIFont.CustomWeight, _ lang: Language) {
        self.init(UIFont(size, weight, lang))
    }
    
}
