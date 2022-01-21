//
//  PostUserRegisterRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation

public struct PostUserRegisterRequest: Codable, Hashable {
    
    public var uid: String?
    public var displayName: String?
    public var car: String?
    public var email: String?
    public var tel: String?
    public var avatar: String?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case uid = "uid"
        case displayName = "display_name"
        case car = "car"
        case email = "email"
        case tel = "tel"
        case avatar = "avatar"
    }
}
