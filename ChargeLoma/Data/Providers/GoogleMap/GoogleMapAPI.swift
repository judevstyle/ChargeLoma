//
//  GoogleMapAPI.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 12/1/2565 BE.
//

import Foundation
import Moya
import UIKit

public enum GoogleMapAPI {
    case getPlaceAutoComplete(request: GetPlaceAutoCompleteRequest)
    case getPlaceDetail(request: GetPlaceDetailRequest)
}

extension GoogleMapAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .getPlaceAutoComplete, .getPlaceDetail:
            return DomainNameConfig.googleMap.url
        }
    }

    public var path: String {
        switch self {
        case .getPlaceAutoComplete:
            return "/place/autocomplete/json"
        case .getPlaceDetail:
            return "/place/details/json"
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
        case let .getPlaceAutoComplete(request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        case let .getPlaceDetail(request):
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
