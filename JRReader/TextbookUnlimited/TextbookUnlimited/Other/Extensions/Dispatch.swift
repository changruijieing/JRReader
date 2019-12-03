//
//  Dispatch.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/9/28.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import UIKit

// MARK: - ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral
extension DispatchTime: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value*1000))
    }
}
