//
//  LSYCatalogViewController.m
//  LSYReader
//
//  Created by okwei on 16/6/2.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYCatalogViewController.h"
#import "LSYChapterVC.h"
#import "LSYNoteVC.h"
#import "LSYMarkVC.h"
@interface LSYCatalogViewController ()<LSYViewPagerVCDelegate,LSYViewPagerVCDataSource,LSYCatalogViewControllerDelegate>
@property (nonatomic,copy) NSArray *titleArray;
@property (nonatomic,copy) NSArray *VCArray;
@end

@implementation LSYCatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"目录",@"笔记",@"书签"];
    //crj调整电子书 侧滑栏 标签和笔记交换位置 20181128
    _VCArray = @[({
        LSYChapterVC *chapterVC = [[LSYChapterVC alloc]init];
        chapterVC.readModel = _readModel;
        chapterVC.delegate = self;
        chapterVC;
    }),({
        LSYMarkVC *markVC =[[LSYMarkVC alloc] init];
        markVC.readModel = _readModel;
        markVC.delegate = self;
        markVC;
    }),({
        LSYNoteVC *noteVC = [[LSYNoteVC alloc] init];
        noteVC.readModel = _readModel;
        noteVC.delegate = self;
        noteVC;
    })];
    self.forbidGesture = YES;
    self.delegate = self;
    self.dataSource = self;
}

-(NSInteger)numberOfViewControllersInViewPager:(LSYViewPagerVC *)viewPager
{
    return _titleArray.count;
}
-(UIViewController *)viewPager:(LSYViewPagerVC *)viewPager indexOfViewControllers:(NSInteger)index
{
    return _VCArray[index];
}
-(NSString *)viewPager:(LSYViewPagerVC *)viewPager titleWithIndexOfViewControllers:(NSInteger)index
{
    return _titleArray[index];
}
-(CGFloat)heightForTitleOfViewPager:(LSYViewPagerVC *)viewPager
{
    return 40.0f;
}
-(void)catalog:(LSYCatalogViewController *)catalog didSelectChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    if ([self.catalogDelegate respondsToSelector:@selector(catalog:didSelectChapter:page:)]) {
        [self.catalogDelegate catalog:self didSelectChapter:chapter page:page];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
