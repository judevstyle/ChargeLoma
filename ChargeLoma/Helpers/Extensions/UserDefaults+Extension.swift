//
//  UserDefaults+Extension.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 3/30/21.
//
import Foundation

//extension UserDefaults{
//
//    //MARK: Check Login
//    func setLoggedIn(value: Bool) {
//        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
//        //synchronize()
//    }
//
//    func isLoggedIn()-> Bool {
//        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
//    }
//
//    //MARK: Save UID
//    func setUID(value: String?){
//        set(value, forKey: UserDefaultsKeys.UID.rawValue)
//        //synchronize()
//    }
//    
//    //MARK: Remove UID
//    func deleteUID(){
//        removeObject(forKey: UserDefaultsKeys.UID.rawValue)
//        //synchronize()
//    }
//
//    //MARK: Get UID
//    func getUID() -> String?{
//        return string(forKey: UserDefaultsKeys.UID.rawValue) ?? nil
//    }
//    
//    //MARK: Save accessToken
//    func setAccessToken(value: String?){
//        set(value, forKey: UserDefaultsKeys.accessToken.rawValue)
//        //synchronize()
//    }
//    
//    //MARK: Remove accessToken
//    func deleteAccessToken(){
//        removeObject(forKey: UserDefaultsKeys.accessToken.rawValue)
//        //synchronize()
//    }
//
//    //MARK: Get accessToken
//    func getAccessToken() -> String?{
//        return string(forKey: UserDefaultsKeys.accessToken.rawValue) ?? nil
//    }
//    
//    //MARK: Save TokenType
//    func setTokenType(value: String?){
//        set(value, forKey: UserDefaultsKeys.tokenType.rawValue)
//        //synchronize()
//    }
//    
//    //MARK: Remove TokenType
//    func deleteTokenType(){
//        removeObject(forKey: UserDefaultsKeys.tokenType.rawValue)
//        //synchronize()
//    }
//
//    //MARK: Get TokenType
//    func getTokenType() -> String?{
//        return string(forKey: UserDefaultsKeys.tokenType.rawValue) ?? nil
//    }
//}
//
//enum UserDefaultsKeys : String {
//    case isLoggedIn
//    case UID
//    case accessToken
//    case tokenType
//}
