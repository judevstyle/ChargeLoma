//
//  GetPlugTypeCategoryResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 9/1/2565 BE.
//

import Foundation

public struct GetPlugTypeCategoryResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: PlugTypeCategoryData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct PlugTypeCategoryData: Codable, Hashable  {
    
    public var AC: [PlugTypeData]?
    public var DC: [PlugTypeData]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try AC   <- decoder["AC"]
        try DC   <- decoder["DC"]
    }
}
