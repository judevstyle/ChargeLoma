//
//  UserDefaults.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import Foundation

public struct UserDefaultsKey {
    
    public static let DeviceId = UserDefaultsKey(UserDefaultsKeyType.DeviceId.rawValue)
    public static let AppLanguage = UserDefaultsKey(UserDefaultsKeyType.AppLanguage.rawValue)
    
    //Auth
    public static let AccessToken = UserDefaultsKey(UserDefaultsKeyType.AccessToken.rawValue)
    public static let UID = UserDefaultsKey(UserDefaultsKeyType.UID.rawValue)
    public static let TokenType = UserDefaultsKey(UserDefaultsKeyType.TokenType.rawValue)
    public static let isLoggedIn = UserDefaultsKey(UserDefaultsKeyType.isLoggedIn.rawValue)
    
    private let key:String
    
    public static func save() {
        UserDefaults.standard.synchronize()
    }
    
    public init(_ key: String) {
        self.key = key
    }
    
    public var value: Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    public var bool: Bool {
        return (UserDefaults.standard.object(forKey: key) as? Bool) ?? false
    }
    
    public var integer: Int? {
        return UserDefaults.standard.object(forKey: key) as? Int
    }
    
    public var double: Double? {
        return UserDefaults.standard.object(forKey: key) as? Double
    }
    
    public var string: String? {
        return UserDefaults.standard.object(forKey: key) as? String
    }
    
    public var stringArray: [String]? {
        return UserDefaults.standard.object(forKey: key) as? [String]
    }
        
    public var date: Date? {
        return UserDefaults.standard.object(forKey: key) as? Date
    }
    
    public var data: Data? {
        return UserDefaults.standard.object(forKey: key) as? Data
    }
    
    public func getObject<Object>(castTo type: Object.Type) -> Object? where Object: Decodable {
        guard let data = UserDefaultsKey(self.key).data else { return nil }
        if let object = try? JSONDecoder().decode(type, from: data) {
            return object
        } else {
            return nil
        }
    }
    
    public func set(value: Any?, save: Bool = true) {
        UserDefaults.standard.set(value, forKey: key)
        if save {
            setNamedTimeout("saveUserDefaults", delay: 0.2) {
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    public func remove(save: Bool = true) {
        UserDefaults.standard.removeObject(forKey: key)
        if save {
            setNamedTimeout("saveUserDefaults", delay: 0.2) {
                UserDefaults.standard.synchronize()
            }
        }
    }
}

enum UserDefaultsKeyType : String {
    case DeviceId = "ChargeLoma.Device.Id"
    case AppLanguage = "AppLanguage"
    case UID = "UID"
    case AccessToken = "AccessToken"
    case TokenType = "TokenType"
    case isLoggedIn = "isLoggedIn"
}
