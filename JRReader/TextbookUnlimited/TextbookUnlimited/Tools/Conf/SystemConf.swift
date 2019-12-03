//
//  SystemConf.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/8/8.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import Foundation

struct Conf {
    // MARK: - app相关
    static let appName          = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    static let appVersion       = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    static let appBundleId      = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    static let appleId: String  = ""

    static let strNone = "未知"
    // 下载文件的总文件夹
    static let BASE =  "ZFDownLoad"
    // 完整文件路径
    static let TARGET   = "CacheList"
    // 临时文件夹名称
    static let TEMP = "Temp"
    // 缓存主目录
    static let CACHES_DIRECTORY = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
    //学科分类归档路径
    static let ARCHIVE_SUBJECT_CLASSIFY_PATH = CACHES_DIRECTORY + "/subjectClassify.info"
}
