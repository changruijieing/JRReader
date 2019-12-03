//
//  UIButton.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/7/10.
//  Copyright © 2018年 yangjx. All rights reserved.
//

import UIKit

// MARK: - 构造方法
extension UIButton {
    convenience init (imageName: String, bgImageName: String) {
        self.init()

        setImage(UIImage(named: imageName), for: UIControlState())
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImageName), for: UIControlState())
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }

    convenience init(bgColor: UIColor, fontSize: CGFloat, title: String) {
        self.init()

        setTitle(title, for: UIControlState())
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
}

// MARK: - 实例方法
extension UIButton {

    /// 指定颜色背景
    func setBackgroundColor(_ color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(colorImage, for: forState)
    }
}
