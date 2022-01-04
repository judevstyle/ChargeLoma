//
//  GetProviderMasterResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation

public struct GetProviderMasterResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: [ProviderData]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct ProviderData: Codable, Hashable  {
    
    public var pvId: Int?
    public var name: String?
    public var desv: String?
    public var icon: String?
    public var shortname: String?
    public var logoLabel: String?
    public var deleted: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try pvId        <- decoder["pv_id"]
        try name        <- decoder["name"]
        try desv        <- decoder["desv"]
        try icon        <- decoder["icon"]
        try shortname   <- decoder["shortname"]
        try logoLabel   <- decoder["logo_label"]
        try deleted     <- decoder["deleted"]
    }
}
