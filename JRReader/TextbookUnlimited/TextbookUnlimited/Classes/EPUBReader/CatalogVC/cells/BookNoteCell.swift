//
//  BookNoteCell.swift
//  TextbookUnlimited
//
//  Created by zhangwenqiang on 2017/11/2.
//  Copyright © 2017年 zhangwenqiang. All rights reserved.
//

import UIKit

class BookNoteCell: UITableViewCell {
    @IBOutlet weak var m_pTitle: UILabel!
    @IBOutlet weak var m_pBookTxt: UILabel!
    @IBOutlet weak var m_pUserTxt: UIButton!
    @IBOutlet weak var m_pTimerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        m_pUserTxt.titleLabel?.numberOfLines=0
        //238 220 170
     //   m_pUserTxt.layer.borderColor = UIColor.init(red: 238, green: 220, blue: 170, alpha: 0).cgColor
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        self.imageView?.image = #imageLiteral(resourceName: "checkbox1")
//        // Configure the view for the selected state
//    }

}
