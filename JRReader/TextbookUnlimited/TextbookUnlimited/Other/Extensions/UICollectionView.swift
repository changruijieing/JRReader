//
//  UICollectionView.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/9/19.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import UIKit

extension UICollectionView {

    // MARK: - Register

    func register<T: UICollectionViewCell>(_: T.Type) where T: NibLoadable {
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: Reusable>(elementKind: String, _: T.Type) where T: NibLoadable {
        register(T.nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: Reusable>(elementKind: String, _: T.Type) {
        register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
    }

    // MARK: - Dequeuing

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T {
            return cell
        } else {
            fatalError("The dequeueReusableCell \(String(describing: T.self)) couldn't be loaded.")
        }
    }

    func dequeueReusableView<T: UICollectionViewCell>(elementKind: String, for indexPath: IndexPath) -> T {
        if let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T {
            return view
        } else {
            fatalError("The dequeueReusableSupplementaryView \(String(describing: T.self)) couldn't be loaded.")
        }
    }
}
