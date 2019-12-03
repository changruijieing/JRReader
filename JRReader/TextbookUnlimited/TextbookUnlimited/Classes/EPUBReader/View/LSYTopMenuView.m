//
//  LSYTopMenuView.m
//  LSYReader
//
//  Created by Labanotation on 16/6/1.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYTopMenuView.h"
#import "LSYMenuView.h"
#import "SearchResultVC.h"
#import "LSYReadPageViewController.h"
#define kStatusBarHeight UIApplication.sharedApplication.statusBarFrame.size.height+4.0f
NSString* g_strBookmark = @"book_label";
@interface LSYTopMenuView ()

@end
@implementation LSYTopMenuView
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
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.back];
    [self addSubview:self.more];
    [self addSubview:self.search];
//    [self addSubview:self.readBookBtn];// crj注释topMenu的听书，打算移到bottemMenu上 20181128
}
-(void)setState:(BOOL)state
{
    //标签功能暂时不用
    _state = state;
    if (state) {//@"mine_subscrib"
        [_more setImage:[[UIImage imageNamed:g_strBookmark] imageWithRenderingMode:UIImageRenderingModeAutomatic]forState:UIControlStateNormal];
        return;
    }
     [_more setImage:[[UIImage imageNamed:g_strBookmark] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    
}
-(UIButton *)back
{
    if (!_back) {
        _back = [LSYReadUtilites commonButtonSEL:@selector(backView) target:self];
        [_back setImage:[UIImage imageNamed:@"book_top_back"] forState:UIControlStateNormal];
    }
    return _back;
}
-(UIButton*)search
{
    if (!_search) {
        _search = [LSYReadUtilites commonButtonSEL:@selector(ShowSearchVC) target:self];
        [_search setImage:[UIImage imageNamed:@"book_earch"] forState:UIControlStateNormal];
        [_search setImageEdgeInsets:UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)];
    }
    return _search;
}
-(UIButton*)readBookBtn
{
    if (!_readBookBtn) {
        _readBookBtn = [LSYReadUtilites commonButtonSEL:@selector(readBook) target:self];
        [_readBookBtn setImage:[UIImage imageNamed:@"book_earphone"] forState:UIControlStateNormal];
        [_readBookBtn setImageEdgeInsets:UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)];
    }
    return _readBookBtn;
}
-(void)readBook//朗读书籍
{
    LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    if(pReadPageVC)
    {
        [pReadPageVC hiddenMenu];
        [pReadPageVC readBook];
    }
}
//加书签
-(UIButton *)more
{
    if (!_more) {
        _more = [LSYReadUtilites commonButtonSEL:@selector(moreOption) target:self];
        [_more setImage:[UIImage imageNamed:g_strBookmark] forState:UIControlStateNormal];
        [_more setImageEdgeInsets:UIEdgeInsetsMake(7.5, 12.5, 7.5, 12.5)];
    }
    return _more;
}
-(void)moreOption
{
    if ([self.delegate respondsToSelector:@selector(menuViewMark:)])
    {
        [self.delegate menuViewMark:self];
    }
}
-(void)backView
{
    //关闭图书
    [bookdatabase deleteBook];
    [[LSYReadUtilites getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
}
-(void)ShowSearchVC
{
    LSYReadPageViewController*pPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    if (pPageVC)
    {
        SearchResultVC*pSearchRetVC=[[SearchResultVC alloc]init];
        pSearchRetVC.dataList=pPageVC.model.chapters;
        [pPageVC presentViewController:pSearchRetVC animated:YES completion:^{
            [pSearchRetVC.searchController setActive:true];
        }];
        
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _back.frame = CGRectMake(0, kStatusBarHeight, 40, 40);
    _more.frame = CGRectMake(ViewSize(self).width-50, kStatusBarHeight, 40, 40);
    _search.frame=CGRectMake(ViewSize(self).width-100, kStatusBarHeight, 40, 40);
    _readBookBtn.frame=CGRectMake(ViewSize(self).width-150, kStatusBarHeight, 40, 40);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
