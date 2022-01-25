//
//  PlugStationAPI.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 23/1/2565 BE.
//

import Foundation
import Moya
import UIKit

public enum PlugStationAPI {
    case getPlugStation(request: GetPlugStationRequest)
}

extension PlugStationAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .getPlugStation:
            return DomainNameConfig.plugStation.url
        }
    }

    public var path: String {
        switch self {
        case .getPlugStation:
            return ""
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
        case let .getPlugStation(request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
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
