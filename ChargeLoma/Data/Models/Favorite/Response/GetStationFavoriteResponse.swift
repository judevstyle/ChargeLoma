//
//  GetStationFavoriteResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/1/2565 BE.
//

import Foundation

public struct GetStationFavoriteResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: [StationFavoriteData]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode  <- decoder["statusCode"]
        try success     <- decoder["success"]
        try data        <- decoder["data"]
    }
}

public struct StationFavoriteData: Codable, Hashable  {
    
    public var favId: String?
    public var station: StationData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try favId  <- decoder["fav_id"]
        try station     <- decoder["station"]
    }
}
