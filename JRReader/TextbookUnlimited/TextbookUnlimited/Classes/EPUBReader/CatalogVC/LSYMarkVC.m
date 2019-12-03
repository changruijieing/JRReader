//
//  LSYMarkVC.m
//  LSYReader
//
//  Created by okwei on 16/6/2.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYMarkVC.h"
#import "LSYCatalogViewController.h"
#import "LSYReadPageViewController.h"
#define kBottomSafeHeight (UIApplication.sharedApplication.statusBarFrame.size.height==44 ? 34 : 0)
static  NSString *markCell = @"markCell";
@interface LSYMarkVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tabView;
@property (nonatomic,strong) NoteEditView* editView;
@property (nonatomic,strong) NSMutableArray*arySelectItems;
@end

@implementation LSYMarkVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"readModel.marks" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [_tabView reloadData];
    [LSYReadModel updateLocalModel:_readModel url:_readModel.resource]; //本地保存
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tabView];
    _editView = (NoteEditView*)[[NSBundle mainBundle]loadNibNamed:@"NoteEditView" owner:nil options:nil].firstObject ;
    _editView.tableview = self.tabView;
    [self.view addSubview:_editView];
    _arySelectItems = [[NSMutableArray alloc]initWithCapacity:10];
}

-(UITableView *)tabView
{
    if (!_tabView) {
        _tabView = [[UITableView alloc] init];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tabView.allowsMultipleSelectionDuringEditing = true;
//        _tabView.editing = true;
    }
    return _tabView;
}
#pragma mark - 工具方法
-(void)deleteAllSelected{
    for (LSYMarkModel*pModel in _arySelectItems) {
        [self deleteModel:pModel];
    }
    LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    [pReadPageVC RefreshPage];
    [_tabView reloadData];
}
-(void)deleteModel:(LSYMarkModel*)pMarkModel{
    [_readModel.marks removeObject:pMarkModel];
    
    [bookdatabase deleteNote:(int)pMarkModel.recordModel.chapter range:NSMakeRange(pMarkModel.recordModel.page, 0)];
    NSString * key = [NSString stringWithFormat:@"%zi_%zi",pMarkModel.recordModel.chapter,pMarkModel.recordModel.page];
    [_readModel.marksRecord  removeObjectForKey:key];
}
#pragma mark - UITableView Delagete DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _readModel.marks.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markCell];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:markCell];
        cell.textLabel.numberOfLines = 2;
    }
    //zwqbgn去掉记录中保存的chapter
    LSYChapterModel*pSelectChapter=_readModel.chapters[_readModel.marks[indexPath.row].recordModel.chapter];
    cell.textLabel.text = [pSelectChapter stringOfPage:_readModel.marks[indexPath.row].recordModel.page];
    cell.detailTextLabel.text = pSelectChapter.title;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!_tabView.isEditing) {
        if ([self.delegate respondsToSelector:@selector(catalog:didSelectChapter:page:)]) {
            [self.delegate catalog:nil didSelectChapter:_readModel.marks[indexPath.row].recordModel.chapter page:_readModel.marks[indexPath.row].recordModel.page];
        }
    }else{
        [_arySelectItems addObject:_readModel.marks[indexPath.row]];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_arySelectItems removeObject:_readModel.marks[indexPath.row]];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    LSYMarkModel*pMarkModel=[_readModel.marks objectAtIndex:indexPath.row];
    [self deleteModel:pMarkModel];
    [pReadPageVC RefreshPage];
    [tableView reloadData];
}
-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"readModel.marks"];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat fTableH = ViewSize(self.view).height-kNoteEditHeight-kBottomSafeHeight;
    _tabView.frame = CGRectMake(0,0,ViewSize(self.view).width,fTableH);
    _editView.frame = CGRectMake(0,fTableH,ViewSize(self.view).width, kNoteEditHeight);
}

@end
