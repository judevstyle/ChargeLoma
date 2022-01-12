//
//  GetPlaceAutoCompleteRequest.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 12/1/2565 BE.
//

import Foundation

public struct GetPlaceAutoCompleteRequest: Codable, Hashable {
    
    public var input: String = ""
    
    public var key: String = "AIzaSyDg-bwviwDVeAhD_JPJt4mdCidS9dK4uvA"
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case input = "input"
        case key = "key"
    }
}
