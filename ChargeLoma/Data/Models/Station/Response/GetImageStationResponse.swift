//
//  GetImageStationResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation

public struct GetImageStationResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: [ImageStationData]?
    public var meta: MetaResponse?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct ImageStationData: Codable, Hashable  {
    
    public var idImg: Int?
    public var imgPath: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try idImg    <- decoder["id_img"]
        try imgPath  <- decoder["img_path"]
    }
}
