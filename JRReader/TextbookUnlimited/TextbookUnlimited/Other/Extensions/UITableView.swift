//
//  UITableView.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/9/19.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import UIKit

extension UITableView {

    // MARK: - Register Views

    func register<T: UITableViewCell>(_: T.Type) where T: NibLoadable {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: NibLoadable {
        register(T.nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    // MARK: - Dequeuing

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T {
            return cell
        } else {
            fatalError("The dequeueReusableCell \(String(describing: T.self)) couldn't be loaded.")
        }
    }

    func dequeueReusableView<T: UITableViewHeaderFooterView>() -> T {
        if let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T {
            return view
        } else {
            fatalError("The dequeueReusableView \(String(describing: T.self)) couldn't be loaded.")
        }
    }
}
