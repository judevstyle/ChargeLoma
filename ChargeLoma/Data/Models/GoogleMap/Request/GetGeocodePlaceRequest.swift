//
//  GetGeocodePlaceRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 13/2/2565 BE.
//

import Foundation

public struct GetGeocodePlaceRequest: Codable, Hashable {
    
    public var latlng: String?
    public var key: String = "AIzaSyDg-bwviwDVeAhD_JPJt4mdCidS9dK4uvA"
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case latlng = "latlng"
        case key = "key"
    }
}
