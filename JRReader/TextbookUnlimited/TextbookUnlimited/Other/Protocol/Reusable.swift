//
//  Reusable.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/9/19.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import UIKit

protocol Reusable: class {

    static var reuseIdentifier: String { get }
}

extension Reusable {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
