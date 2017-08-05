//
//  String+Extensions.swift
//  FREETEL
//
//  Created by Kazuya Ueoka on 2017/08/05.
//  Copyright © 2017 fromKK. All rights reserved.
//

import Foundation

extension String {
    func filterNumber() -> String {
        return String(self.unicodeScalars.filter(CharacterSet.decimalDigits.contains).map(Character.init))
    }
}
