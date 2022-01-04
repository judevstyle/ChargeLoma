//
//  PostStationFilterRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation

public struct PostStationFilterRequest: Codable, Hashable {
    
    public var lang: String = "en"
    public var plug: [Int] = []
    public var provider: [Int] = []
    public var status: [Int] = []
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case lang = "lang"
        case plug = "plug"
        case provider = "provider"
        case status = "status"

    }
}
