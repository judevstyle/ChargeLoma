//
//  DomainNameConfig.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 14/12/2564 BE.
//

import Foundation

public enum DomainNameConfig {
    case plugTypeMaster
    case providerMaster
    case station
}

extension DomainNameConfig {

    public var urlString: String {
        
        let baseURL: String = "http://charge-loma.ssoftdev.com/api"
        
        switch self {
        case .plugTypeMaster:
            return "\(baseURL)/plug-type-master"
        case .providerMaster:
            return "\(baseURL)/provider-master"
        case .station:
            return "\(baseURL)/station"
        }
    }
    
    public var headerKey: String {
        switch self {
        default:
            return ""
        }
    }
    
    public var url: URL {
        return URL(string: self.urlString)!
    }
}
