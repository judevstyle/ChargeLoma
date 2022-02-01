//
//  FavoriteRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation

public struct FavoriteRequest: Codable, Hashable {
    
    public var stId: String?
    public var page: Int?
    public var lang: String?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case stId = "st_id"
        case page = "page"
        case lang = "lang"
    }
}
