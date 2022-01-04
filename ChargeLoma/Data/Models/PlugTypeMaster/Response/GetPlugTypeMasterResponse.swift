//
//  GetPlugTypeMasterResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation

public struct GetPlugTypeMasterResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: [PlugTypeData]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct PlugTypeData: Codable, Hashable  {
    
    public var pTypeId: Int?
    public var pTitle: String?
    public var pIcon: String?
    public var pType: String?
    public var deleted: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try pTypeId   <- decoder["p_type_id"]
        try pTitle    <- decoder["p_title"]
        try pIcon     <- decoder["p_icon"]
        try pType     <- decoder["p_type"]
        try deleted   <- decoder["deleted"]
    }
}
