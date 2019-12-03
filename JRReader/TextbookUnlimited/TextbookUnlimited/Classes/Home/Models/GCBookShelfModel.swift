//
//  GCBookShelfModel.swift
//  TextbookUnlimited
//
//  Created by xhgc on 2018/11/26.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import SwiftyJSON
// struct 的写法会在获取元素在对象数组中位置、删除时出现找不到的情况
class GCBookShelfModel: NSObject {
    var bookName: String?
    var bookCoverImage: String?
    var isSelect: Bool?
    init(jsonData: JSON) {
        bookName = jsonData["title"].stringValue
        bookCoverImage = jsonData["coverUrl"].stringValue
        isSelect = jsonData["isSelect"].boolValue
    }
}
