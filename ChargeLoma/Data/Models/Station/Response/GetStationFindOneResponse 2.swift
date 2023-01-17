//
//  GetStationFindOneResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 8/1/2565 BE.
//

import Foundation

public struct GetStationFindOneResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: StationData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}
