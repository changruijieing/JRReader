//
//  GCBookShelfVC.swift
//  TextbookUnlimited
//
//  Created by xhgc on 2018/11/8.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import UIKit
import SwiftyJSON
private let reuseIdentifier = "GCBookShelfCellID"
private let bookColumnSpace = 25.0 //列间距
private let bookRowSpace = 15.0 //行间距
private let collectMargin = 15.0
private let bookWidth = (AppStyle.width - CGFloat(collectMargin*2) - CGFloat(bookColumnSpace*2))/3
private let bookHeight = bookWidth*44/24
class GCBookShelfVC: UIViewController, UXReaderViewControllerDelegate {
    var isEdit = false //书架是否被编辑
    var isAllBtn = false // 编辑变成全选按钮
    var isAllSelect = false //全选/全不选
    var collectionView: UICollectionView!
    let deleteBtn = UIButton.init()// 删除按钮
    var books: NSMutableArray = NSMutableArray()
    func dismiss(_ viewController: UXReaderViewController) {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "书架"
        let rightItem = UIBarButtonItem.init(title: "编辑", style: .plain, target: self, action: #selector(gc_bookShelfEdit(sender:)))
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
       
//        let bookBtn = UIButton.init(frame: CGRect.init(x: 100, y: 300, width: 100, height: 100))
//        bookBtn.backgroundColor = Colors.fontRed
//        bookBtn.addTarget(self, action: #selector(showEpub), for: .touchUpInside)
//        bookBtn.setTitle("epub", for: .normal)
////        self.view.addSubview(bookBtn)
//        let pdfBtn = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
//        pdfBtn.backgroundColor = Colors.fontRed
//        pdfBtn.addTarget(self, action: #selector(showPDF), for: .touchUpInside)
//        pdfBtn.setTitle("pdf", for: .normal)
////        self.view.addSubview(pdfBtn)
        loadData()
        gc_bookCollectionView()
    }
    func loadData() {
        let jsonBooks = [["title": "围城", "isSelect": "0"], ["title": "这是一本pdf", "isSelect": "0"]]
//                         ["title": "这是第2本书", "isSelect": "0"],
//                         ["title": "这是第3本书", "isSelect": "0"],
//                         ["title": "这是第4本书", "isSelect": "0"],
//                         ["title": "这是第5本书", "isSelect": "0"],
//                         ["title": "这是第6本书", "isSelect": "0"],
//                         ["title": "这是第7本书", "isSelect": "0"],
//                         ["title": "这是第8本书", "isSelect": "0"],
//                         ["title": "这是第9本书", "isSelect": "0"],
//                         ["title": "这是第10本书", "isSelect": "0"],
//                         ["title": "这是第11本书", "isSelect": "0"],
//                         ["title": "这是第12本书", "isSelect": "0"],
//                         ["title": "这是第13本书", "isSelect": "0"],
//                         ["title": "这是第14本书", "isSelect": "0"],
//                         ["title": "这是第15本书", "isSelect": "0"],
//                         ["title": "这是第16本书", "isSelect": "0"],
//                         ["title": "这是第17本书", "isSelect": "0"],
//                         ["title": "这是第18本书", "isSelect": "0"],
//                         ["title": "这是第19本书", "isSelect": "0"],
//                         ["title": "这是第20本书", "isSelect": "0"],
//                         ["title": "这是第21本书", "isSelect": "0"],
//                         ["title": "这是第22本书", "isSelect": "0"],
//                         ["title": "这是第23本书", "isSelect": "0"],
//                         ["title": "这是第24本书", "isSelect": "0"],
//                         ["title": "这是第25本书", "isSelect": "0"],
//                         ["title": "这是第26本书", "isSelect": "0"],
//                         ["title": "这是第27本书", "isSelect": "0"],
//                         ["title": "这是第28本书", "isSelect": "0"],
//                         ["title": "这是第29本书", "isSelect": "0"]]
        let booksJson: [JSON] = JSON.init(jsonBooks).arrayValue
        for dic in booksJson {
            let model = GCBookShelfModel(jsonData: dic)
            books.add(model)
        }
    }
    @objc func gc_bookShelfEdit(sender: UIBarButtonItem) {
        isEdit = true
        isAllBtn = true
        let title = (isEdit == true) ? "全选" : "编辑"
        sender.title = title
        //变成全选按钮
        if isAllBtn == true {
            let leftItem = UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(gc_bookShelfEditFinish(sender:)))
            self.navigationItem.leftBarButtonItem = leftItem
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            // 遍历对象数组
            let selectArray = NSMutableArray()
            for book in books {
                var model = book as? GCBookShelfModel
                model?.isSelect = isAllSelect
                selectArray.add(model!)
            }
            books = selectArray
        }
        isAllSelect = !isAllSelect
        deleteBtn.isHidden = !isAllBtn
        collectionView.reloadData()
    }
    @objc func gc_bookShelfEditFinish(sender: UIBarButtonItem) {
        let leftItem = UIBarButtonItem.init()
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        isEdit = false
        isAllBtn = false
        isAllSelect = false
        deleteBtn.isHidden = !isAllBtn
        collectionView.reloadData()
    }
    @objc func gc_bookCollectionView() {
        let layout = GCBookShelfFlowLayout.init()
        layout.maximumInteritemSpacing = CGFloat(bookColumnSpace)
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-AppStyle.safeBottom)
            make.right.equalToSuperview().offset(0)
        }
        collectionView.backgroundColor = UIColor.white
        //删除按钮
        deleteBtn.setTitle("删除", for: .normal)
        self.view.addSubview(deleteBtn)
        deleteBtn.backgroundColor = Colors.viewBgLightGray
        deleteBtn.isHidden = true
        deleteBtn.setTitleColor(Colors.fontblue, for: .normal)
        deleteBtn.addTarget(self, action: #selector(gc_bookDeleteBtnAction(sender:)), for: .touchUpInside)
        deleteBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-AppStyle.safeBottom)
        }
        //注册cell
        let nibCell = UINib.init(nibName: "GCBookShelfCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: reuseIdentifier)
        layout.minimumLineSpacing = CGFloat(bookRowSpace)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @objc func gc_bookDeleteBtnAction(sender: UIButton) {
//        UIAlertView.init(title: "确认要删除选中的图书吗?", message: "确认要删除选中的图书吗?", delegate: <#T##Any?#>, cancelButtonTitle: <#T##String?#>)
//        UIAlertView.init(title:  "确认要删除选中的图书吗?", message:  "确认要删除选中的图书吗?", delegate: <#T##UIAlertViewDelegate?#>, cancelButtonTitle: "取消", otherButtonTitles: <#T##String#>, <#T##moreButtonTitles: String...##String#>)
        //1.删除books中选中的状态的数据 2.reload
        let deleteArray = NSMutableArray.init(array: books)
        for book in books {
            let model = book as! GCBookShelfModel
            
            if model.isSelect == true {
                deleteArray.remove(model) 
            }
        }
        books = deleteArray
        collectionView.reloadData()
    }
}
//collectionView的
extension GCBookShelfVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GCBookShelfCell
        let model: GCBookShelfModel  = books[indexPath.row] as! GCBookShelfModel
        // 打开pdf 或epub
        let num = indexPath.row%2
        let houzhui = num == 0 ? ".epub" : ".pdf"
         num == 0 ? (cell.bookImageVIew.image = UIImage.init(named: "weicheng")) : (cell.bookImageVIew.image = UIImage.init(named: "book_cover"))
        cell.bookNameLabel.text = (model.bookName ?? "") + houzhui
      
        cell.mengbanView.isHidden = !isEdit
        cell.bookSelectBtn.isHidden = !isEdit
        cell.bookSelectBtn.isSelected = model.isSelect!
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(CGFloat(bookColumnSpace), CGFloat(collectMargin), 15, CGFloat(collectMargin))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: bookWidth, height: bookHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? GCBookShelfCell
        if isAllBtn == true {
            let model: GCBookShelfModel  = books[indexPath.row] as! GCBookShelfModel
            let nowSelect = model.isSelect!
            model.isSelect = !nowSelect
            books.replaceObject(at: indexPath.row, with: model)
            cell?.bookSelectBtn.isSelected = !nowSelect
        } else {
            // 打开pdf 或epub
            let num = indexPath.row%2
            if num == 0 {
                showEpub()
            } else {
                showPDF()
            }
        }
    }
    @objc func showEpub() {
        //_ fileUrl: URL
        let epubPath = Bundle.main.path(forResource: "weicheng", ofType: "epub")
        let fileUrl = URL.init(fileURLWithPath: epubPath!)
        //准备数据库
        let strBookID = "weicheng"
        bookdatabase.setCurBookID(strBookID)
        //        if m_aryAttach.count>0 {
        //            let pDic = m_aryAttach.firstObject as! NSDictionary
        //            let strAttachCode = pDic["attachCode"] as! String
        //            let strBookID = self.srcCode + "_" + strAttachCode
        //            // [bookdatabase setCurBookID:pBookID];
        //            bookdatabase.setCurBookID(strBookID)
        //        }
        //reader
        let readerPageVC = LSYReadPageViewController.init()
        LSYReadUtilites.setReadPageVC(readerPageVC)
        readerPageVC.resourceURL = fileUrl
        readerPageVC.model = LSYReadModel.getLocalModel(with: fileUrl) as! LSYReadModel
        if readerPageVC.model.chapters.count <= 0 {
            MBProgressHUD.showError("资源为空")
            MBProgressHUD.closeWaiting()
            return
        }
        MBProgressHUD.closeWaiting()
        self.present(readerPageVC, animated: true, completion: {})
    }
    @objc func showPDF() {
        let fileStr = Bundle.main.path(forResource: "foxitpdf", ofType: "pdf")!
        let url = URL.init(string: fileStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        if url == nil { return }
        let fileName = url?.lastPathComponent
        //拷贝到用户目录
        let documnets: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! + "/" + fileName!
        MBProgressHUD.showWaiting("正在加载文档", to: self.view)
        if FileManager.default.fileExists(atPath: documnets) {
            MBProgressHUD.closeWaiting()
            guard let document = UXReaderDocument.init(url: URL.init(fileURLWithPath: documnets)) else { return }
            document.setUseNativeRendering()
            document.setHighlightLinks(false)
            document.setShowRTL(false)
            let readerViewController = UXReaderViewController.init()
            readerViewController.setDocument(document)
            readerViewController.delegate = self
            self.present(readerViewController, animated: true, completion: nil)
        } else {
            //            HTTP.downloadRequest(urlString: fileStr, success: { (url) in
            MBProgressHUD.closeWaiting()
            guard let document = UXReaderDocument.init(url: URL.init(fileURLWithPath: fileStr)) else { return }
            document.setUseNativeRendering()
            document.setHighlightLinks(false)
            document.setShowRTL(false)
            let readerViewController = UXReaderViewController.init()
            readerViewController.setDocument(document)
            readerViewController.delegate = self
            self.present(readerViewController, animated: true, completion: nil)
            //            }) { (error) in
            //                dPrint(error)
            //                MBProgressHUD.closeWaiting()
            //                MBProgressHUD.showError("加载失败,请稍后再试")
            //            }
        }
    }
}
