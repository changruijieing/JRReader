//
//  LSYBottomMenuView.m
//  LSYReader
//
//  Created by Labanotation on 16/6/1.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYBottomMenuView.h"
#import "LSYMenuView.h"

#import "LSYReadPageViewController.h"
#import "LSYReadModel.h"
#import "TextbookUnlimited-Swift.h"
@interface LSYBottomMenuView ()

@property (weak, nonatomic) IBOutlet UIView *m_pControlView;
@property (weak, nonatomic) IBOutlet UIImageView *m_pSliderBgImage;

@property (weak, nonatomic) IBOutlet UISlider *m_pPageSlider;
@property (weak, nonatomic) IBOutlet UISlider *m_pBrightnessSlider;
@property (weak, nonatomic) IBOutlet UISlider *m_pFontSizeSlider;
@property (weak, nonatomic) IBOutlet UILabel *m_pCurChapterNameLable;


@property (nonatomic,strong) LSYReadProgressView *progressView;



@end
@implementation LSYBottomMenuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
      
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}
-(void)setup{
    self.userInteractionEnabled = true;
    NSArray* pSubViews = [[NSBundle mainBundle]loadNibNamed:@"BookBottomSubMenu" owner:self options:nil];
    _m_pPlayView=pSubViews[0];
    _m_pColorView=pSubViews[1];
//    _m_pFontView=pSubViews[2];
    [self addSubMenu:_m_pPlayView];
    
    [self SetupPageSlider];
    [self addSubview:self.progressView];
    BOOL bMoonMode=[LSYReadUtilites isMoonMode];
    _m_pBrightnessSlider.value=bMoonMode?0:[LSYReadConfig shareInstance].brightness;
    _m_pFontSizeSlider.value=[LSYReadConfig shareInstance].fontSize;
    // crj增加slider滑块的背景图 20181129
    [_m_pBrightnessSlider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [_m_pFontSizeSlider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [_m_pPageSlider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    self.m_pTabbar.delegate = self;
    //阅读器底部tabbar的字体颜色
    for (UIBarButtonItem* pItem in self.m_pTabbar.items){
        UIColor *fontRed = [UIColor colorWithHexString:@"#999999"];
        [pItem setTitleTextAttributes:@{NSForegroundColorAttributeName: fontRed} forState:UIControlStateSelected];
        [pItem setTitleTextAttributes:@{NSForegroundColorAttributeName: fontRed} forState:UIControlStateNormal];
    }
    
    [self addObserver:self forKeyPath:@"recordModel.chapter" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"recordModel.page" options:NSKeyValueObservingOptionNew context:NULL];
    [[LSYReadConfig shareInstance] addObserver:self forKeyPath:@"fontSize" options:NSKeyValueObservingOptionNew context:NULL];
     [_m_pPageSlider addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

}
- (IBAction)fontValueChanged:(UISlider *)sender {
    //只取整数值，固定间距
    NSString *tempStr = [self numberFormat:sender.value];
    [sender setValue:tempStr.floatValue];
    CGFloat fCurFontSize= [LSYReadConfig shareInstance].fontSize;
    [LSYReadConfig shareInstance].fontOffset=tempStr.floatValue-fCurFontSize;
    [LSYReadConfig shareInstance].fontSize=tempStr.floatValue;
    if ([self.delegate respondsToSelector:@selector(menuViewFontSize:)]) {
        [self.delegate menuViewFontSize:self];
    }
}
//-(void)fontSliderTapAction:(UITapGestureRecognizer *)sender
//{
//    //取得点击点
//    CGPoint p = [sender locationInView:_m_pFontSizeSlider];
//    //计算处于背景图的几分之几，并将之转换为滑块的值（13~20）
//    float nX=_m_pFontSizeSlider.frame.origin.x;
//    float tempFloat = (p.x - nX) / 295.0 * 7 + 13;
//    NSString *tempStr = [self numberFormat:tempFloat];
//    //    NSLog(@"%f,%f,%@", p.x, tempFloat, tempStr);
//    [_m_pFontSizeSlider setValue:tempStr.floatValue];
//}
/**
 *  四舍五入
 *
 *  @param num 待转换数字
 *
 *  @return 转换后的数字
 */
- (NSString *)numberFormat:(float)num
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0"];
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    NSString*pCurChapterTitle=[_recordModel getRecordChapterModal].title;
    _m_pCurChapterNameLable.text=pCurChapterTitle;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _progressView.frame = CGRectMake(60, -60, ViewSize(self).width-120, 50);
    _m_pPlayView.frame=_m_pControlView.bounds;
}
-(LSYReadProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[LSYReadProgressView alloc] init];
        _progressView.hidden = YES;
        
    }
    return _progressView;
}
-(void)SetupPageSlider
{
    //zwqbgn将页数显示为整本书的页数
    NSUInteger nBookTotalPage=0;
    LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    if(pReadPageVC)
    {
        nBookTotalPage=[pReadPageVC.model getBookPageCount]-1;
        // nCurPage=[pReadPageVC.model getBookPageByChapter:nChapter PageInChapter:nPage];
    }
    //end
    _m_pPageSlider.maximumValue =  nBookTotalPage;//100;
}




- (IBAction)jumpChapter:(UIButton*)sender {
    if (sender.tag == 1) {
        if ([self.delegate respondsToSelector:@selector(menuViewJumpChapter:page:)]) {
            [self.delegate menuViewJumpChapter:(_recordModel.chapter == _recordModel.chapterCount-1)?_recordModel.chapter:_recordModel.chapter+1 page:0];
        }
    }
    else{
        if ([self.delegate respondsToSelector:@selector(menuViewJumpChapter:page:)]) {
            [self.delegate menuViewJumpChapter:_recordModel.chapter?_recordModel.chapter-1:0 page:0];
        }
        
    }
}
//页数拖动条数据改变
- (IBAction)changeMsg:(UISlider *)sender {
    //zwqbgn将页数显示为整本书的页数
    NSUInteger nBookTotalPage=0;
    NSUInteger nCurBookPage=0;
    NSString* strChapterTitle=@"";
    LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    if(pReadPageVC){
        nBookTotalPage=[pReadPageVC.model getBookPageCount]-1;
        nCurBookPage=sender.value;
        NSRange ChapterPage=[pReadPageVC.model getChapterPage:sender.value+1];
        strChapterTitle=pReadPageVC.model.chapters[ChapterPage.location].title;
    }
    //end
   // _slider.value = nCurBookPage;
    [_progressView title:strChapterTitle progress:[NSString stringWithFormat:@"%zi/%zi",nCurBookPage,nBookTotalPage]];
}
-(IBAction)changeMsgOver:(UISlider *)sender
{
    NSUInteger page =sender.value;
    NSRange ChapterPage=NSMakeRange(0, 0);
    LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    if(pReadPageVC)
    {
         ChapterPage=[pReadPageVC.model getChapterPage:(page+1)];
    }
  
    //ceil(([_recordModel getRecordChapterModal].pageCount-1)*sender.value/100.00);
    if ([self.delegate respondsToSelector:@selector(menuViewJumpChapter:page:)])
    {
        [self.delegate menuViewJumpChapter:ChapterPage.location   page:ChapterPage.length];
        NSString*pCurChapterTitle=[_recordModel getRecordChapterModal].title;
        _m_pCurChapterNameLable.text=pCurChapterTitle;
    }
    
}
-(IBAction)changeBrightness:(UISlider*)sender
{
//    CGFloat fValue=sender.value;
//    [[UIScreen mainScreen] setBrightness: fValue];
    LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    if(pReadPageVC)
    {
        [pReadPageVC changeReadBrightness:sender.value];
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"recordModel.chapter"] || [keyPath isEqualToString:@"recordModel.page"])
    {
        //zwqbgn将页数显示为整本书的页数
        NSUInteger nBookTotalPage=0;
        NSUInteger nCurBookPage=0;
        LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
        if(pReadPageVC)
        {
            nBookTotalPage=[pReadPageVC.model getBookPageCount]-1;
            _m_pPageSlider.maximumValue=nBookTotalPage;
            nCurBookPage=[pReadPageVC.model getBookPageByChapter:_recordModel.chapter PageInChapter:_recordModel.page];
        }
        //end
        _m_pPageSlider.value = nCurBookPage;
        [_progressView title:[_recordModel getRecordChapterModal].title progress:[NSString stringWithFormat:@"%zi/%zi",nCurBookPage,nBookTotalPage]];
    }
    else if ([keyPath isEqualToString:@"fontSize"]){
     //   _fontLabel.text = [NSString stringWithFormat:@"%d",(int)[LSYReadConfig shareInstance].fontSize];
    }
    else{
        if (_m_pPageSlider.state == UIControlStateNormal) {
            _progressView.hidden = YES;
        }
        else if(_m_pPageSlider.state == UIControlStateHighlighted){
            _progressView.hidden = NO;
        }
    }
    
}
-(UIImage *)thumbImage
{
    CGRect rect = CGRectMake(0, 0, 15,15);
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 5;
    [path addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/2) radius:7.5 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    {
        [[UIColor whiteColor] setFill];
        [path fill];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return image;
}
- (void)showPageView {
        [self addSubMenu:_m_pPlayView];
}
//crj修改阅读进度view为听书功能20181129
- (IBAction)showListenBookView:(UIButton *)sender {
//    [self addSubMenu:_m_pPlayView];
    LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    if(pReadPageVC)
    {
        [pReadPageVC hiddenMenu];
        [pReadPageVC readBook];
    }
}
- (IBAction)showColorView:(id)sender {
    [self addSubMenu:_m_pColorView];
}
- (IBAction)showFontView:(id)sender {
//    [self addSubMenu:_m_pFontView];
}
-(void)addSubMenu:(UIView*)pMenu
{
    pMenu.frame=_m_pControlView.bounds;
    [_m_pControlView addSubview:pMenu];
}
- (IBAction)showCatalog:(UIButton *)sender {
//-(void)showCatalog
//{
    if ([self.delegate respondsToSelector:@selector(menuViewInvokeCatalog:)]) {
        [self.delegate menuViewInvokeCatalog:self];
    }
}
-(void)showBrightslider
{
//    _brightSlider.hidden=_brightSlider.hidden?false:true;
//    _setView.hidden=_brightSlider.hidden?false:true;
}


-(void)dealloc
{
    [_m_pPageSlider removeObserver:self forKeyPath:@"highlighted"];
    [self removeObserver:self forKeyPath:@"recordModel.chapter"];
    [self removeObserver:self forKeyPath:@"recordModel.page"];
    [[LSYReadConfig shareInstance] removeObserver:self forKeyPath:@"fontSize"];
}

-(IBAction)changeTheme:(UIButton *)pBtn
{
    if([LSYReadUtilites isMoonMode]){
        [self clickSunOrMoon:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:LSYThemeNotification object:pBtn.backgroundColor];
}
-(IBAction)clickSunOrMoon:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickSunOrMoon" object:nil];
   
    [self setMoonBrightness];
}
-(void)setMoonBrightness{
    BOOL bMoonMode=[LSYReadUtilites isMoonMode];
    self.m_pBrightnessSlider.value=bMoonMode?0:[LSYReadConfig shareInstance].brightness;
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    tabBar.tintColor = [UIColor colorWithHexString:@"#C6244C"];
    switch ([tabBar.items indexOfObject:item]) {
        case 0:
            [self showCatalog:nil];
            break;
        case 1:
            [self showListenBookView:nil];
            break;
        case 2:
            [self showColorView:nil];
            break;
//        case 3:
//            [self showFontView:nil];
//            break;
        default:
            break;
    }
}
@end
#pragma mark LSYReadProgressView 拖动页面时显示的提示窗口
@interface LSYReadProgressView ()
@property (nonatomic,strong) UILabel *label;
@end
@implementation LSYReadProgressView
- (instancetype)init
{
    self = [super init];
    if (self) {
         [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        [self addSubview:self.label];
    }
    return self;
}
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:[LSYReadConfig shareInstance].fontSize];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
    }
    return _label;
}
-(void)title:(NSString *)title progress:(NSString *)progress
{
    if(!title){
        title = @"";
    }
    _label.text = [NSString stringWithFormat:@"%@\n%@",progress,title];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _label.frame = self.bounds;
}
@end
