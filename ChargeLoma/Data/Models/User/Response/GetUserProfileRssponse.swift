//
//  GetUserProfileRssponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation

public struct GetUserProfileRssponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: UserProfileData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode  <- decoder["statusCode"]
        try success     <- decoder["success"]
        try data        <- decoder["data"]
    }
}

public struct UserProfileData: Codable, Hashable  {
    
    public var uid: String?
    public var car: String?
    public var email: String?
    public var tel: String?
    public var avatar: String?
    public var displayName: String?
    public var typeUser: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try uid           <- decoder["uid"]
        try car           <- decoder["car"]
        try email         <- decoder["email"]
        try tel           <- decoder["tel"]
        try avatar        <- decoder["avatar"]
        try displayName   <- decoder["display_name"]
        try typeUser      <- decoder["type_user"]
    }
}
