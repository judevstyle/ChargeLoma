//
//  StationAPI.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation
import Moya
import UIKit

public enum StationAPI {
    case stationFilter(request: PostStationFilterRequest)
    case findOne(request: GetStationFindOneRequest)
    case imageStation(request: GetImageStationRequest)
}

extension StationAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .stationFilter, .findOne, .imageStation:
            return DomainNameConfig.station.url
        }
    }

    public var path: String {
        switch self {
        case .stationFilter:
            return "/stationFilter"
        case .findOne(let request):
            return "/\(request.stId ?? "")"
        case .imageStation:
            return "imageStation"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .stationFilter:
            return .post
        default:
            return .get
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {
        case let .stationFilter(request):
            return .requestCompositeParameters(bodyParameters: request.toJSON(), bodyEncoding: JSONEncoding.default, urlParameters: [:])
        case let .findOne(request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        case let .imageStation(request):
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
