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
    public var is24hr: Bool?
    public var servicetimeOpen: String?
    public var servicetimeClose: String?
    public var stationStatus: Int?
    public var power: Int?
    public var provider: ProviderData?
    public var stationName: String?
    public var addr: String?
    public var plugDesc: String?
    public var isFastCharge: Bool?
    public var rating: Double?
    public var stationDesc: String?
    public var serviceRate: Double?
    public var plugMapping: [PlugMapping]?
    
    //Service
    public var isServiceCharge: Bool?
    public var isServiceParking: Bool?
    public var isServiceFood: Bool?
    public var isServiceCoffee: Bool?
    public var isServiceRestroom: Bool?
    public var isServiceShoping: Bool?
    public var isServiceRestarea: Bool?
    public var isServiceWifi: Bool?
    public var isServiceOther: Bool?
    
    public var note: String?
    
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
        try rating              <- decoder["rating"]
        try stationDesc         <- decoder["station_desc"]
        try serviceRate         <- decoder["service_rate"]
        try plugMapping         <- decoder["PlugMapping"]
        
        //Service
        try isServiceCharge   <- decoder["is_service_charge"]
        try isServiceParking  <- decoder["is_service_parking"]
        try isServiceFood     <- decoder["is_service_food"]
        try isServiceCoffee   <- decoder["is_service_coffee"]
        try isServiceRestroom <- decoder["is_service_restroom"]
        try isServiceShoping  <- decoder["is_service_shoping"]
        try isServiceRestarea <- decoder["is_service_restarea"]
        try isServiceWifi     <- decoder["is_service_wifi"]
        try isServiceOther    <- decoder["is_service_other"]
        try note              <- decoder["note"]
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
