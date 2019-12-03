//
//  AppStyle.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/7/10.
//  Copyright © 2018年 yangjx. All rights reserved.
//

import UIKit
import DeviceKit
extension Device {
    var isSafeMargin: Bool {
        get {
            let device = Device()
//            if  device == .iPhoneX || device == .simulator(.iPhoneX) ||
//                device == .iPhoneXs || device == .simulator(.iPhoneXs) ||
//                device == .iPhoneXsMax || device == .simulator(.iPhoneXsMax) ||
//                device == .iPhoneXr || device == .simulator(.iPhoneXr) {
//                return true
//            }
            if  device == .iPhoneX || device == .simulator(.iPhoneX) {
                return true
            }
            return false
        }
    }
}
struct AppStyle {
    /// 屏幕尺寸
    static let bounds = UIScreen.main.bounds
    /// 屏幕宽度
    static let width = AppStyle.bounds.width
    /// 屏幕高度
    static let height = AppStyle.bounds.height
    /// 导航栏高度
    static let navigationBarHeight: CGFloat = 44
    /// 状态栏高度
    static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
    /// 头部边距高度（导航栏+状态栏）
    static let topHeight: CGFloat = statusBarHeight + navigationBarHeight
    /// 底部安全区域
    static let safeBottom: CGFloat = Device().isSafeMargin ? 34 : 0
}
