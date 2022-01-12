//
//  GetPlaceAutoCompleteResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 12/1/2565 BE.
//

import Foundation

public struct GetPlaceAutoCompleteResponse: Codable, Hashable  {
    
    public var predictions: [PlaceItem]?
    public var status: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try predictions  <- decoder["predictions"]
        try status       <- decoder["status"]
    }
}

public struct PlaceItem: Codable, Hashable  {

    public var placeId: String?
    public var reference: String?
    public var structuredFormatting: PredictionsStructuredFormatting?
    public var geometry: GeometryItem?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try placeId                <- decoder["place_id"]
        try reference              <- decoder["reference"]
        try structuredFormatting   <- decoder["structured_formatting"]
        try geometry               <- decoder["geometry"]
    }
}

public struct PredictionsStructuredFormatting: Codable, Hashable  {

    public var mainText: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try mainText           <- decoder["main_text"]
    }
}

public struct GeometryItem: Codable, Hashable  {

    public var locationLat: Double?
    public var locationLng: Double?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try locationLat           <- decoder["location.lat"]
        try locationLng           <- decoder["location.lng"]
    }
}
