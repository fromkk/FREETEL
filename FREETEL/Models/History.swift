//
//  History.swift
//  FREETEL
//
//  Created by Kazuya Ueoka on 2017/08/05.
//  Copyright © 2017 fromKK. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class History: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var createdAt: Date = Date()
    
    static func create(name: String, phoneNumber: String) throws {
        let history = History()
        history.name = name
        history.phoneNumber = phoneNumber
        
        let realm = try Realm()
        try realm.write {
            realm.add(history)
        }
    }
}
