//
//  GCUpdateVersionView.swift
//  TextbookUnlimited
//
//  Created by chang on 2017/9/29.
//  Copyright © 2017年 zhangwenqiang. All rights reserved.
//

import UIKit

class GCUpdateVersionView: UIView {
    var parentVC: UIViewController?
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var featureTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.addTarget(self, action: #selector(cancelClick), for: UIControlEvents.touchUpInside)
        }
    }
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.addTarget(self, action: #selector(cancelClick), for: UIControlEvents.touchUpInside)
        }
    }
    @IBOutlet weak var updateButton: UIButton! {
        didSet {
            updateButton.addTarget(self, action: #selector(updateClick), for: UIControlEvents.touchUpInside)
        }
    }

    // MARK: - 提供快速通过xib创建的类方法
   class func loadUpdateVersionView() -> GCUpdateVersionView {
        return Bundle.main.loadNibNamed("GCUpdateVersionView", owner: self, options: nil)?.first as! GCUpdateVersionView
    }
}

extension GCUpdateVersionView {

    /// 取消
    @objc func cancelClick() {
        self.parentVC?.dismiss(animated: true, completion: nil)
    }
    /// 升级
    @objc func updateClick() {
        guard GCTools.shared.downloadUrl != "" else {
            return
        }
        let url = URL.init(string: GCTools.shared.downloadUrl)!
        UIApplication.shared.openURL(url)
    }
}
