//
//  PostReviewResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 7/2/2565 BE.
//

import Foundation

public struct PostReviewResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: ReviewData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode  <- decoder["statusCode"]
        try success     <- decoder["success"]
        try data        <- decoder["data"]
    }
}
