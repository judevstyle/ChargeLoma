//
//  PostUserRegisterResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation

public struct PostUserRegisterResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: UserRegisterData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode  <- decoder["statusCode"]
        try success     <- decoder["success"]
        try data        <- decoder["data"]
    }
}

public struct UserRegisterData: Codable, Hashable  {
    
    public var tokenType: String?
    public var token: String?
    public var user: UserProfileData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try tokenType <- decoder["tokenType"]
        try token     <- decoder["token"]
        try user      <- decoder["user"]
    }
}
