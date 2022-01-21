//
//  GetFavoriteResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation

public struct GetFavoriteResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: FavoriteData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode  <- decoder["statusCode"]
        try success     <- decoder["success"]
        try data        <- decoder["data"]
    }
}

public struct FavoriteData: Codable, Hashable  {
    
    public var isFavorite: Bool?
    public var favId: String?
    public var stId: String?
    public var deleted: Bool?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try isFavorite  <- decoder["isFavorite"]
        try favId       <- decoder["fav_id"]
        try stId        <- decoder["st_id"]
        try deleted     <- decoder["deleted"]
    }
}
