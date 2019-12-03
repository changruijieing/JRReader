//
//  AppDelegate.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/8/13.
//  Copyright © 2018年 yangjx. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.applicationIconBadgeNumber = 0
        initWindow()
        initThirdService()
        initConf()
        appStart()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        application.beginReceivingRemoteControlEvents()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.endReceivingRemoteControlEvents()
    }

}
