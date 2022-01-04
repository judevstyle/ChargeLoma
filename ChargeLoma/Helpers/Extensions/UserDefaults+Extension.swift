//
//  UserDefaults+Extension.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 3/30/21.
//
import Foundation

extension UserDefaults{

    //MARK: Check Login
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        //synchronize()
    }

    func isLoggedIn()-> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }

    //MARK: Save User Data
    func setUID(value: String?){
        set(value, forKey: UserDefaultsKeys.UID.rawValue)
        //synchronize()
    }
    
    //MARK: Remove UID
    func deleteUID(){
        removeObject(forKey: UserDefaultsKeys.UID.rawValue)
        //synchronize()
    }

    //MARK: Retrieve User Data
    func getUID() -> String?{
        return string(forKey: UserDefaultsKeys.UID.rawValue) ?? nil
    }
}

enum UserDefaultsKeys : String {
    case isLoggedIn
    case UID
}
