//
//  GCBaseViewController.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/8/15.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import UIKit

class GCBaseViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        get {
            return false
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }

    ///  Designated initializer.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let classString = String(describing: type(of: self))
        if Bundle.main.path(forResource: classString, ofType: "xib") == nil {
            super.init(nibName: nil, bundle: nibBundleOrNil)
            return
        }
        super.init(nibName: nibNameOrNil ?? classString, bundle: nibBundleOrNil)
    }

    ///  Designated initializer.
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Debug Message
    deinit {

        dPrint("[❌] '" + String(describing: self.classForCoder) + "' is released.")
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        dPrint("[➡️] enter to --> '" + String(describing: self.classForCoder) + "'.")
    }

    override func viewDidDisappear(_ animated: Bool) {

        super.viewDidDisappear(animated)
        dPrint("[🕒] leave from <-- '" + String(describing: self.classForCoder) + "'.")
    }

}
