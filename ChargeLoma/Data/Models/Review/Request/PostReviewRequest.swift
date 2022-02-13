//
//  PostReviewRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 7/2/2565 BE.
//

import Foundation

public struct PostReviewRequest: Codable, Hashable {
    
    public var stId: String?
    public var comment: String?
    public var isCharge: Bool?
    public var pTypeId: Int?
    public var carServe: String?
    public var power: Int?
    public var reviewImg: [ReviewImgRequest]?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case stId = "st_id"
        case comment = "comment"
        case isCharge = "isCharge"
        case pTypeId = "p_type_id"
        case carServe = "car_serve"
        case power = "power"
        case reviewImg = "review_img"
    }
}

public struct ReviewImgRequest: Codable, Hashable {
    
    public var imgBase64: String?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case imgBase64 = "img_base64"
    }
}
