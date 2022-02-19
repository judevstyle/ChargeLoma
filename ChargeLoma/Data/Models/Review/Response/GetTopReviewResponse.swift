//
//  GetTopReviewResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 17/2/2565 BE.
//

import Foundation

public struct GetTopReviewResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: [TopReviewData]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode  <- decoder["statusCode"]
        try success     <- decoder["success"]
        try data        <- decoder["data"]
    }
}

public struct TopReviewData: Codable, Hashable  {
    
    public var countReview: Int?
    public var User: UserProfileData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try countReview  <- decoder["countReview"]
        try User         <- decoder["User"]
    }
}
