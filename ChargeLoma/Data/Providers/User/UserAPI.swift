//
//  UserAPI.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation
import Moya
import UIKit

public enum UserAPI {
    case postUserRegister(request: PostUserRegisterRequest)
    case postUserAuth(request: PostUserAuthRequest)
    case getUserProfile
}

extension UserAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .postUserRegister, .postUserAuth, .getUserProfile:
            return DomainNameConfig.user.url
        }
    }

    public var path: String {
        switch self {
        case .postUserRegister:
            return "/register"
        case .postUserAuth:
            return "/auth"
        case .getUserProfile:
            return "/profile"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .postUserRegister, .postUserAuth:
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
        case let .postUserRegister(request):
            return .requestCompositeParameters(bodyParameters: request.toJSON(), bodyEncoding: JSONEncoding.default, urlParameters: [:])
        case let .postUserAuth(request):
            return .requestCompositeParameters(bodyParameters: request.toJSON(), bodyEncoding: JSONEncoding.default, urlParameters: [:])
        case .getUserProfile:
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
