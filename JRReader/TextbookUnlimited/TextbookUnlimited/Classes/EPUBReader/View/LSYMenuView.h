//
//  LSYMenuView.h
//  LSYReader
//
//  Created by Labanotation on 16/6/1.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYRecordModel.h"
#import "LSYTopMenuView.h"
@class LSYMenuView;
@class LSYBottomMenuView;
@protocol LSYMenuViewDelegate <NSObject>
@optional
-(void)menuViewDidHidden:(LSYMenuView *)menu;
-(void)menuViewDidAppear:(LSYMenuView *)menu;
-(void)menuViewInvokeCatalog:(LSYBottomMenuView *)bottomMenu;
-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page;
-(void)menuViewFontSize:(LSYBottomMenuView *)bottomMenu;
-(void)menuViewMark:(LSYTopMenuView *)topMenu;
-(void)menuViewChangeMoonMode:(BOOL)bMoon;
@end
@interface LSYMenuView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic,weak) id<LSYMenuViewDelegate> delegate;
@property (nonatomic,strong) LSYRecordModel *recordModel;
@property (nonatomic,strong) LSYTopMenuView *topView;
@property (nonatomic,strong) LSYBottomMenuView *bottomView;
@property (nonatomic,strong) UIButton *sunOrMoon;//是否激活夜间模式
-(void)showAnimation:(BOOL)animation;
-(void)hiddenAnimation:(BOOL)animation;
@end
