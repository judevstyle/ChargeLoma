//
//  Utils.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 6/30/21.
//

import Foundation

class Utils {
    static func jsonData(from object: Any) -> Data? {
        return try? JSONSerialization.data(withJSONObject: object, options: [])
    }
}
