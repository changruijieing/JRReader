//
//  Notification.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/8/8.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import Foundation

extension Notification.Name {
    // MARK: - 网络监控
    public static let reachabilityChanged = Notification.Name("reachabilityChanged")
    public static let networkStatusChanged = Notification.Name("networkStatusChanged")

    // MARK: - 试卷试题页面相关
    public static let userAnswerChanged = Notification.Name("userAnswerChanged")

    // MARK: - 标签分类相关
    public static let userFavoriteChanged = Notification.Name("userFavoriteChanged")
}
