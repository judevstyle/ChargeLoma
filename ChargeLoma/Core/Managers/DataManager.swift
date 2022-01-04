//
//  DataManager.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation

class DataManager {
    
    static let instance:DataManager = DataManager()
    private var listPlugTypeMaster: [PlugTypeData] = []
    private var listProviderMaster: [ProviderData] = []
    
    init() {}
    
}

// SET
extension DataManager {
    func setPlugTypeMaster(items: [PlugTypeData]) {
        self.listPlugTypeMaster = items
    }
    
    func setProviderMaster(items: [ProviderData]) {
        self.listProviderMaster = items
    }
}

// GET
extension DataManager {
    func getPlugTypeMaster() -> [PlugTypeData] {
        return self.listPlugTypeMaster
    }
    
    func getProviderMaster() -> [ProviderData] {
        return self.listProviderMaster
    }
}
