//
//  MapFilterModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 4/2/2565 BE.
//

import Foundation

public struct MapFilterModel: Codable, Hashable  {
    
    public var plugId: [Int?]?
    public var providerId: [Int?]?
    public var statusIndex: [Int?]?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case plugId = "plugId"
        case providerId = "providerId"
        case statusIndex = "statusIndex"
    }
    
    public init(from decoder: Decoder) throws {
        try plugId      <- decoder["plugId"]
        try providerId    <- decoder["providerId"]
        try statusIndex   <- decoder["statusIndex"]
    }
}
