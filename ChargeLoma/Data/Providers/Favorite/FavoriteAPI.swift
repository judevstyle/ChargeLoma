//
//  FavoriteAPI.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation
import Moya
import UIKit

public enum FavoriteAPI {
    case stationFavorite(request: FavoriteRequest)
    case getFavorite(request: FavoriteRequest)
    case postFavorite(request: FavoriteRequest)
    case deleteFavorite(stId: String)
}

extension FavoriteAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .getFavorite, .postFavorite, .deleteFavorite, .stationFavorite:
            return DomainNameConfig.favorite.url
        }
    }

    public var path: String {
        switch self {
        case .getFavorite:
            return "/favStation"
        case .postFavorite:
            return ""
        case .deleteFavorite(let stId):
            return "/\(stId)"
        case .stationFavorite:
            return "/stationFavorite"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .postFavorite:
            return .post
        case .deleteFavorite:
            return .delete
        default:
            return .get
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {
        case let .getFavorite(request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        case let .postFavorite(request):
            return .requestCompositeParameters(bodyParameters: request.toJSON(), bodyEncoding: JSONEncoding.default, urlParameters: [:])
        case .deleteFavorite:
            return .requestPlain
        case let .stationFavorite(request):
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
