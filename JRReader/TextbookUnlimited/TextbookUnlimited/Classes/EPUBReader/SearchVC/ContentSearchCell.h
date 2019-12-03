//
//  ContentSearchCell.h
//  LSYReader
//
//  Created by 张文强 on 2016/12/14.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ContentSearchModel : NSObject<NSCoding>
@property(nonatomic)NSUInteger nChapter;//查找结果在哪个章节
@property(nonatomic)NSRange rangeInChapter;//在本章中的位置
@property(nonatomic)BOOL bInTitle;//是否是章节的标题中
@property(nonatomic,strong)NSString*pChapterName;//所在章节名字


@end

@interface ContentSearchCell : UITableViewCell
@property(nonatomic,strong)ContentSearchModel* pSearchModel;//查找结果在哪个章节


@end
