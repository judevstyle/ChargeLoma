//
//  GetReviewResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 22/1/2565 BE.
//

import Foundation

public struct GetReviewResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: [ReviewData]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode  <- decoder["statusCode"]
        try success     <- decoder["success"]
        try data        <- decoder["data"]
    }
}

public struct ReviewData: Codable, Hashable  {
    
    public var comment: String?
    public var power: Int?
    public var isCharge: Bool?
    public var carServe: String?
    public var createdDate: String?
    public var PlugTypeMaster: PlugTypeData?
    public var ReviewImg: [ImageStationData]?
    public var User: UserProfileData?
    public var plugType: [PlugTypeData]?
    public var stationStatus: Int?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try comment         <- decoder["comment"]
        try power           <- decoder["power"]
        try isCharge        <- decoder["isCharge"]
        try carServe       <- decoder["car_serve"]
        try createdDate    <- decoder["created_date"]
        try PlugTypeMaster  <- decoder["PlugTypeMaster"]
        try ReviewImg       <- decoder["ReviewImg"]
        try User            <- decoder["User"]
        try plugType       <- decoder["plug_type"]
        try stationStatus  <- decoder["station_status"]
    }
}
