//
//  NSLayoutConstraint+Extensions.swift
//  FREETEL
//
//  Created by Kazuya Ueoka on 2017/08/05.
//  Copyright © 2017 fromKK. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    
    func constant(_ constant: CGFloat) -> NSLayoutConstraint {
        self.constant = constant
        return self
    }
}
