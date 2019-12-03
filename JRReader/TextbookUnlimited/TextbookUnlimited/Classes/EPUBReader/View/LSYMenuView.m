//
//  LSYMenuView.m
//  LSYReader
//
//  Created by Labanotation on 16/6/1.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYMenuView.h"
#import "LSYTopMenuView.h"
#import "LSYBottomMenuView.h"

#import "ZWQReadspeech.h"
#import "LSYReadUtilites.h"
#define AnimationDelay 0.3f
#define TopViewHeight UIApplication.sharedApplication.statusBarFrame.size.height+44.0f
#define BottomViewHeight 200.0f
@interface LSYMenuView ()<LSYMenuViewDelegate>

@end
@implementation LSYMenuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    [self addSubview:self.sunOrMoon];
    UITapGestureRecognizer* pTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf)];
    pTap.delegate=self;
    [self addGestureRecognizer:pTap];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickSunOrMoon:) name:@"ClickSunOrMoon" object:nil];
}
-(LSYTopMenuView *)topView
{
    if (!_topView) {
       CGRect rtTop = CGRectMake(0, -TopViewHeight, ViewSize(self).width,TopViewHeight);
       
        _topView = [[LSYTopMenuView alloc] initWithFrame:rtTop];
        _topView.delegate = self;
    }
    return _topView;
}
-(LSYBottomMenuView *)bottomView
{
    if (!_bottomView) {
        CGRect rtBottom = CGRectMake(0, ViewSize(self).height, ViewSize(self).width,BottomViewHeight);
        //_bottomView = [[LSYBottomMenuView alloc] initWithFrame:rtBottom];
        _bottomView = [[[NSBundle mainBundle]loadNibNamed:@"BookBottomMenuView" owner:nil options:nil]firstObject];
        _bottomView.frame = rtBottom;
        _bottomView.delegate = self;
    }
    return _bottomView;
}
-(void)setRecordModel:(LSYRecordModel *)recordModel
{
    _recordModel = recordModel;
    _bottomView.recordModel = recordModel;
}

#pragma mark - LSYMenuViewDelegate

-(void)menuViewInvokeCatalog:(LSYBottomMenuView *)bottomMenu
{
    if ([self.delegate respondsToSelector:@selector(menuViewInvokeCatalog:)]) {
        [self.delegate menuViewInvokeCatalog:bottomMenu];
    }
}
-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    if ([self.delegate respondsToSelector:@selector(menuViewJumpChapter:page:)]) {
        [self.delegate menuViewJumpChapter:chapter page:page];
    }
}
-(void)menuViewFontSize:(LSYBottomMenuView *)bottomMenu
{
    if ([self.delegate respondsToSelector:@selector(menuViewFontSize:)]) {
        [self.delegate menuViewFontSize:bottomMenu];
    }
}
-(void)menuViewMark:(LSYTopMenuView *)topMenu
{
    if ([self.delegate respondsToSelector:@selector(menuViewMark:)]) {
        [self.delegate menuViewMark:topMenu];
    }
}

#pragma mark -
-(void)hiddenSelf
{
    [self hiddenAnimation:YES];
}
-(void)showAnimation:(BOOL)animation
{
    [self initSubviewPositon];
    self.hidden = NO;
    [UIView animateWithDuration:animation?AnimationDelay:0 animations:^{
        CGRect rtMoon=CGRectMake(ViewSize(self).width-60, ViewSize(self).height-BottomViewHeight-60, 50, 50);
        _sunOrMoon.frame=rtMoon;
        _topView.frame = CGRectMake(0, 0, ViewSize(self).width, TopViewHeight);
        _bottomView.frame = CGRectMake(0, ViewSize(self).height-BottomViewHeight, ViewSize(self).width,BottomViewHeight);
        
    } completion:^(BOOL finished) {
        
    }];
    if ([self.delegate respondsToSelector:@selector(menuViewDidAppear:)]) {
        [self.delegate menuViewDidAppear:self];
        [self.bottomView showPageView];// crj阅读器菜单默认显示阅读进度 20181129
    }
    if([ZWQReadspeech shareInstance].synthsizer.speaking)
    {
        [[ZWQReadspeech shareInstance].synthsizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}
-(void)hiddenAnimation:(BOOL)animation
{
    [UIView animateWithDuration:animation?AnimationDelay:0 animations:^{
        _topView.frame = CGRectMake(0, -TopViewHeight, ViewSize(self).width, TopViewHeight);
        _bottomView.frame = CGRectMake(0, ViewSize(self).height, ViewSize(self).width,BottomViewHeight);
        _sunOrMoon.frame=CGRectMake(ViewSize(self).width-60, ViewOrigin(_bottomView).y-60, 0, 0);
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
    }];
    if ([self.delegate respondsToSelector:@selector(menuViewDidHidden:)]) {
        [self.delegate menuViewDidHidden:self];
    }
    if([ZWQReadspeech shareInstance].synthsizer.paused)
    {
        [[ZWQReadspeech shareInstance].synthsizer continueSpeaking];
    }
}
//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    _topView.frame = CGRectMake(0, -TopViewHeight, ViewSize(self).width,TopViewHeight);
//    _bottomView.frame = CGRectMake(0, ViewSize(self).height, ViewSize(self).width,BottomViewHeight);
//    _sunOrMoon.frame=CGRectMake(ViewSize(self).width-60, ViewOrigin(_bottomView).y-60, 0, 0);
//}
#pragma mark zwq
-(void)initSubviewPositon
{
    _topView.frame = CGRectMake(0, -TopViewHeight, ViewSize(self).width,TopViewHeight);
    _bottomView.frame = CGRectMake(0, ViewSize(self).height, ViewSize(self).width,BottomViewHeight);
    _sunOrMoon.frame=CGRectMake(ViewSize(self).width-60, ViewOrigin(_bottomView).y-60, 0, 0);
}
-(UIButton*)sunOrMoon
{
    if (!_sunOrMoon)
    {
        CGRect rtframe=CGRectMake(ViewSize(self).width-60, ViewOrigin(_bottomView).y-60, 0, 0);
        _sunOrMoon=[[UIButton alloc]initWithFrame:rtframe];
        BOOL bMoon=[LSYReadUtilites isMoonMode];
        UIImage*pImgBg=[UIImage imageNamed:@"moon"];
        if(bMoon){
            pImgBg=[UIImage imageNamed:@"sun"];
        }
        [_sunOrMoon setImage:pImgBg forState:UIControlStateNormal];
        //_sunOrMoon.backgroundColor=[UIColor redColor];
        [_sunOrMoon addTarget:self action:@selector(clickSunOrMoon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sunOrMoon;
}
-(void)clickSunOrMoon:(UIButton *)sender
{
    BOOL bMoon=[LSYReadUtilites isMoonMode];
    UIImage*pImgBg=[UIImage imageNamed:@"moon"];
    if(!bMoon)
    {
        pImgBg=[UIImage imageNamed:@"sun"];
    }
    [_sunOrMoon setImage:pImgBg forState:UIControlStateNormal];
    [LSYReadUtilites setMoonMode:!bMoon];
    if ([self.delegate respondsToSelector:@selector(menuViewChangeMoonMode:)])
    {
        [self.delegate menuViewChangeMoonMode:!bMoon];
    }
    [self.bottomView setMoonBrightness];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSString*strSelectControl = NSStringFromClass([touch.view class]);
    NSArray*aryNotGesture =@[@"UITableViewCellContentView",@"UITabBarButton"];
    if ([aryNotGesture containsObject:strSelectControl]) {
        return NO;
    }
    return  YES;
}
@end
