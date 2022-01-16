//
//  GetInformationFindAllRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 15/1/2565 BE.
//

import Foundation

public struct GetInformationFindAllRequest: Codable, Hashable {
    
    public var page: Int = 1
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
    }
}
