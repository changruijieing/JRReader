//
//  AppDelegate+AppService.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/7/10.
//  Copyright © 2018年 yangjx. All rights reserved.
//

import UIKit
import IQKeyboardManager
extension AppDelegate {
    /// 初始化窗口
    func initWindow() {
        self.window                     = UIWindow.init(frame: AppStyle.bounds)
        self.window?.backgroundColor    = UIColor.white
        self.window?.makeKeyAndVisible()
    }
    /// 初始化第三方服务
    func initThirdService() {
        initializationIQKeyboard()
    }
    func initConf() {
        HTTP.setCookiePolicy()
        HTTP.monitorNetworkStatus()
//        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
    }
    /// 启动
    func appStart() {
        let bookShelfVC = GCBookShelfVC()
        let navVC = GCBaseNavigationController.init(rootViewController: bookShelfVC)
        navVC.isNavigationBarHidden = true
        self.window?.rootViewController = navVC
    }

}

// MARK: - private
fileprivate extension AppDelegate {
    func initializationIQKeyboard() {
        let manager = IQKeyboardManager.shared()
        manager.isEnabled = true
        manager.isEnableAutoToolbar = true
        manager.shouldResignOnTouchOutside = true
    }
}
