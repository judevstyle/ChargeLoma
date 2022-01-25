//
//  GetPlugStationResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 23/1/2565 BE.
//

import Foundation

public struct GetPlugStationResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: [PlugStationData]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode  <- decoder["statusCode"]
        try success     <- decoder["success"]
        try data        <- decoder["data"]
    }
}

public struct PlugStationData: Codable, Hashable  {
    
    public var qty: Int?
    public var power: String?
    public var plugType: PlugTypeData?

    public init() {}
    
    public init(from decoder: Decoder) throws {
        try qty         <- decoder["qty"]
        try power       <- decoder["power"]
        try plugType    <- decoder["plug_type"]
    }
}
