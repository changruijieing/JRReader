//
//  NoteEditView.swift
//  TextbookUnlimited
//
//  Created by zhangwenqiang on 2017/11/22.
//  Copyright © 2017年 zhangwenqiang. All rights reserved.
//

import UIKit

class NoteEditView: UIView {
    @objc weak var tableview: UITableView?

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDel: UIButton!

    @IBAction func clickCancel(_ sender: UIButton) {
        self.setBtnState(false)
    }

    @IBAction func clickEdit(_ sender: UIButton) {
        self.setBtnState(true)
    }

    @IBAction func clickDet(_ sender: UIButton) {
        self.setBtnState(false)
        var pResponse = tableview?.superview?.next
        while !(pResponse is UIViewController) {
            pResponse = pResponse?.next
        }
        if pResponse is LSYMarkVC {
            let pMarkVC = pResponse as! LSYMarkVC
            pMarkVC.deleteAllSelected()
        } else if pResponse is LSYNoteVC {
            let pNoteVC = pResponse as! LSYNoteVC
            pNoteVC.deleteAllSelected()
        }
    }
    func setBtnState(_ bEdit: Bool) {
        btnCancel.isHidden = !bEdit
        btnDel.isHidden = !bEdit
        btnEdit.isHidden = bEdit
        if tableview != nil {
            tableview?.setEditing(bEdit, animated: true)
            tableview?.allowsSelection = bEdit
            tableview?.allowsMultipleSelectionDuringEditing = bEdit
        }
        let pReadPageVC = LSYReadUtilites.getReadPageVC() as! LSYReadPageViewController
        //1表示编辑状态,不隐藏电池条
        let nEdit = bEdit ? 1 : 0
        pReadPageVC.setCatalogVCTag(nEdit)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
