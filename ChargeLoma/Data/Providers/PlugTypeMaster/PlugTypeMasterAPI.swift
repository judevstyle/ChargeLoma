//
//  PlugTypeMasterAPI.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation
import Moya
import UIKit

public enum PlugTypeMasterAPI {
    case findAll
    case plugTypeCategory
}

extension PlugTypeMasterAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .findAll, .plugTypeCategory:
            return DomainNameConfig.plugTypeMaster.url
        }
    }
    
    public var path: String {
        switch self {
        case .findAll:
            return ""
        case .plugTypeCategory:
            return "/plugTypeCategory"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .findAll, .plugTypeCategory:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        var authenToken = ""
        switch self {
        default:
            authenToken = UserDefaultsKey.AccessToken.string ?? ""
        }
        
        if authenToken.isEmpty {
            return ["Content-Type": "application/json"]
        }
        
        return ["Authorization": "Bearer \(authenToken)",
            "Content-Type": "application/json"]
    }
}
