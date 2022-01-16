//
//  PostStationFilterResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation

public struct PostStationFilterResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: [StationData]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct StationData: Codable, Hashable  {
    
    public var tel: String?
    public var stationImg: String?
    public var stId: String?
    public var typeService: String?
    public var lat: Double?
    public var lng: Double?
    public var is24hr: Bool = false
    public var servicetimeOpen: String?
    public var servicetimeClose: String?
    public var stationStatus: Int?
    public var power: Int?
    public var provider: ProviderData?
    public var stationName: String?
    public var addr: String?
    public var plugDesc: String?
    public var isFastCharge: Bool = false
    public var rating: Double?
    public var stationDesc: String?
    public var serviceRate: Double?
    public var plugMapping: [PlugMapping]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try tel                 <- decoder["tel"]
        try stationImg          <- decoder["station_img"]
        try stId                <- decoder["st_id"]
        try typeService         <- decoder["type_service"]
        try lat                 <- decoder["lat"]
        try lng                 <- decoder["lng"]
        try is24hr              <- decoder["is24hr"]
        try servicetimeOpen     <- decoder["servicetime_open"]
        try servicetimeClose    <- decoder["servicetime_close"]
        try stationStatus       <- decoder["station_status"]
        try power               <- decoder["power"]
        try provider            <- decoder["provider"]
        try stationName         <- decoder["station_name"]
        try addr                <- decoder["addr"]
        try plugDesc            <- decoder["plug_desc"]
        try isFastCharge        <- decoder["isFastCharge"]
        try rating              <- decoder["p_type_id"]
        try stationDesc         <- decoder["station_desc"]
        try serviceRate         <- decoder["service_rate"]
        try plugMapping         <- decoder["PlugMapping"]
    }
}

public struct PlugMapping: Codable, Hashable  {
    
    public var pMappingId: Int?
    public var qty: Int?
    public var power: String?
    public var plugTypeMaster: PlugTypeData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try pMappingId    <- decoder["p_mapping_id"]
        try qty             <- decoder["qty"]
        try power           <- decoder["power"]
        try plugTypeMaster  <- decoder["PlugTypeMaster"]
    }
}
