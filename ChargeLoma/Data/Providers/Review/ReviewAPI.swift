//
//  ReviewAPI.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 22/1/2565 BE.
//

import Foundation
import Moya
import UIKit

public enum ReviewAPI {
    case getReview(request: GetReviewRequest)
    case getRecentlyReview(request: GetReviewRequest)
}

extension ReviewAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .getReview, .getRecentlyReview:
            return DomainNameConfig.review.url
        }
    }

    public var path: String {
        switch self {
        case .getReview:
            return ""
        case .getRecentlyReview:
            return "/recentlyReview"
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
        case let .getReview(request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        case let .getRecentlyReview(request):
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
