//
//  MetaResponse.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation

public struct MetaResponse: Codable, Hashable  {
    
    public var totalItems: Int?
    public var itemCount: Int?
    public var itemsPerPage: Int?
    public var totalPages: Int?
    public var currentPage: Int?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try totalItems    <- decoder["totalItems"]
        try itemCount     <- decoder["itemCount"]
        try itemsPerPage  <- decoder["itemsPerPage"]
        try totalPages    <- decoder["totalPages"]
        try currentPage   <- decoder["currentPage"]
    }
}
