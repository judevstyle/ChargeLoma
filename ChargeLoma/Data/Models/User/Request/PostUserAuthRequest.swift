//
//  PostUserAuthRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation

public struct PostUserAuthRequest: Codable, Hashable {
    
    public var uid: String?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case uid = "uid"
    }
}
