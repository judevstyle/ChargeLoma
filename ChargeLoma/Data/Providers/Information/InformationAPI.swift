//
//  InformationAPI.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 15/1/2565 BE.
//

import Foundation
import Moya
import UIKit

public enum InformationAPI {
    case getFindAll(request: GetInformationFindAllRequest)
}

extension InformationAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .getFindAll:
            return DomainNameConfig.information.url
        }
    }

    public var path: String {
        switch self {
        case .getFindAll:
            return "/"
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
        case let .getFindAll(request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        }
    }

    public var headers: [String : String]? {
        var authenToken = ""

        if authenToken.isEmpty {
            return ["Content-Type": "application/json"]
        }

        return ["Authorization": "Bearer \(authenToken)",
            "Content-Type": "application/json"]
    }
}
