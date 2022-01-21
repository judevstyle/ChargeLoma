//
//  GetImageStationRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation

public struct GetImageStationRequest: Codable, Hashable {
    
    public var qureyStamp: String?
    public var page: Int?
    public var lang: String?
    public var stId: String?
    public var limit: Int?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case qureyStamp = "qureyStamp"
        case page = "page"
        case lang = "lang"
        case stId = "st_id"
        case limit = "limit"
    }
}
