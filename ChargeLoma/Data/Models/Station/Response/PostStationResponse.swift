//
//  PostStationResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 13/2/2565 BE.
//

import Foundation

public struct PostStationResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
    }
}
