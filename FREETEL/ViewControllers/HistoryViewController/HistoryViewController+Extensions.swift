//
//  HistoryViewController+Extensions.swift
//  FREETEL
//
//  Created by Kazuya Ueoka on 2017/08/05.
//  Copyright © 2017 fromKK. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import Realm
import RealmSwift

extension HistoryViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        
        if contactProperty.key == CNContactPhoneNumbersKey,
            let phoneNumber = contactProperty.contact.phoneNumbers.first?.value.stringValue.filterNumber(),
            !phoneNumber.isEmpty {
        
            let name = "\(contactProperty.contact.givenName) \(contactProperty.contact.familyName)"
            
            let url: URL = URL(string: "tel://\(Constants.prefix)\(phoneNumber)")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (result) in
                    if result {
                        try! History.create(name: name, phoneNumber: phoneNumber)
                    }
                })
            }
            
        }
        
    }
    
}
