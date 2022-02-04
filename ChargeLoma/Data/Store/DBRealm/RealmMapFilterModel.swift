//
//  RealmMapFilterModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 4/2/2565 BE.
//

import Foundation
import RealmSwift

class RealmMapFilterModel : Object {
    
    @objc private dynamic var structData:Data? = nil
    
    @objc dynamic var id: Int = -1
//    @objc public var productId: Int = -1

    override class func primaryKey() -> String? {
       return "id"
     }
    
    var mapFilter : MapFilterModel? {
        get {
            if let data = structData {
                return try? JSONDecoder().decode(MapFilterModel.self, from: data)
            }
            return nil
        }
        set {
            structData = try? JSONEncoder().encode(newValue)
        }
    }

    public func incrementID() -> Int {
    let realm = try! Realm()
      return (realm.objects(RealmMapFilterModel.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
