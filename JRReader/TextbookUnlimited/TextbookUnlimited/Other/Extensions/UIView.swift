//
//  UIView.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/7/10.
//  Copyright © 2018年 yangjx. All rights reserved.
//

import UIKit

// MARK: - UIView
extension UIView: Reusable {
}
// MARK: - UILabel
extension UILabel {

    /// 两端对齐
    func justiferLayout() {
        if self.text == nil {
            return
        }
        let textTmp     = self.text! as NSString
        let size        = CGSize(width: self.frame.width, height: CGFloat(MAXFLOAT))
        let att: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: self.font
        ]

        let textRect = textTmp.boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.truncatesLastVisibleLine, NSStringDrawingOptions.usesFontLeading], attributes: att, context: nil)

        let margin      = (self.frame.width - textRect.width) / CGFloat(textTmp.length - 1)
        let number      = NSNumber(value: Float(margin))
        let attribute   = NSMutableAttributedString(string: self.text!)
        let range = NSRange(location: 0, length: textTmp.length-1)
        attribute.addAttribute(NSAttributedStringKey.kern, value: number, range: range)
        self.attributedText = attribute
    }
}
