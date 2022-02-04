//
//  StoreManager.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 4/2/2565 BE.
//

import Foundation
import RealmSwift

struct StoreManager {
    
    static var shared = StoreManager()
    
    var realm: Realm!
    
    init() {
        self.realm = try! Realm()
    }
}

//MapFilter
extension StoreManager {
    
    func addMapFilter(_ item: MapFilterModel, completion: @escaping () -> Void) {
        let request = RealmMapFilterModel()
        request.id = request.incrementID()
        request.mapFilter = item
        
        try! self.realm.write({ () -> Void in
            self.realm.add(request)
            completion()
        })
    }
    
    
    func getMapFilter() -> MapFilterModel? {
        do {
            let objs = self.realm.objects(RealmMapFilterModel.self)
            return objs.first?.mapFilter
        } catch _ {
            return nil
        }
    }
    
    func clearMapFilter(completion: (() -> Void)? = nil) {
        do {
            let objs = self.realm.objects(RealmMapFilterModel.self)
            
            for item in objs {
                try! self.realm.write {
                    self.realm.delete(item)
                }
            }
            completion?()
        } catch _ {
        }
    }
    
    func updateMapFilter(_ item: MapFilterModel, qty: Int, completion: @escaping () -> Void) {
        clearMapFilter(completion: {
            addMapFilter(item, completion: {
                completion()
            })
        })
    }
}
