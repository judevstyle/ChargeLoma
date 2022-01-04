//
//  Language.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import Foundation
import SwiftUI
import Combine

/**
 Application Level Configurations
     Thai (th)
     English (en)
 */

// MARK: - Provide binding data language
public class LanguageEnvironment: ObservableObject {
    
    public static let shared: LanguageEnvironment = LanguageEnvironment()

    @Published private(set) var current: Language?

    public init() { current = Language.current }

    public func setCurrentLanguage(_ lang: Language? = Language.current) {
        current = lang
    }
    
    public func getCurrentLanguage() -> Language {
        return current ?? Language.current
    }
}


// MARK: - Language and Localization
/**
 Available Notification that will posted from this source code file.
 */
public extension Notification.Name {
    static let LanguageDidChange = Notification.Name(rawValue: "languageDidChange")
}


/// Main Language enum, with current settings via
/// Example: Language.current
///
public enum Language: Equatable {
    case thai
    case english
    case other(code: String?)

    public static let thaiTableName = "LocalizedThai"
    public static let englishTableName = "LocalizedEnglish"
    
    public var tableName: String {
        switch self {
        case .thai:
            return Language.thaiTableName
        case .english:
            return Language.englishTableName
        case .other:
            return Language.englishTableName
        }
    }
    
    public var locale: Locale {
        return Locale(identifier: identified)
    }

    public var identified: String {
        switch self {
        case .thai:             return "th_TH"
        case .english:          return "en_US"
        case .other(let code):  return code ?? ""
        }
    }

    public var calendar: Calendar {
        switch self {
        case .thai:         return Calendar(identifier: .buddhist)
        case .english:      return Calendar(identifier: .gregorian)
        default:            return Calendar(identifier: .gregorian)
        }
    }

    /// Example : pass data
    /// equivalident to "rawValue" ("th" or "en")
    /// Indonesia (id)
    /// Cambodia (km)
    /// Vietnam (vi)
    /// Philippines (fil)
    ///
    public var name: String {
        switch self {
        case .thai:             return "th"
        case .english:          return "en"
        case .other(let code):  return code ?? ""
        }
    }
    
    public var addYear: Int {
        switch self {
        case .thai:         return 543
        case .english:      return 0
        default:            return 0
        }
    }
    
    public static var languageCode: String {
        if UserDefaultsKey.AppLanguage.string != nil {
            return UserDefaultsKey.AppLanguage.string ?? String(Locale.preferredLanguages[0].prefix(2))
        }
        return String(Locale.preferredLanguages[0].prefix(2))
    }
    
    public static func languageFromCode (code: String) -> Language {
        switch code {
            case "th":
                return .thai
            case "en":
                return .english
            default:
                return .other(code: code)
        }
    }
    
    public static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.name == rhs.name
    }

    public static var current: Language = languageFromCode(code: languageCode) {
        didSet {
            UserDefaultsKey.AppLanguage.set(value: self.current.name)
            Notification.Name.LanguageDidChange.post()
        }
    }

    public func relativeTime(of: Date, from: Date = Date()) -> String {
        let allSeconds = lround(of.timeIntervalSince(from))
        let isAgo = allSeconds < 0
        let absSeconds = abs(allSeconds)
        let hours = absSeconds / 3600
        let mins = (absSeconds % 3600) / 60
        let seconds = absSeconds % 60

        if isAgo {
            if hours > 0 { return String(format: Wording.Timer.hoursAgo.localized, arguments: [hours]) }
            if mins > 0 { return String(format: Wording.Timer.minutesAgo.localized, arguments: [mins]) }
            if seconds > 0 { return String(format: Wording.Timer.secondsAgo.localized, arguments: [seconds]) }
            return Wording.Timer.lessThanSecAgo.localized
        } else {
            if hours > 0 { return String(format: Wording.Timer.hours.localized, arguments: [hours]) }
            if mins > 0 { return String(format: Wording.Timer.minutes.localized, arguments: [mins]) }
            if seconds > 0 { return String(format: Wording.Timer.seconds.localized, arguments: [seconds]) }
            return Wording.Timer.lessThanSec.localized
        }
    }
}
