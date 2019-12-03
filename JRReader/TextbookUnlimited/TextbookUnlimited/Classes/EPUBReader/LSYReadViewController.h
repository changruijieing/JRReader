//
//  LSYReadViewController.h
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYRecordModel.h"
#import "LSYReadView.h"
@class LSYReadViewController;
@protocol LSYReadViewControllerDelegate <NSObject>
-(void)readViewEditeding:(LSYReadViewController *)readView;
-(void)readViewEndEdit:(LSYReadViewController *)readView;
@end
@interface LSYReadViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic,strong) NSString *content; //显示的内容
@property (nonatomic,strong) LSYRecordModel *recordModel;   //阅读进度
@property (nonatomic,strong) LSYReadView *readView;
@property (nonatomic,weak) id<LSYReadViewControllerDelegate>delegate;
//zwqbgn
@property (nonatomic,strong) UILabel*PageLabel;//zwq 页数
@property(nonatomic,strong)UIImageView* imageMark;
@property (nonatomic)NSUInteger nChapterIndex;//zwq 当前的章节数
@property (nonatomic)NSUInteger nChapterPage;//zwq在当前章节中的页数
@property(retain,nonatomic)UIScrollView*scrollView;//zwq 控制上下滚动事件
-(void)setMarkShow:(BOOL)bShow;//控制书签显示隐藏
//zwqend
@end
