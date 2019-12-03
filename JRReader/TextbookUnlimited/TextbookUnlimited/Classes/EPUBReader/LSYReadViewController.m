//
//  LSYReadViewController.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadViewController.h"

#import "LSYReadParser.h"
#import "LSYReadConfig.h"

#import "LSYReadPageViewController.h"
@interface  InsertLabel:UILabel
@end
@implementation  InsertLabel:UILabel
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
   //    self.backgroundColor=[UIColor grayColor];
        self.textColor=[UIColor whiteColor];
        self.textAlignment=NSTextAlignmentCenter;
    }
    return  self;
}
@end
@interface LSYReadViewController ()<LSYReadViewControllerDelegate>
@property(retain,nonatomic)UILabel*labelPull;
@property(retain,nonatomic)UILabel*labelPush;
@property(retain,nonatomic)UIView*pBookContentView;

@end

@implementation LSYReadViewController
static NSString* strPush=@"上拉关闭图书";
static NSString* strClose=@"抬起手指关闭图书";
static NSString* strPullOn=@"下拉添加书签";
static NSString* strPullOff=@"下拉删除书签";
static NSString* strMarkOn=@"抬起手指添加标签";
static NSString* strMarkOff=@"抬起手指删除标签";
- (void)viewDidLoad {
    [super  viewDidLoad];
    [self prefersStatusBarHidden];
    [self.view setBackgroundColor:[LSYReadConfig shareInstance].theme];
    //zwqbgn 添加下拉上滑效果
    CGRect rtScreen=self.view.bounds;
    _scrollView=[[UIScrollView alloc]initWithFrame:rtScreen];
    _pBookContentView=[[UIView alloc]initWithFrame:rtScreen];
    _scrollView.delegate=self;
    _scrollView.alwaysBounceVertical=YES;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [_scrollView addSubview:_pBookContentView];
    _scrollView.backgroundColor=[UIColor grayColor];
    [self setBgByMoonMode:[LSYReadUtilites isMoonMode]];
   // _pBookContentView.backgroundColor=[LSYReadConfig shareInstance].theme;

    [self.view addSubview:_scrollView];
    CGFloat fHeight=100;
    _labelPull=[[InsertLabel alloc]initWithFrame:CGRectMake(0, -fHeight, rtScreen.size.width, fHeight)];
    _labelPull.text=@"向下拉添加或删除书签";
    _labelPush=[[InsertLabel alloc]initWithFrame:CGRectMake(0, rtScreen.size.height, rtScreen.size.width, fHeight)];
    _labelPush.text=@"向上推关闭图书";

    [_pBookContentView addSubview:_labelPull];
    [_pBookContentView addSubview:_labelPush];
    
    [_pBookContentView addSubview:self.readView];
    [_pBookContentView addSubview:self.PageLabel];
    [self.view addSubview:self.imageMark];
//    [self.view addSubview:self.readView];
//    [self.view addSubview:self.PageLabel];
    //zwqend
    self.view.clipsToBounds=false;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:LSYThemeNotification object:nil];
}
-(void)changeTheme:(NSNotification *)no
{
    [LSYReadConfig shareInstance].theme = no.object;
    [_pBookContentView setBackgroundColor:[LSYReadConfig shareInstance].theme];
}
-(LSYReadView *)readView
{
    if (!_readView) {
        _readView = [[LSYReadView alloc] initWithFrame:[LSYReadParser getContentRect]];
      //  LSYReadConfig *config = [LSYReadConfig shareInstance];
       // _readView.frameRef = [LSYReadParser parserContent:_content config:config bouds:CGRectMake(0,0, _readView.frame.size.width, _readView.frame.size.height)];
        _readView.frameRef=[self getFrameRefByChapterAttributedTxt];
        //_readView.content = _content;
        _readView.delegate = self;
        [self setReadViewImgArray];
        //pagearray的设置放在给nchapterIndex赋值的时候
    }
    return _readView;
}

-(void)readViewEditeding:(LSYReadViewController *)readView
{
    if ([self.delegate respondsToSelector:@selector(readViewEditeding:)]) {
        [self.delegate readViewEditeding:self];
    }
}
-(void)readViewEndEdit:(LSYReadViewController *)readView
{
    if ([self.delegate respondsToSelector:@selector(readViewEndEdit:)]) {
        [self.delegate readViewEndEdit:self];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
#pragma mark zwq
-(void)setBgByMoonMode:(BOOL)bMoon
{
    if (bMoon) {
        _pBookContentView.backgroundColor=[UIColor blackColor];
    }else{
        _pBookContentView.backgroundColor=[LSYReadConfig shareInstance].theme;
    }
}
//是否收藏
-(Boolean)isMark
{
    Boolean bMark=false;
    LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    if(pReadPageVC)
    {
        bMark=[pReadPageVC isMarkChapter:_nChapterIndex page:_nChapterPage];
    }
    return bMark;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    Boolean bMark=[self isMark];
    CGFloat fOffsetY=scrollView.contentOffset.y;
  //  NSLog(@"fOffsetY:%f",fOffsetY);
    CGFloat fChange=80;
    if (fOffsetY<= -fChange)
    {
        _labelPull.text=bMark?strMarkOff:strMarkOn;
    }
    else if (fOffsetY<=0)
    {
        _labelPull.text=bMark?strPullOff:strPullOn;
    }
    else if(fOffsetY>=fChange)
    {
        _labelPush.text=strClose;
    }
    else if (fOffsetY>0)
    {
        _labelPush.text=strPush;
    }
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if ([_labelPush.text isEqualToString:strClose])
    {
        //关闭图书
        [bookdatabase deleteBook];
        [[LSYReadUtilites getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
    }
    else if ([_labelPull.text isEqualToString:strMarkOn]||[_labelPull.text isEqualToString:strMarkOff])
    {
        LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
        if(pReadPageVC){
            [pReadPageVC menuViewMark:nil];
        }
        if ([self isMark]){
            _imageMark.hidden=false;
        }else{
            _imageMark.hidden=true;
        }
    }
}
-(UILabel*)PageLabel
{
    if(!_PageLabel)
    {
        _PageLabel=[[UILabel alloc]initWithFrame:CGRectMake( self.view.frame.size.width-150,self.view.frame.size.height-40, 150, 30)];
        _PageLabel.font = [UIFont systemFontOfSize:14];
    }
    [self setBookPageByChapter:_nChapterIndex chapterPage:_nChapterPage];
    return _PageLabel;
}
-(UIImageView*)imageMark
{
    if (!_imageMark)
    {
        _imageMark=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sale_discount_yellow"]];
        _imageMark.frame=CGRectMake(self.view.frame.size.width-40, 0, 20, 40);
        if (![self isMark]) {
            _imageMark.hidden=true;
        }
    }
    return _imageMark;
}
-(void)setMarkShow:(BOOL)bShow{
    self.imageMark.hidden = !bShow;
}
-(void)setBookPageByChapter:(NSUInteger)nChapter chapterPage:(NSUInteger)nPage
{
    NSUInteger nPageCount=nPage;
    NSUInteger nCurPage=nPage;
    
    LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    if(pReadPageVC)
    {
        nPageCount=[pReadPageVC.model getBookPageCount];
        nCurPage=[pReadPageVC.model getBookPageByChapter:nChapter PageInChapter:nPage];
    }
    if(nCurPage==0)//第0页是封面，不显示页码
    {
        _PageLabel.text=nil;
    }
    else
    {
        NSString*pPage=[[NSString alloc]initWithFormat:@"第%lu页/共%lu页", (unsigned long)nCurPage,(unsigned long)nPageCount-1 ];
        _PageLabel.text=pPage;
    }

}
//通过attributedString和文字区域获取
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//通过章节的富文本获得
-(CTFrameRef)getFrameRefByChapterAttributedTxt
{
    LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    LSYChapterModel*pChapter=pReadPageVC.model.chapters[_nChapterIndex];
    NSMutableAttributedString *attributedString=pChapter.AttributedTxt;
    //zwqbgn 如果是夜间模式,则把字体变成白色
    if ([LSYReadUtilites isMoonMode]) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#575757"] range:NSMakeRange(0, [attributedString length])];
    }
    else
    {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString length])];
    }
    //zwqend
    NSRange range=[pReadPageVC.model.chapters[_nChapterIndex] getPageRange:_nChapterPage];
    CGRect bounds=CGRectMake(0,0, _readView.frame.size.width, _readView.frame.size.height);
    CTFrameRef pCTFrame=[LSYReadParser parserAttributedTxt:attributedString config:range bouds:bounds];
//    _readView.PageAttributedTxt=[[attributedString attributedSubstringFromRange:range]mutableCopy];
    _readView.ChapterAttributedTxt=attributedString;
    
//    UITextView*pTextView =[[UITextView alloc]initWithFrame:bounds];
//    [self.view addSubview:pTextView];
//    pTextView.attributedText=pChapter.AttributedTxt;
    return pCTFrame;
}

-(void)setReadViewImgArray
{
    //设置readview的图片数组为当前章节的图片数组
    LSYReadPageViewController*pPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    LSYChapterModel* pCurChapter=pPageVC.model.chapters[_nChapterIndex];
    _readView.imageArray=pCurChapter.imageArray;
    
}
@end
