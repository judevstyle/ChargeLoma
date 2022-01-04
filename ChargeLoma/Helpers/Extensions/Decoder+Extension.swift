//
//  Decoder+Extension.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation

extension Decoder {
    public subscript(_ key: String) -> (Decoder, String) {
        return (self, key)
    }
}
