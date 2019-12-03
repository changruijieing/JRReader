//
//  GCBookShelfFlowLayout.swift
//  TextbookUnlimited
//
//  Created by xhgc on 2018/11/21.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import Foundation

class GCBookShelfFlowLayout: UICollectionViewFlowLayout {
    public var maximumInteritemSpacing: CGFloat = 0.0
    // 为解决cell列间距问题
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        let num: Int = attributes?.count ?? 0
        if num > 0 {
            for i in 1..<num {
                let preAttr = attributes?[i-1]
                let curAttr = attributes?[i]
                let origin = preAttr?.frame.maxX
                //根据  maximumInteritemSpacing 计算出的新的 x 位置
                let targetX = (origin ?? 0) + maximumInteritemSpacing
                // 只有系统计算的间距大于  maximumInteritemSpacing 时才进行调整
                if curAttr?.frame.maxX ?? 0 > targetX {
                    // 换行时不用调整
                    if targetX + (curAttr?.frame.width ?? 0) < self.collectionViewContentSize.width {
                        var frame = curAttr?.frame
                        frame?.origin.x = targetX
                        curAttr?.frame = frame!
                    }
                }
            }
        }
        return attributes
    }
}
