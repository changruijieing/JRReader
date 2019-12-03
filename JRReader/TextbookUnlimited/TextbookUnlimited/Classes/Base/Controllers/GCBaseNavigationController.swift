//
//  GCBaseNavigatonController.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/8/2.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import UIKit

class GCBaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.delegate = self
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 && !viewController.isKind(of: GCHomeTabBarVC.self) {
            let backItem = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_back"), style: UIBarButtonItemStyle.done, target: self, action: #selector(backBtnClick))
            viewController.navigationItem.leftBarButtonItem = backItem
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        for (count, viewController) in viewControllers.enumerated() {
            if count > 0 && viewControllers.count > 0 && !viewController.isKind(of: GCHomeTabBarVC.self) {
                let backItem = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_back"), style: UIBarButtonItemStyle.done, target: self, action: #selector(backBtnClick))
                viewController.navigationItem.leftBarButtonItem = backItem
            }
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
}

extension GCBaseNavigationController {
    @objc func backBtnClick() {
        self.popViewController(animated: true)
    }
    func initNavBar() {
        var naviBar = UINavigationBar.appearance()
        if #available(iOS 9.0, *) {
            naviBar = UINavigationBar.appearance(whenContainedInInstancesOf: [GCBaseNavigationController.self])
        }
        naviBar.setBackgroundImage(#imageLiteral(resourceName: "navbg"), for: .default)
        naviBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}

extension GCBaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let childs = self.childViewControllers
        guard let visibleVC = visibleViewController else {
            return false
        }
        if childs.count > 1 && !visibleVC.isKind(of: GCHomeTabBarVC.self) {
            return true
        } else {
            return false
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
