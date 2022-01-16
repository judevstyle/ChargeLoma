//
//  GetPlaceDirectionResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 14/1/2565 BE.
//

import Foundation

public struct GetPlaceDirectionResponse: Codable, Hashable  {
    
    public var routes: [RouteItem]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try routes       <- decoder["routes"]
    }
}


public struct RouteItem: Codable, Hashable  {

    public var points: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try points   <- decoder["overview_polyline.points"]
    }
}
