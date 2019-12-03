//
//  LSYChapterVC.m
//  LSYReader
//
//  Created by okwei on 16/6/2.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYChapterVC.h"
#import "LSYCatalogViewController.h"
static  NSString *chapterCell = @"chapterCell";
@interface LSYChapterVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tabView;
@property (nonatomic) NSUInteger readChapter;
@end

@implementation LSYChapterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.tabView];
    [self addObserver:self forKeyPath:@"readModel.record.chapter" options:NSKeyValueObservingOptionNew context:NULL];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [_tabView reloadData];
    
}
-(UITableView *)tabView
{
    if (!_tabView) {
        _tabView = [[UITableView alloc] init];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tabView;
}
#pragma mark - UITableView Delagete DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return _readModel.chapters.count;
    return _readModel.menuChapters.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chapterCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chapterCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _readModel.menuChapters[indexPath.row].title;
    NSInteger nMenuIndex = [self Chapter2MenuIndex:_readModel.record.chapter];
    if (indexPath.row == nMenuIndex) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        //crj调整侧滑栏UI-目录章节颜色20181128
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#e34066"];
    }else{
        //crj调整侧滑栏UI
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(catalog:didSelectChapter:page:)]) {
        NSInteger nChapterIndex = [self Menu2ChapterIndex:indexPath.row];
        [self.delegate catalog:nil didSelectChapter:nChapterIndex page:0];
    }
}
-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"readModel.record.chapter"];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tabView.frame = CGRectMake(0, 0, ViewSize(self.view).width, ViewSize(self.view).height);
}
#pragma mark menu和chapter位置转换
-(NSInteger)Chapter2MenuIndex:(NSInteger)nChapterIndex{
    NSInteger nRet = 0 ;
    NSArray*ary1=_readModel.chapters;
    NSArray* ary2=_readModel.menuChapters;
    if (nChapterIndex<ary1.count) {
        LSYChapterModel*pChapter = ary1[nChapterIndex];
        for (LSYChapterModel* pMenuChapter in ary2) {
            if ([pMenuChapter.title isEqualToString:pChapter.title]){
                nRet =[ary2 indexOfObject:pMenuChapter];
                break;
            }
        }
    }
    return nRet;
}
-(NSInteger)Menu2ChapterIndex:(NSInteger)nMenuIndex{
    return [self changeIndex:nMenuIndex form:_readModel.menuChapters to:_readModel.chapters];
}
-(NSInteger)changeIndex:(NSInteger)nIndex form:(NSArray*)ary1 to:(NSArray*)ary2{
    NSInteger nRet = 0;
    if (nIndex < ary1.count) {
        id pChapter = ary1[nIndex];
        if (pChapter) {
            nRet = [ary2 indexOfObject:pChapter];
            if (nRet == NSNotFound) {
                nRet = 0;
            }
        }
    }
    return nRet;
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
