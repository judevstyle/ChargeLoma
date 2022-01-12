//
//  GetPlaceDetailResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 12/1/2565 BE.
//

import Foundation

public struct GetPlaceDetailResponse: Codable, Hashable  {
    
    public var result: PlaceItem?
    public var status: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try result       <- decoder["result"]
        try status       <- decoder["status"]
    }
}
