//
//  bookdatabase.h
//  LSYReader
//
//  Created by zhangwenqiang on 2017/1/16.
//  Copyright © 2017年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBNAME    @"Books.sqlite"
#define BookColumn1 @"ChapteName"
#define BookColumn2 @"ChapterPath"
#define BookColumn3 @"pagecount"
#define BookColumn4 @"isMenu"

#define NoteColumn1 @"ChapteIndex"
#define NoteColumn2 @"rangeBgn"//length为0的时候,表示页数
#define NoteColumn3 @"rangeLength"
#define NoteColumn4 @"noteText"
#define NoteColumn5 @"date"
@interface bookdatabase : NSObject
+(void)openDatabase;
+(void)close;
+(NSMutableArray*)getAllTableName;
+(NSMutableArray*)getAllChapter;
+(void)setCurBookID:(NSString*)pBookID;
+(NSString*)getCurBookID;
+(void)initTableBook;
+(void)insertChapter:(NSString*)pChapterName Path:(NSString*)pChapterPath PageCount:(NSUInteger)nCount isMenu:(BOOL)bMenu;
+(void)insertNote:(NSArray*)aryNote inRange:(NSRange)range inChapter:(NSUInteger)nChapterIndex;
+(void)deleteNote:(NSUInteger)nChapterIndex range:(NSRange)range;
+(void)deleteBook:(NSString*)pBookID;
+(void)deleteBook;
//设置当前的阅读进度
+(void)setRecord:(NSUInteger)nChapter page:(NSUInteger)nPage;
//获取当前的阅读记录
+(NSRange)getRecord;
//获取所有书签
+(NSMutableArray*)getAllBookmarks;
//获取所有笔记
+(NSMutableArray*)getAllNotes;
//根据章节路径,获取该章的标有笔记的范围
+(NSMutableArray*)getNotesRangeByChapterPath:(NSString*)pChapterPath;
//修改章节页数
+(void)UpdateChapterPage:(NSUInteger)nPage byPath:(NSString*)pChapterPath;
@end
