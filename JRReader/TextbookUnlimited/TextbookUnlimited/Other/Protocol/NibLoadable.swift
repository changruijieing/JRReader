//
//  NibLoadable.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/9/19.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import UIKit

protocol NibLoadable: class {

    static var nib: UINib { get }
}

extension NibLoadable {

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension NibLoadable where Self: UIView {

    static func loadNib() -> Self {
        if let view = nib.instantiate(withOwner: nil, options: nil).first as? Self {
            return view
        } else {
            fatalError("The nib \(nib) expected its root view to be of type \(String(describing: self))")
        }
    }
}
