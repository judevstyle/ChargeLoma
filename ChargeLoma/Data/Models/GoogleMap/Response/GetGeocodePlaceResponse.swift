//
//  GetGeocodePlaceResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 13/2/2565 BE.
//

import Foundation

public struct GetGeocodePlaceResponse: Codable, Hashable  {
    
    public var results: [PlaceItem]?
    public var status: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try results       <- decoder["results"]
        try status       <- decoder["status"]
    }
}
