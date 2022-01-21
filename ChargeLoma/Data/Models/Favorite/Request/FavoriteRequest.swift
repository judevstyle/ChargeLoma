//
//  FavoriteRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation

public struct FavoriteRequest: Codable, Hashable {
    
    public var stId: String?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case stId = "st_id"
    }
}
