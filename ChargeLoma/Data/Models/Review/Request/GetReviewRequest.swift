//
//  GetReviewRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 22/1/2565 BE.
//

import Foundation

public struct GetReviewRequest: Codable, Hashable {
    
    public var stId: String?
    public var page: Int?
    public var limit: Int?
    public var uid: String?
    public var lang: String?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case stId = "st_id"
        case page = "page"
        case limit = "limit"
        case uid = "uid"
        case lang = "lang"
    }
}
