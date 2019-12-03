//
//  GCBookShelfCell.swift
//  TextbookUnlimited
//
//  Created by xhgc on 2018/11/20.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import UIKit
class GCBookShelfCell: UICollectionViewCell {
    @IBOutlet weak var bookImageVIew: UIImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookSelectBtn: UIButton!
    @IBOutlet weak var mengbanView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @IBAction func bookSelectBtnAction(_ sender: Any) {
        print("书架每本书被点击-编辑")
    }
}
