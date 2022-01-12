//
//  GetPlaceDetailRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 12/1/2565 BE.
//

import Foundation

public struct GetPlaceDetailRequest: Codable, Hashable {
    
    public var placeId: String?
    public var key: String = "AIzaSyDg-bwviwDVeAhD_JPJt4mdCidS9dK4uvA"
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case key = "key"
    }
}
