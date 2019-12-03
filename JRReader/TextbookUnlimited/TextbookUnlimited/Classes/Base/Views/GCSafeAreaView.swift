//
//  GCSafeAreaView.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/8/15.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import UIKit
import SnapKit

class GCSafeAreaView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience init(subView: UIView, isBottom: Bool) {
        self.init(frame: CGRect.zero)
        self.addSubview(subView)
        if isBottom {
            subView.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-AppStyle.safeBottom)
            }
        } else {
            subView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(AppStyle.statusBarHeight)
            }
        }

    }
}
