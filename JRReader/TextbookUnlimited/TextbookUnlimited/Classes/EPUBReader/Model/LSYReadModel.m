//
//  LSYReadModel.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadModel.h"

@implementation LSYReadModel
-(instancetype)init
{
    self = [super init];
    if (self){
        _chapters = [NSMutableArray array];
        [self initReadModel];
    }
    return self;
}
-(instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self) {
        _content = content;
        _chapters = [NSMutableArray array];
        [self initReadModel];
    }
    return self;
}
-(instancetype)initWithePub:(NSString *)ePubPath;
{
    self = [super init];
    if (self) {
        _chapters = [LSYReadUtilites ePubFileHandle:ePubPath];
        [self initReadModel];
    }
    return self;
}
-(void)initReadModel{
    _notes = [NSMutableArray array];
    _marks = [NSMutableArray array];
    _record = [[LSYRecordModel alloc] init];
    //_record.chapterModel = _chapters.firstObject;
    _record.chapterCount = _chapters.count;
    _marksRecord = [NSMutableDictionary dictionary];
    _menuChapters = [NSMutableArray array];
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.marks forKey:@"marks"];
    [aCoder encodeObject:self.notes forKey:@"notes"];
    [aCoder encodeObject:self.chapters forKey:@"chapters"];
     [aCoder encodeObject:self.menuChapters forKey:@"menuChapters"];
    [aCoder encodeObject:self.record forKey:@"record"];
    [aCoder encodeObject:self.resource forKey:@"resource"];
    [aCoder encodeObject:self.marksRecord forKey:@"marksRecord"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.marks = [aDecoder decodeObjectForKey:@"marks"];
        self.notes = [aDecoder decodeObjectForKey:@"notes"];
        self.chapters = [aDecoder decodeObjectForKey:@"chapters"];
        self.record = [aDecoder decodeObjectForKey:@"record"];
        self.resource = [aDecoder decodeObjectForKey:@"resource"];
        self.marksRecord = [aDecoder decodeObjectForKey:@"marksRecord"];
        self.menuChapters = [aDecoder decodeObjectForKey:@"menuChapters"];
    }
    return self;
}
+(void)updateLocalModel:(LSYReadModel *)readModel url:(NSURL *)url
{
   // return;
    NSString *key = [url.path lastPathComponent];
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:readModel forKey:key];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}
+(id)getLocalModelWithURL:(NSURL *)url
{
//    double date_s = CFAbsoluteTimeGetCurrent();
    LSYReadModel *model =nil;
   // NSString *key = [url.path lastPathComponent];
    //转换为数据库存储
    [bookdatabase openDatabase];
    NSString*pBookID=[bookdatabase getCurBookID];
    NSString*pTableName=[NSString stringWithFormat:@"book%@",pBookID];
    NSMutableArray*pAryBooks= [bookdatabase getAllTableName];
    if ([pAryBooks containsObject:pTableName])
    {
        model=[[LSYReadModel alloc]init];
        //笔记
        NSArray*aryNotes=[bookdatabase getAllNotes];
        for (NSDictionary*pDic in aryNotes)
        {
            LSYNoteModel*pNote=[[LSYNoteModel alloc]init];
            pNote.recordModel.chapter=((NSNumber*)pDic[NoteColumn1]).intValue;
            int nBgn=((NSNumber*)pDic[NoteColumn2]).intValue;
            int nLength=((NSNumber*)pDic[NoteColumn3]).intValue;
            pNote.ChapterRange=NSMakeRange(nBgn, nLength);
            pNote.note=pDic[NoteColumn4];
            pNote.date=[Tools NSString2Date:pDic[NoteColumn5]];
            [model.notes addObject:pNote];
        }
        //章节内容
        NSArray*aryChapters=[bookdatabase getAllChapter];
        for (NSDictionary*pDic in aryChapters)
        {
            LSYChapterModel*pChapter=[[LSYChapterModel alloc]init];
            int nPage = ((NSNumber*)pDic[BookColumn3]).intValue;
            pChapter.pageCount = nPage;
            int nInMenu = ((NSNumber*)pDic[BookColumn4]).intValue;
            pChapter.m_bInMenu = (nInMenu==1);
            pChapter.filePath=pDic[BookColumn2];
            pChapter.title=pDic[BookColumn1];
            [model.chapters addObject:pChapter];
        }
        model.record.chapterCount=[aryChapters count];
        NSRange rangRecord=[bookdatabase getRecord];
        model.record.chapter=rangRecord.location;
        model.record.page=rangRecord.length;
        //书签
        NSArray*aryBookmarks=[bookdatabase getAllBookmarks];
        for (NSDictionary*pDic in aryBookmarks)
        {
            LSYMarkModel*pMark=[[LSYMarkModel alloc]init];
            pMark.recordModel.chapter=((NSNumber*)pDic[NoteColumn1]).intValue;
            pMark.recordModel.page=((NSNumber*)pDic[NoteColumn2]).intValue;
            pMark.date=[Tools NSString2Date:pDic[NoteColumn5]];
            [model.marks addObject:pMark];
            NSString * key = [NSString stringWithFormat:@"%d_%d",(int)pMark.recordModel.chapter,(int)pMark.recordModel.page];
            model.marksRecord[key]=pMark;
        }
    }else{
        //数据库中没有
        [bookdatabase initTableBook];
        model=[[LSYReadModel alloc] initWithePub:url.path];
    }
    model.resource = url;
    //处理chapter和menu的关系
    for( LSYChapterModel* pChapter in model.chapters){
        if (pChapter.m_bInMenu) {
            [model.menuChapters addObject:pChapter];
        }
    }
    return model;
/*
    NSData* savedData=[[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!savedData)
    {
        if ([[key pathExtension] isEqualToString:@"txt"])
        {
            model = [[LSYReadModel alloc] initWithContent:[LSYReadUtilites encodeWithURL:url]];
        }
        else if ([[key pathExtension] isEqualToString:@"epub"])
        {
            NSLog(@"this is epub");
            model = [[LSYReadModel alloc] initWithePub:url.path];
            
        }
        else
        {
            @throw [NSException exceptionWithName:@"FileException" reason:@"文件格式错误" userInfo:nil];
        }
        if(model)
        {
            [LSYReadModel updateLocalModel:model url:url];
            model.resource = url;
        }
        
    }
    else
    {
        NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc]initForReadingWithData:savedData];
        model = [unarchive decodeObjectForKey:key];
        
    }
    for(int i=0;i<model.chapters.count;i++)
    {
        [model.chapters[i] addNoteAttributesBy:model.notes CurChapterIndex:i];
    }
    return model;
    */
}
#pragma mark zwq 获取页数
//zwq 获取图书总页数
-(NSUInteger)getBookPageCount
{
    NSUInteger nRet=0;
    for (LSYChapterModel*pChapter in self.chapters ) {
        nRet+=pChapter.pageCount;
    }
    return nRet;
}
//zwq 根据章节数和章节页数，计算出在整个书中的第几页
-(NSUInteger)getBookPageByChapter:(NSUInteger)nChapter PageInChapter:(NSUInteger)nChapterPage
{
    NSUInteger nRet=0;
    for (int i=0; i<nChapter; i++)
    {
        LSYChapterModel*pChapter=self.chapters[i];
        if (pChapter){
            nRet+=pChapter.pageCount;
        }else{
            NSLog(@"章节数没有对应的章节");
        }
    }
    nRet+=nChapterPage;
   // nRet+=1;
    return nRet;
}
#pragma mark 根据页数获取章节数 页数要从1开始
-(NSRange)getChapterPage:(NSUInteger)nBookPage{
    NSUInteger nChapterPage=0;
    NSUInteger nTotalChapterPage=0;
    NSUInteger i=0;
    NSUInteger nChapterIndex=0;
    while (nTotalChapterPage<nBookPage&&i<_chapters.count){
        nChapterIndex=i;
        nChapterPage=nBookPage-nTotalChapterPage-1;
        nTotalChapterPage+=self.chapters[i].pageCount;
        i++;
    }
    NSRange rangRet=NSMakeRange(nChapterIndex, nChapterPage);
    return rangRet;
}
@end
