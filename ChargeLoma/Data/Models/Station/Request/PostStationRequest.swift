//
//  PostStationRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 13/2/2565 BE.
//

import Foundation

public struct PostStationRequest: Codable, Hashable {
    
    public var stationNameTh: String?
    public var stationNameEn: String?
    public var stationDesc: String?
    public var addrTh: String?
    public var addrEn: String?
    
    public var lat: Double?
    public var lng: Double?
    public var typeService: String?
    public var is24hr: Bool?
    public var stationImg: String?
    
    public var servicetimeOpen: String?
    public var servicetimeClose: String?
    public var isServiceCharge: Bool?
    public var serviceRate: Int?
    public var statusApprove: String?
    public var statusMsg: String?
    public var stationStatus: Int?
    public var note: String?
    public var power: Int?
    public var tel: String?
    public var isServiceParking: Bool?
    public var isServiceFood: Bool?
    public var isServiceCoffee: Bool?
    public var isServiceRestroom: Bool?
    public var isServiceShoping: Bool?
    public var isServiceRestarea: Bool?
    public var isServiceWifi: Bool?
    public var isServiceOther: Bool?
    public var pvId: Int?
    public var PlugMapping: [PlugMappingRequest]?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case stationNameTh = "station_name_th"
        case stationNameEn = "station_name_en"
        case stationDesc = "station_desc"
        case addrTh = "addr_th"
        case addrEn = "addr_en"
        case lat = "lat"
        case lng = "lng"
        case typeService = "type_service"
        case is24hr = "is24hr"
        case stationImg = "station_img"
        case servicetimeOpen = "servicetime_open"
        case servicetimeClose = "servicetime_close"
        case isServiceCharge = "is_service_charge"
        case serviceRate = "service_rate"
        case statusApprove = "status_approve"
        case statusMsg = "status_msg"
        case stationStatus = "station_status"
        case note = "note"
        case power = "power"
        case tel = "tel"
        case isServiceParking = "is_service_parking"
        case isServiceFood = "is_service_food"
        case isServiceCoffee = "is_service_coffee"
        case isServiceRestroom = "is_service_restroom"
        case isServiceShoping = "is_service_shoping"
        case isServiceRestarea = "is_service_restarea"
        case isServiceWifi = "is_service_wifi"
        case isServiceOther = "is_service_other"
        case pvId = "pv_id"
        case PlugMapping = "PlugMapping"
    }
}

public struct PlugMappingRequest: Codable, Hashable {
    
    public var pTypeId: Int?
    public var qty: Int?
    public var power: String?

    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case pTypeId = "p_type_id"
        case qty = "qty"
        case power = "power"

    }
}
