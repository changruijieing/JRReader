//
//  GCBaseTableViewController.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/8/15.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import UIKit
import MJRefresh
class GCBaseTableViewController: GCBaseViewController {

    // MARK: - 属性
    var tableView: UITableView!
    private var placeHolderView: UIView?

    // MARK: - 重写方法
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableV = UITableView.init(frame: tableViewFrame() ?? view.bounds, style: tableViewStyle())
        tableV.backgroundColor = UIColor.white
        tableV.tableFooterView = UIView()
        self.tableView = tableV
        self.view.addSubview(tableV)
        if shouldHeaderRefresh() {
            self.tableView.mj_header = refreshHeader()
        }
        if shouldFooterRefresh() {
            self.tableView.mj_footer = refreshFooter()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - 子类可继承方法
    /// tableView尺寸
    open func tableViewFrame() -> CGRect? {
        return nil
    }
    /// tableView样式
    open func tableViewStyle() -> UITableViewStyle {
        return .plain
    }
    /// 空tableView占位
    open func makePlaceHolderView() -> UIView? {
        return nil
    }
    /// 是否设置头部刷新
    open func shouldHeaderRefresh() -> Bool {
        return false
    }
    /// 是否设置尾部刷新
    open func shouldFooterRefresh() -> Bool {
        return false
    }
    /// 下拉刷新View
    open func refreshHeader() -> MJRefreshHeader {
        return MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(refreshData))
    }

    /// 刷新数据
    @objc open func refreshData() {
        if self.tableView.mj_footer != nil {
            self.tableView.mj_footer.resetNoMoreData()
        }
    }
    /// 上拉加载更多View
    open func refreshFooter() -> MJRefreshFooter {
        return MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(fetchMoreData))
    }
    /// 加载更多数据
    @objc open func fetchMoreData() {

    }
    /// 结束资源加载
    open func endRefresh(_ isNoMore: Bool=false) {
        self.checkEmpty()
        if self.tableView.mj_header != nil && self.tableView.mj_header.isRefreshing {
            self.tableView.mj_header.endRefreshing()
        }
        if self.tableView.mj_footer != nil && self.tableView.mj_footer.isRefreshing {
            isNoMore ? self.tableView.mj_footer.endRefreshing() : self.tableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
}

extension GCBaseTableViewController {

}

extension GCBaseTableViewController {

    /// 检查是否列表为空
    func checkEmpty() {
        if makePlaceHolderView() == nil {
            return
        }
        var isEmpty = true
        guard let src = self.tableView.dataSource else { return }
        var sections = 1
        if src.responds(to: #selector(src.numberOfSections(in:))) {
            sections = src.numberOfSections!(in: self.tableView)
        }
        for i in 0..<sections {
            let rows = src.tableView(self.tableView, numberOfRowsInSection: i)
            if rows != 0 {
                isEmpty = false
                break
            }
        }
        if isEmpty {
            self.placeHolderView = makePlaceHolderView()
            self.placeHolderView?.frame = CGRect.init(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height)
            self.tableView.addSubview(self.placeHolderView!)
        } else {
            self.placeHolderView?.removeFromSuperview()
            self.placeHolderView = nil
        }
    }
}
