//
//  LSYReadPageViewController.h
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYReadModel.h"
#import "LSYTopMenuView.h"
#import "LSYMenuView.h"
@interface LSYReadPageViewController : UIViewController<LSYMenuViewDelegate>
@property (nonatomic,strong) NSURL *resourceURL;
@property (nonatomic,strong) LSYReadModel *model;
-(void)setCatalogVCTag:(NSInteger)nTag;
//+(void)loadURL:(NSURL *)url;
-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page;
//zwqbgn
-(void)hiddenMenu;
-(void)menuViewChangeMoonMode:(BOOL)bMoon;
//添加或删除笔记后,刷新本页面
-(void)RefreshPage;
//当前页是否加了书签
-(Boolean)isMarkChapter:(NSUInteger)nChapter page:(NSUInteger)nPage;
-(void)menuViewMark:(LSYTopMenuView *)topMenu;
-(void)changeReadBrightness:(CGFloat)fBrightness;
//tts方式读书
-(void)readBook;
//读下一页
//-(void)readNextPageCompleted:(void(^)())completedCallback;
//如果不是最后一页返回true,否则返回false.
-(BOOL)ShowNextPage;
//zwqend
@end
