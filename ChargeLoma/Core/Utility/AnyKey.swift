//
//  AnyKey.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation

public struct AnyKey: CodingKey {
    public var stringValue: String
    public var intValue: Int?
    public init(stringValue: String) {
        self.stringValue = stringValue
    }

    public init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
