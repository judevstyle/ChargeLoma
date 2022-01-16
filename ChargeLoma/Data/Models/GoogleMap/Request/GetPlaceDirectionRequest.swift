//
//  GetPlaceDirectionRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 14/1/2565 BE.
//

import Foundation

public struct GetPlaceDirectionRequest: Codable, Hashable {
    
    public var origin: String?
    public var destination: String?
    public var mode: String = "driving"
    public var key: String = "AIzaSyDg-bwviwDVeAhD_JPJt4mdCidS9dK4uvA"
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case origin = "origin"
        case destination = "destination"
        case mode = "mode"
        case key = "key"
    }
}
