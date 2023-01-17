//
//  Bundle+Extension.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 19/2/2565 BE.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
