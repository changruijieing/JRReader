//
//  RegExTool.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/8/3.
//  Copyright © 2018年 yangjx. All rights reserved.
//

import UIKit

struct RegExTool {

    /// 邮箱校验
    ///
    /// - Parameter dataStr: 校验的字符串
    /// - Returns: 校验结果
    static func checkEmail(_ dataStr: String) -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return self.baseCheckIsHas(for: regEx, data: dataStr)
    }

    /// 手机校验
    ///
    /// - Parameter dataStr: 校验的字符串
    /// - Returns: 校验结果
    static func checkMobilePhone(_ dataStr: String) -> Bool {
        let regEx = "^1[3|5|6|7|8][0-9]\\d{8}$"
        return self.baseCheckIsHas(for: regEx, data: dataStr)
    }

    /// 电话校验
    ///
    /// - Parameter dataStr: 校验的字符串
    /// - Returns: 校验结果
    static func checkLandline(_ dataStr: String) -> Bool {
        let regEx = "^(\\d{3,4}-)\\d{7,8}$"
        return self.baseCheckIsHas(for: regEx, data: dataStr)
    }

    /// 身份证号校验
    ///
    /// - Parameter dataStr: 校验的字符串
    /// - Returns: 校验结果
    static func checkIDCard(_ dataStr: String) -> Bool {
        let regEx = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)"
        return self.baseCheckIsHas(for: regEx, data: dataStr)
    }

    /// 小写字母校验
    ///
    /// - Parameter dataStr: 校验的字符串
    /// - Returns: 校验结果
    static func checkLowerCase(_ dataStr: String) -> Bool {
        let regEx = "^[a-z]+$"
        return self.baseCheckIsHas(for: regEx, data: dataStr)
    }
    /// 大写字母校验
    ///
    /// - Parameter dataStr: 校验的字符串
    /// - Returns: 校验结果
    static func checkUpperCase(_ dataStr: String) -> Bool {
        let regEx = "^[A-Z]+$"
        return self.baseCheckIsHas(for: regEx, data: dataStr)
    }
    /// 字母校验
    ///
    /// - Parameter dataStr: 校验的字符串
    /// - Returns: 校验结果
    static func checkLowerAndUpperCase(_ dataStr: String) -> Bool {
        let regEx = "^[A-Z]+$"
        return self.baseCheckIsHas(for: regEx, data: dataStr)
    }

    /// 字母和数字校验
    ///
    /// - Parameter dataStr: 校验的字符串
    /// - Returns: 校验结果
    static func checkNumberAndCase(_ dataStr: String) -> Bool {
        let regEx = "^[A-Za-z0-9]+$"
        return self.baseCheckIsHas(for: regEx, data: dataStr)
    }

    /// 数字校验
    ///
    /// - Parameter dataStr: 校验的字符串
    /// - Returns: 校验结果
    static func checkNumber(_ dataStr: String) -> Bool {
        let regEx = "^[0-9]*$"
        return self.baseCheckIsHas(for: regEx, data: dataStr)
    }

    /// 中文校验
    ///
    /// - Parameter dataStr: 校验的字符串
    /// - Returns: 校验结果
    static func checkChinese(_ dataStr: String) -> Bool {
        let regEx = "(^[\\u4e00-\\u9fa5]+$)"
        return self.baseCheckIsHas(for: regEx, data: dataStr)
    }

    /// 中文或中文符号校验
    ///
    /// - Parameter dataStr: 校验的字符串
    /// - Returns: 校验结果
    static func checkChineseChar(_ dataStr: String) -> Bool {
        let regEx = "[\\u0391-\\uFFE5]"
        return self.baseCheckIsHas(for: regEx, data: dataStr)
    }

    /// 特殊字符校验
    ///
    /// - Parameter dataStr: 校验的字符串
    /// - Returns: 校验结果
    static func checkSpecialChar(_ dataStr: String) -> Bool {
        let regEx = "((?=[\\x21-\\x7e]+)[^A-Za-z0-9])"
        return self.baseCheckIsHas(for: regEx, data: dataStr)
    }
}

// MARK: - 私有方法
private extension RegExTool {

    static func baseCheckIsHas(for regEx: String, data: String) -> Bool {

        let card = NSPredicate(format: "SELF MATCHES %@", regEx)

        if card.evaluate(with: data) {
            return true
        }

        return false
    }
}
