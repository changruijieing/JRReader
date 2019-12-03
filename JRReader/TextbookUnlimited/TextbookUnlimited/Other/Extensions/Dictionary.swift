//
//  Dictionary.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/7/10.
//  Copyright © 2018年 yangjx. All rights reserved.
//

import Foundation

// swiftlint:disable syntactic_sugar
/// 字典相加（相同类型）
///
/// - Parameters:
///   - left: 左边的字典
///   - right: 右边的字典
func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

/// 字典相加（相同类型）
///
/// - Parameters:
///   - left: 左边的字典
///   - right: 右边的字典
/// - Returns: 返回相加后的字典
func + <KeyType, ValueType> ( left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) -> Dictionary<KeyType, ValueType> {
    var temp = left
    for (k, v) in right {
        temp.updateValue(v, forKey: k)
    }
    return temp
}
// swiftlint:enable syntactic_sugar
