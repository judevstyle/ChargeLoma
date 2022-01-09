//
//  GetStationFindOneRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 8/1/2565 BE.
//

import Foundation

public struct GetStationFindOneRequest: Codable, Hashable {
    
    public var lang: String = "th"
    
    public var stId: String?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case lang = "lang"

    }
}
