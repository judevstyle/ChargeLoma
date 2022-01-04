//
//  LocalizableDelegate.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import Foundation

public protocol LocalizableDelegate {
    var bundle: Bundle { get }
    var rawValue: String { get }    //localize key
    var table: String? { get }
    var localized: String { get }
}

private class LocalizableClass {}

extension LocalizableDelegate {
    
    public var bundle: Bundle {
        return Bundle(for: LocalizableClass.self)
    }

    //returns a localized value by specified key located in the specified table
    public var localized: String {
        let defaultValue = NSLocalizedString(rawValue, tableName: Language.englishTableName, bundle: bundle, value: "Default", comment: "")
        return NSLocalizedString(rawValue, tableName: table, bundle: bundle, value: defaultValue, comment: "")
    }

    // file name, where to find the localized key
    public var table: String? {
        return Language.current.tableName
    }
}
