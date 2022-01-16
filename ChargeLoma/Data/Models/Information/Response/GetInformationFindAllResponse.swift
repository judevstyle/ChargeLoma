//
//  GetInformationFindAllResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 15/1/2565 BE.
//

import Foundation

public struct GetInformationFindAllResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: [InformationItem]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode  <- decoder["statusCode"]
        try success     <- decoder["success"]
        try data        <- decoder["data"]
    }
}

public struct InformationItem: Codable, Hashable  {
    
    public var newsId: Int?
    public var title: String?
    public var desc: String?
    public var image: String?
    public var createdDate: String?
    public var updatedDate: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try newsId             <- decoder["news_id"]
        try title               <- decoder["title"]
        try desc                <- decoder["desc"]
        try image               <- decoder["image"]
        try createdDate        <- decoder["created_date"]
        try updatedDate        <- decoder["updated_date"]
    }
}
