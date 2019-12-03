//
//  LSYBottomMenuView.h
//  LSYReader
//
//  Created by Labanotation on 16/6/1.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYRecordModel.h"
#import "UIColor+Hex.h"
@protocol LSYMenuViewDelegate;
//@protocol LSYBottemMenuViewDelegate <NSObject>
//@optional
//-(void)bottemMenuViewDidHidden:(LSYBottomMenuView *)bottemMenu;
//-(void)bottemMenuViewDidAppear:(LSYBottomMenuView *)bottemMenu;
//@end

@interface LSYBottomMenuView : UIView<UITabBarDelegate>
@property (strong, nonatomic) IBOutlet UIView *m_pFontView;
@property (strong, nonatomic) IBOutlet UIView *m_pPlayView;
@property (strong, nonatomic) IBOutlet UIView *m_pColorView;
@property (weak, nonatomic) IBOutlet UITabBar *m_pTabbar;


@property (nonatomic,weak) id<LSYMenuViewDelegate>delegate;
@property (nonatomic,strong) LSYRecordModel *recordModel;
-(void)setMoonBrightness;
- (void)showPageView;
@end

@interface LSYThemeView : UIView

@end

@interface LSYReadProgressView : UIView
-(void)title:(NSString *)title progress:(NSString *)progress;
@end
