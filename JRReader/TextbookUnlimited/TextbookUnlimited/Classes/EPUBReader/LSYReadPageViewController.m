//
//  LSYReadPageViewController.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadPageViewController.h"
#import "LSYReadViewController.h"
#import "LSYChapterModel.h"

#import "LSYCatalogViewController.h"
#import "UIImage+ImageEffects.h"
#import "LSYNoteModel.h"
#import "LSYMarkModel.h"
#import <objc/runtime.h>

#import "ZWQReadspeech.h"
#import "popMenu.h"
#define AnimationDelay 0.3

@interface LSYReadPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,LSYMenuViewDelegate,UIGestureRecognizerDelegate,LSYCatalogViewControllerDelegate,LSYReadViewControllerDelegate>
{
    NSUInteger _chapter;    //当前显示的章节
    NSUInteger _page;       //当前显示的页数
    NSUInteger _chapterChange;  //将要变化的章节
    NSUInteger _pageChange;     //将要变化的页数
    BOOL _isTransition;     //是否开始翻页
}
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,getter=isShowBar) BOOL showBar; //是否显示状态栏
@property (nonatomic,strong) LSYMenuView *menuView; //菜单栏
@property (nonatomic,strong) LSYCatalogViewController *catalogVC;//侧边栏
@property (nonatomic,strong) UIView * catalogView;  //侧边栏背景
@property (nonatomic,strong) LSYReadViewController *readView;   //当前阅读视图
@property (nonatomic,strong)UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIView *brightnessView;//遮罩层
@end

@implementation LSYReadPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.pageViewController];
    [_pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    _chapter = _model.record.chapter;
    _page = _model.record.page;
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolMenu:)];
    _tap.delegate = self;
    [self.view addGestureRecognizer:_tap];
    
    [self.view addSubview:self.menuView];
    
    [self addChildViewController:self.catalogVC];
    [self.view addSubview:self.catalogView];
    [self.catalogView addSubview:self.catalogVC.view];

    //添加笔记
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotes:) name:LSYNoteNotification object:nil];

}

-(void)addNotes:(NSNotification *)no
{
    LSYNoteModel *model = no.object;
    model.recordModel = [_model.record copy];//model是noteModel,_model是readModel
    //zwqbgn 笔记存储在chapter中,方便显示
    LSYChapterModel*pChapter=_model.chapters[_model.record.chapter];
    [pChapter addNoteAttribute:model.ChapterRange];
    [self RefreshPage];
    //zwqend
    [[_model mutableArrayValueForKey:@"notes"] addObject:model];    //这样写才能KVO数组变化
    [bookdatabase insertNote:@[model.note,model.date] inRange:model.ChapterRange inChapter:(int)_model.record.chapter];
    [LSYReadUtilites showAlertTitle:nil content:@"保存笔记成功"];
    
}

-(BOOL)prefersStatusBarHidden
{
    return !_showBar;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)showToolMenu:(UITapGestureRecognizer*)pTab
{
    //zwqbgn 点击事件是为了关闭弹出框
//    if(![popMenu sharedPopMenu].hidden)
//    {
//        [popMenu sharedPopMenu].hidden=true;
//        [_readView.readView setNeedsDisplay];
//        return;
//    }
    //先判断是否点击了链接
    CGPoint ptTab=[pTab locationInView:_readView.readView];
    NSString*strHref=[_readView.readView handleTapPoint:ptTab];
    //zwqend
    if (strHref)
    {
        for (LSYChapterModel* pChapterModel in _model.chapters) {
            if ([pChapterModel.filePath hasSuffix:strHref])
            {
                NSUInteger nIndex=[_model.chapters indexOfObject:pChapterModel];
                if([ZWQReadspeech shareInstance].synthsizer.speaking)
                {
                    [[ZWQReadspeech shareInstance]stopSpeak];
                }
                [self readChapter:nIndex page:0];
            }
        }
        return;
    }
    [_readView.readView cancelSelected];
    NSString * key = [NSString stringWithFormat:@"%d_%d",(int)_model.record.chapter,(int)_model.record.page];
    
    id state = _model.marksRecord[key];
    state?(_menuView.topView.state=1): (_menuView.topView.state=0);
    [self.menuView showAnimation:YES];
    
}

#pragma mark - init
-(LSYMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[LSYMenuView alloc] init];
        _menuView.hidden = YES;
        _menuView.delegate = self;
        _menuView.recordModel = _model.record;
    }
    return _menuView;
}
-(UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        [self.view addSubview:_pageViewController.view];
        [self.view addSubview:self.brightnessView];
    }
    return _pageViewController;
}
-(LSYCatalogViewController *)catalogVC
{
    if (!_catalogVC) {
        _catalogVC = [[LSYCatalogViewController alloc] init];
        _catalogVC.readModel = _model;
        _catalogVC.catalogDelegate = self;
    }
    return _catalogVC;
}
-(UIView *)catalogView
{
    if (!_catalogView) {
        _catalogView = [[UIView alloc] init];
        _catalogView.backgroundColor = [UIColor clearColor];
        _catalogView.hidden = YES;
        [_catalogView addGestureRecognizer:({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCatalog)];
            tap.delegate = self;
            tap;
        })];
    }
    return _catalogView;
}
#pragma mark - CatalogViewController Delegate 点击右侧目录区域触发事件
-(void)catalog:(LSYCatalogViewController *)catalog didSelectChapter:(NSUInteger)chapter page:(NSUInteger)page
{
     [_pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self updateReadModelWithChapter:chapter page:page];
    [self hiddenCatalog];
}
#pragma mark -  UIGestureRecognizer Delegate 解决TabView与Tap手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSInteger nTagCatalog = _catalogView.tag;
    NSInteger nTagView = touch.view.tag;
    if (nTagCatalog == 1//编辑状态返回
        ||nTagView == 1//不想响应手势
        ) {
        return NO;
    }
    
    NSString*strSelectControl = NSStringFromClass([touch.view class]);
    NSArray*aryNotGesture =@[@"UIView",
                           //  @"UITableView",
                             @"LSYReadView"//上下菜单
                             ];
    if ([aryNotGesture containsObject:strSelectControl]) {
        return YES;
    }
    return  NO;
}
#pragma mark - Privite Method 显示或隐藏目录栏
//电子书目录栏的显示和隐藏
-(void)setCatalogVCTag:(NSInteger)nTag{
    _catalogView.tag = nTag;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect rtFrame0 = self.view.frame;
    _pageViewController.view.frame = rtFrame0;
    _menuView.frame = rtFrame0;
    //zwq ios8上,切换笔记或书签,位置会不对
//    CGRect rtFrame1 = CGRectMake(-ViewSize(self.view).width, 0, 2*ViewSize(self.view).width, ViewSize(self.view).height);
     CGRect rtFrame1 = CGRectMake(0, 0, 2*ViewSize(self.view).width, ViewSize(self.view).height);
    _catalogView.frame = rtFrame1;
    CGRect rtFrame2 = CGRectMake(0, 0, ViewSize(self.view).width-100, ViewSize(self.view).height);
    _catalogVC.view.frame = rtFrame2;
    [_catalogVC reload];
}
-(void)catalogShowState:(BOOL)show
{
    show?({
        _catalogView.hidden = !show;
        [UIView animateWithDuration:AnimationDelay animations:^{
            _catalogView.frame = CGRectMake(0, 0,2*ViewSize(self.view).width, ViewSize(self.view).height);
        } completion:^(BOOL finished) {
            //原来的是蒙版效果
            UIView * maskView = [[UIImageView alloc] initWithImage:[self blurredSnapshot]];
            [_catalogView insertSubview:maskView atIndex:0];
        }];
    }):({
        //删除蒙版
        if ([_catalogView.subviews.firstObject isKindOfClass:[UIImageView class]]) {
            [_catalogView.subviews.firstObject removeFromSuperview];
        }
        [UIView animateWithDuration:AnimationDelay animations:^{
             _catalogView.frame = CGRectMake(-ViewSize(self.view).width, 0, 2*ViewSize(self.view).width, ViewSize(self.view).height);
        } completion:^(BOOL finished) {
            _catalogView.hidden = !show;
            
        }];
    });
}
-(void)hiddenCatalog
{
    [self catalogShowState:NO];
}
- (UIImage *)blurredSnapshot {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)), NO, 1.0f);
    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    UIGraphicsEndImageContext();
    return blurredSnapshotImage;
}
#pragma mark - Menu View Delegate
-(void)menuViewDidHidden:(LSYMenuView *)menu
{
     _showBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)menuViewDidAppear:(LSYMenuView *)menu
{
    _showBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
}
-(void)menuViewInvokeCatalog:(LSYBottomMenuView *)bottomMenu
{
    [_menuView hiddenAnimation:NO];
    [self catalogShowState:YES];
    
}

-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    [_pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self updateReadModelWithChapter:chapter page:page];
}
-(void)menuViewFontSize:(LSYBottomMenuView *)bottomMenu
{
    //zwqbgn以前只给当前章节修改字体,现在改为全部章节修改
    for(LSYChapterModel*pChapter in _model.chapters)
    {
         //[_model.record.chapterModel updateFont];
        [pChapter updateFont];
    }
   //zwqend
    LSYChapterModel*pRecordChapter=[_model.record getRecordChapterModal];
    [_pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:(_model.record.page>pRecordChapter.pageCount-1)?pRecordChapter.pageCount-1:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self updateReadModelWithChapter:_model.record.chapter page:(_model.record.page>pRecordChapter.pageCount-1)?pRecordChapter.pageCount-1:_model.record.page];
}

-(void)menuViewMark:(LSYTopMenuView *)topMenu
{
    NSString * key = [NSString stringWithFormat:@"%d_%d",(int)_model.record.chapter,(int)_model.record.page];
    id state = _model.marksRecord[key];
    if (state) {
//如果存在移除书签信息
         [self.readView setMarkShow:false];
        [_model.marksRecord removeObjectForKey:key];
        [[_model mutableArrayValueForKey:@"marks"] removeObject:state];
        [bookdatabase deleteNote:(int)_model.record.chapter range:NSMakeRange(_model.record.page, 0)];
    }else{
//记录书签信息
        [self.readView setMarkShow:true];
        LSYMarkModel *model = [[LSYMarkModel alloc] init];
        model.date = [NSDate date];
        model.recordModel = [_model.record copy];
        [[_model mutableArrayValueForKey:@"marks"] addObject:model];
        [_model.marksRecord setObject:model forKey:key];
        [bookdatabase insertNote:@[@"bookmark",@""] inRange:NSMakeRange(_model.record.page, 0) inChapter:_model.record.chapter];
    }
    _menuView.topView.state = !state;
}
#pragma mark - Create Read View Controller

-(LSYReadViewController *)readViewWithChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    //zwqbgn 先初始化章节的内容
    if (_model.chapters.count<=0) {
        printf("章节内容为空");
        return nil;
    }
    if (chapter>=_model.chapters.count) {
        chapter=0;
    }
    LSYChapterModel*pChapter=_model.chapters[chapter];
    [pChapter initChapterContentAndPagenate];
    //zwqend
    _readView = [[LSYReadViewController alloc] init];
    _readView.recordModel = _model.record;
    _readView.content = [_model.chapters[chapter] stringOfPage:page];
    _readView.delegate = self;

    _readView.nChapterIndex=chapter;
    _readView.nChapterPage=page;
  //  NSLog(@"_readGreate");
    return _readView;
}
-(void)updateReadModelWithChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    _chapter = chapter;
    _page = page;
    _model.record.chapter = chapter;
    _model.record.page = page;
    [bookdatabase setRecord:(int)chapter page:(int)page];
    [LSYReadModel updateLocalModel:_model url:_resourceURL];
}
#pragma mark - Read View Controller Delegate
-(void)readViewEndEdit:(LSYReadViewController *)readView
{
    for (UIGestureRecognizer *ges in self.pageViewController.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = YES;
            break;
        }
    }
}
-(void)readViewEditeding:(LSYReadViewController *)readView
{
    for (UIGestureRecognizer *ges in self.pageViewController.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = NO;
            break;
        }
    }
}
#pragma mark -PageViewController DataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
   // NSLog(@"before viewcontroller");
    if (_isTransition)
    {
        return nil;
    }
    _pageChange = _page;
    _chapterChange = _chapter;

    if (_chapterChange==0 &&_pageChange == 0) {
        return nil;
    }
    if (_pageChange<=0) {
        _chapterChange--;
        _pageChange = _model.chapters[_chapterChange].pageCount-1;
        LSYChapterModel*pChapter=_model.chapters[_chapterChange];
        [pChapter initChapterContentAndPagenate];
    }
    else{
        _pageChange--;
    }
    //_readView.scrollView.scrollEnabled=false;
    return [self readViewWithChapter:_chapterChange page:_pageChange];
    
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
   // NSLog(@"after viewcontroller");
    if (_isTransition)
    {
        return nil;
    }
   
    _pageChange = _page;
    _chapterChange = _chapter;
    if (_pageChange == _model.chapters.lastObject.pageCount-1 && _chapterChange == _model.chapters.count-1) {
        return nil;
    }
    if (_pageChange >= _model.chapters[_chapterChange].pageCount-1)
    {
        if (_chapterChange>=_model.chapters.count-1) {
            return nil;
        }
        _chapterChange++;
        _pageChange = 0;
        LSYChapterModel*pChapter=_model.chapters[_chapterChange];
        [pChapter initChapterContentAndPagenate];
    }
    else{
        _pageChange++;
    }
   // _readView.scrollView.scrollEnabled=false;
    return [self readViewWithChapter:_chapterChange page:_pageChange];
}
#pragma mark -PageViewController Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
   // _readView.scrollView.scrollEnabled=true;
    if ([ZWQReadspeech shareInstance].synthsizer.speaking)
    {
         [[ZWQReadspeech shareInstance]stopSpeak];
    }
    
    if(finished||completed)
    {
        _isTransition=NO;
    }
    if (!completed) {
        LSYReadViewController *readView = previousViewControllers.firstObject;
        _readView = readView;
        _page = readView.recordModel.page;
        _chapter = readView.recordModel.chapter;
    }
    else{
        [self updateReadModelWithChapter:_chapter page:_page];
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
   
    _chapter = _chapterChange;
    _page = _pageChange;
    //zwqbgn
    _isTransition=YES;
    [LSYReadConfig shareInstance].HeightLightRange=NSMakeRange(0, 0);
    [LSYReadConfig shareInstance].HeightLightString=nil;
    //zwqend
}

#pragma mark zwq
- (UIView *)brightnessView{
    if(!_brightnessView){
        _brightnessView = [[UIView alloc]init];
        _brightnessView.userInteractionEnabled=false;
        _brightnessView.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
        CGFloat fBright=[LSYReadConfig shareInstance].brightness;
        _brightnessView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kMaxTransparent - fBright];
    }
    return _brightnessView;
}
//隐藏目录界面
-(void)hiddenMenu
{
    [self.menuView hiddenAnimation:NO];
}
-(void)menuViewChangeMoonMode:(BOOL)bMoon
{
  //  [_readView changeToMoonMode:bMoon];
    [self RefreshPage];
    if (bMoon) {
        self.brightnessView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kMaxTransparent];
//        self.menuView.topView.backgroundColor = [UIColor colorWithHexString:@"#0e0e0f"];
    }else{
        CGFloat  fBrightness=[LSYReadConfig shareInstance].brightness;
        self.brightnessView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kMaxTransparent - fBrightness];
    }
    
}
-(void)RefreshPage
{
    
    [_pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:nil completion:nil];
    if ([_catalogView.subviews.firstObject isKindOfClass:[UIImageView class]])
    {
        [_catalogView.subviews.firstObject removeFromSuperview];
      //   [_catalogView insertSubview:[[UIImageView alloc] initWithImage:[self blurredSnapshot]] atIndex:0];
    }
}
-(void)readChapter:(NSUInteger)nChapterIndex page:(NSUInteger)nPage
{
    [_pageViewController setViewControllers:@[[self readViewWithChapter:nChapterIndex page:nPage]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self updateReadModelWithChapter:nChapterIndex page:nPage];
}
-(Boolean)isMarkChapter:(NSUInteger)nChapter page:(NSUInteger)nPage
{
    NSString * key = [NSString stringWithFormat:@"%zi_%zi",nChapter,nPage];
    id state = _model.marksRecord[key];
    if (state) {
        return  true;
    }
    return false;
}
-(void)changeReadBrightness:(CGFloat)fBrightness
{
    [LSYReadConfig shareInstance].brightness=fBrightness;
    self.brightnessView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kMaxTransparent - fBrightness];
}
-(void)readBook
{
    [[ZWQReadspeech shareInstance]speakWords:self.readView.content];
}
-(BOOL)ShowNextPage
{
    BOOL bRet=TRUE;
    _pageChange = _page;
    _chapterChange = _chapter;
    if (_pageChange == _model.chapters.lastObject.pageCount-1 && _chapterChange == _model.chapters.count-1) {
        return false;
    }
    if (_pageChange >= _model.chapters[_chapterChange].pageCount-1)
    {
        if (_chapterChange>=_model.chapters.count-1) {
            return nil;
        }
        _chapterChange++;
        _pageChange = 0;
        LSYChapterModel*pChapter=_model.chapters[_chapterChange];
        [pChapter initChapterContentAndPagenate];
    }
    else{
        _pageChange++;
    }
    [self readChapter:_chapterChange page:_pageChange];
    //[self readViewWithChapter:_chapterChange page:_pageChange];
    return bRet;
}
@end
