//
//  LSYNoteVC.m
//  LSYReader
//
//  Created by okwei on 16/6/2.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYNoteVC.h"
#import "LSYCatalogViewController.h"
#import "LSYReadPageViewController.h"
#define kBottomSafeHeight (UIApplication.sharedApplication.statusBarFrame.size.height==44 ? 34 : 0)
static  NSString *noteCell = @"noteCell";
@interface LSYNoteVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tabView;
@property (nonatomic,strong) NoteEditView* editView;
@property (nonatomic,strong) NSMutableArray*arySelectItems;
@end

@implementation LSYNoteVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"readModel.notes" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tabView];
    UINib *pNib = [UINib nibWithNibName:@"BookNoteCell" bundle:nil];
    [self.tabView registerNib:pNib forCellReuseIdentifier:noteCell];
//    [self.tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:noteCell];
    _editView = (NoteEditView*)[[NSBundle mainBundle]loadNibNamed:@"NoteEditView" owner:nil options:nil].firstObject ;
    _editView.tableview = self.tabView;
    [self.view addSubview:_editView];
    _arySelectItems = [[NSMutableArray alloc]initWithCapacity:10];
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [_tabView reloadData];
    [LSYReadModel updateLocalModel:_readModel url:_readModel.resource]; //本地保存
}
-(UITableView *)tabView
{
    if (!_tabView) {
        _tabView = [[UITableView alloc] init];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabView.allowsMultipleSelectionDuringEditing = true ;
    }
    return _tabView;
}
#pragma mark - 工具方法
-(void)deleteAllSelected{
    for (LSYNoteModel*pModel in _arySelectItems) {
        [self deleteModel:pModel];
    }
    LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    [pReadPageVC RefreshPage];
    [_tabView reloadData];
}
-(void)deleteModel:(LSYNoteModel*)pnote{
    [bookdatabase deleteNote:(int)pnote.recordModel.chapter range:pnote.ChapterRange];
    [_readModel.notes removeObject:pnote];
    //zwqbgn
    LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    LSYChapterModel* pCurChapter=pReadPageVC.model.chapters[pnote.recordModel.chapter];
    [pCurChapter removeNoteAttribute:pnote.ChapterRange];
    //zwqend
}
#pragma mark - UITableView Delagete DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _readModel.notes.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookNoteCell *cell =[tableView dequeueReusableCellWithIdentifier:noteCell forIndexPath:indexPath];
LSYChapterModel*pSelectChapter=_readModel.chapters[_readModel.notes[indexPath.row].recordModel.chapter];
//    cell.textLabel.text = [pSelectChapter stringOfRange:_readModel.notes[indexPath.row].ChapterRange];
    LSYNoteModel* pNote = _readModel.notes[indexPath.row];
    NSString* strNote = pNote.note;
    cell.m_pTitle.text = pSelectChapter.title;
    cell.m_pBookTxt.text = [pSelectChapter stringOfRange:pNote.ChapterRange];
    cell.m_pTimerLabel.text = [GCTools getOldTimeTxt:pNote.date];
    [cell.m_pUserTxt setTitle:strNote forState:UIControlStateNormal];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  return  44.0f;
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //zwqbgn设置高亮
    if (!_tabView.isEditing) {
        LSYNoteModel*pNote=self.readModel.notes[indexPath.row];
        //  [LSYReadConfig shareInstance].HeightLightString=pNote.content;
        //LSYChapterModel*pChapter= _readModel.chapters[pNote.recordModel.chapter];
        // NSRange pageRange=[pChapter getPageRangeBy:pNote.ChapterRange withPage:pNote.recordModel.page];
        [LSYReadConfig shareInstance].HeightLightRange=pNote.ChapterRange;//pageRange;
        //zwqend
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        if ([self.delegate respondsToSelector:@selector(catalog:didSelectChapter:page:)]) {
            [self.delegate catalog:nil didSelectChapter:_readModel.notes[indexPath.row].recordModel.chapter page:_readModel.notes[indexPath.row].recordModel.page];
        }
    }else{
         [_arySelectItems addObject:_readModel.notes[indexPath.row]];
    }
   
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_arySelectItems removeObject:_readModel.notes[indexPath.row]];
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
    LSYNoteModel*pnote=_readModel.notes[indexPath.row];
    [self deleteModel:pnote];
   // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    LSYReadPageViewController*pReadPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    [pReadPageVC RefreshPage];
    [self.tabView reloadData];
    //zwqend
}
-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"readModel.notes"];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat fTableH = ViewSize(self.view).height-kNoteEditHeight-kBottomSafeHeight;
    _tabView.frame = CGRectMake(0,0,ViewSize(self.view).width,fTableH);
    _editView.frame = CGRectMake(0,fTableH,ViewSize(self.view).width, kNoteEditHeight);
}
//zwqbgn

@end
