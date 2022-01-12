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
    case googleMap
}

extension DomainNameConfig {

    public var urlString: String {
        
        let baseURL: String = "http://charge-loma.ssoftdev.com/api"
        let googleMapURL: String = "https://maps.googleapis.com/maps/api"
        
        switch self {
        case .plugTypeMaster:
            return "\(baseURL)/plug-type-master"
        case .providerMaster:
            return "\(baseURL)/provider-master"
        case .station:
            return "\(baseURL)/station"
        case .googleMap:
            return "\(googleMapURL)"
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
