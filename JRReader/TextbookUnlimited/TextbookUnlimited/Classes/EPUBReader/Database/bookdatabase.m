//
//  bookdatabase.m
//  LSYReader
//
//  Created by zhangwenqiang on 2017/1/16.
//  Copyright © 2017年 okwei. All rights reserved.
//

#import "bookdatabase.h"


@implementation bookdatabase
static sqlite3 *db;
//决定了数据库中书的表名(book+bookID),收藏笔记表名(note+bookID)
static NSString*CurBookID;
+(void)openDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    NSLog(@"图书数据库路径:%@",database_path);
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
}
//每本书的表名是book+文件名
+(void)initTableBook
{
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS ";
    NSString*sqlBookTableContent=[NSString stringWithFormat:@"book%@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT,%@ TEXT,%@ INTEGER,%@ INTEGER)",CurBookID,BookColumn1,BookColumn2,BookColumn3,BookColumn4];
    NSString*sqlNoteTableContent=[NSString stringWithFormat:@"note%@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, %@ INTEGER,%@ INTEGER,%@ INTEGER,%@ TEXT,%@ TEXT)",CurBookID,NoteColumn1,NoteColumn2,NoteColumn3,NoteColumn4,NoteColumn5];
    NSString*sqlBookAll=[sqlCreateTable stringByAppendingString:sqlBookTableContent];
    NSString*sqlNoteAll=[sqlCreateTable stringByAppendingString:sqlNoteTableContent];
    [self execSql:sqlBookAll];
    [self execSql:sqlNoteAll];
}
+(void)execSql:(NSString *)sql
{
    char *err;
    int exec_result=sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err);
    if ( exec_result!= SQLITE_OK) {
        //sqlite3_close(db);
        NSLog(@"数据库操作数据失败!");
    }
}
+(void)insertChapter:(NSString*)pChapterName Path:(NSString*)pChapterPath PageCount:(NSUInteger)nCount isMenu:(BOOL)bMenu
{
  //  sqlite3_bind_blob(stmt, 7, [image bytes], [image length], NULL);
    NSInteger nIsMeun =  bMenu ? 1:0;
    NSString *sql1 = [NSString stringWithFormat:
                      @"INSERT INTO 'book%@' ('%@', '%@', '%@','%@') VALUES ('%@', '%@', %zi, %zi )",
                      CurBookID, BookColumn1,BookColumn2,BookColumn3,BookColumn4, pChapterName,pChapterPath,nCount,nIsMeun];
    [self execSql:sql1];
}
+(void)insertNote:(NSArray*)aryNote inRange:(NSRange)range inChapter:(NSUInteger)nChapterIndex
{
    NSString* strNow = [GCTools date2String:[NSDate date] :@"yyyy-MM-dd HH:mm:ss"];
    NSString *sql1 = [NSString stringWithFormat:
                      @"INSERT INTO 'note%@' ('%@','%@','%@','%@','%@') VALUES (%zi, %zi, %zi,'%@', '%@')",
                      CurBookID, NoteColumn1,NoteColumn2,NoteColumn3, NoteColumn4,NoteColumn5,nChapterIndex,range.location ,range.length,aryNote[0],strNow];
    [self execSql:sql1];
}
+(void)deleteNote:(NSUInteger)nChapterIndex range:(NSRange)range
{
    NSString *sql1 = [NSString stringWithFormat:@"DELETE FROM note%@ WHERE %@=%zi and %@=%zi and %@=%zi and %@ NOT LIKE 'record'" ,CurBookID,NoteColumn1,nChapterIndex,NoteColumn2,range.location,NoteColumn3,range.length,NoteColumn4];
    [self execSql:sql1];
}
+(void)deleteBook:(NSString*)pBookID
{
    NSString *sql1 = [NSString stringWithFormat:@"DROP TABLE book%@",pBookID];
    NSString *sql2 = [NSString stringWithFormat:@"DROP TABLE note%@",pBookID];
    [self execSql:sql1];
    [self execSql:sql2];
}
+(void)deleteBook{
   // [bookdatabase deleteBook:CurBookID];
}
+(void)close
{
    sqlite3_close(db);
}
+(void)setCurBookID:(NSString*)pBookID
{
    CurBookID=pBookID;
}
+(NSString*)getCurBookID{
    return CurBookID;
}
+(void)setRecord:(NSUInteger)nChapter page:(NSUInteger)nPage
{
    sqlite3_stmt *statement;
    NSString *getRecordInfo =[NSString stringWithFormat: @"select * from note%@ where %@='record'",CurBookID,NoteColumn4];
    sqlite3_prepare_v2(db, [getRecordInfo UTF8String], -1, &statement, nil);
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        sqlite3_finalize(statement);
        NSString *sql1 = [NSString stringWithFormat:
                          @"UPDATE note%@ set %@=%zi,%@ =%zi where %@= 'record'",
                          CurBookID, NoteColumn1,nChapter,NoteColumn2,nPage, NoteColumn4];
        [self execSql:sql1];
    }
    else
    {
        sqlite3_finalize(statement);
        NSString *sql1 = [NSString stringWithFormat:
                          @"INSERT INTO 'note%@' ('%@','%@','%@','%@','%@') VALUES (%zi, %zi, %d,'%@', '%@')",
                          CurBookID, NoteColumn1,NoteColumn2,NoteColumn3, NoteColumn4,NoteColumn5,nChapter,nPage ,0,@"record",@""];
        [self execSql:sql1];
    }
    
}
#pragma mark database get fuc
+(NSMutableArray*)getAllChapter
{
    NSMutableArray*pAry=[NSMutableArray array];
    if (pAry) {
        sqlite3_stmt *statement;
        NSString *getChapterInfo =[NSString stringWithFormat:
        @"select * from book%@  order by id",CurBookID];
        sqlite3_prepare_v2(db, [getChapterInfo UTF8String], -1, &statement, nil);
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary*pDic=[NSMutableDictionary dictionary];
            int nIndex = sqlite3_column_int(statement, 0);
            [pDic setObject:@(nIndex) forKey:@"index"];
            char *nameData = (char *)sqlite3_column_text(statement, 1);
            NSString *chapterName = [[NSString alloc] initWithUTF8String:nameData];
            pDic[BookColumn1]=chapterName;
            char *pathData = (char *)sqlite3_column_text(statement, 2);
            NSString *chapterPath = [[NSString alloc] initWithUTF8String:pathData];
            pDic[BookColumn2]=chapterPath;
            int pageCount = sqlite3_column_int(statement, 3);
            pDic[BookColumn3]=@(pageCount);
            int nIsMenu = sqlite3_column_int(statement, 4);
            pDic[BookColumn4]=@(nIsMenu);
            [pAry addObject:pDic];
        }
        sqlite3_finalize(statement);
    }
    return pAry;
}
+(NSMutableArray*)getAllTableName
{
    NSMutableArray*pAry=[NSMutableArray array];
    if (pAry) {
        sqlite3_stmt *statement;
        NSString *getTableInfo = @"select * from sqlite_master where type='table' order by name";
        sqlite3_prepare_v2(db, [getTableInfo UTF8String], -1, &statement, nil);
        while (sqlite3_step(statement) == SQLITE_ROW) {

            char *nameData = (char *)sqlite3_column_text(statement, 1);
            NSString *tableName = [[NSString alloc] initWithUTF8String:nameData];
            //  NSLog(@"name:%@",tableName);
            [pAry addObject:tableName];
        }
        sqlite3_finalize(statement);
    }
    return pAry;
}
+(NSRange)getRecord
{
    NSRange rangRet=NSMakeRange(0, 0);
    sqlite3_stmt *statement;
    NSString *getRecordInfo =[NSString stringWithFormat: @"select %@,%@ from note%@ where %@='record'",NoteColumn1,NoteColumn2,CurBookID,NoteColumn4];
    sqlite3_prepare_v2(db, [getRecordInfo UTF8String], -1, &statement, nil);
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
       rangRet.location= sqlite3_column_int(statement, 0);
       rangRet.length= sqlite3_column_int(statement, 1);
    }
    sqlite3_finalize(statement);
    return rangRet;
}
+(NSMutableArray*)getAllBookmarks
{
    NSMutableArray*pAry=[NSMutableArray array];
    if (pAry) {
        sqlite3_stmt *statement;
        NSString *getChapterInfo =[NSString stringWithFormat:
                                   @"select %@,%@,%@ from note%@ where %@='bookmark' order by id",
                                   NoteColumn1,NoteColumn2,NoteColumn5,CurBookID,NoteColumn4];
        sqlite3_prepare_v2(db, [getChapterInfo UTF8String], -1, &statement, nil);
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary*pDic=[NSMutableDictionary dictionary];
            int nChapter = sqlite3_column_int(statement, 0);
            pDic[NoteColumn1]=@(nChapter);
            int nPage = sqlite3_column_int(statement, 1);
            pDic[NoteColumn2]=@(nPage);
            char *pDate = (char *)sqlite3_column_text(statement, 2);
            NSString *strDate = [[NSString alloc] initWithUTF8String:pDate];
            pDic[NoteColumn5]=strDate;
            [pAry addObject:pDic];
        }
        sqlite3_finalize(statement);
    }
    return pAry;
}
+(NSMutableArray*)getAllNotes
{
    NSMutableArray*pAry=[NSMutableArray array];
    if (pAry) {
        sqlite3_stmt *statement;
        NSString *getChapterInfo =[NSString stringWithFormat:
                                   @"select * from note%@ where %@!=0 order by id",CurBookID,NoteColumn3];
        sqlite3_prepare_v2(db, [getChapterInfo UTF8String], -1, &statement, nil);
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary*pDic=[NSMutableDictionary dictionary];
            int nChapter = sqlite3_column_int(statement, 1);
            pDic[NoteColumn1]=@(nChapter);
            int nBgn = sqlite3_column_int(statement, 2);
            pDic[NoteColumn2]=@(nBgn);
            int nLength = sqlite3_column_int(statement, 3);
            pDic[NoteColumn3]=@(nLength);
            char *pNote = (char *)sqlite3_column_text(statement,4);
            NSString *strNote = [[NSString alloc] initWithUTF8String:pNote];
            pDic[NoteColumn4]=strNote;
            char *pDate = (char *)sqlite3_column_text(statement, 5);
            NSString *strDate = [[NSString alloc] initWithUTF8String:pDate];
            pDic[NoteColumn5]=strDate;
            [pAry addObject:pDic];
        }
        sqlite3_finalize(statement);
    }
    return pAry;
}
+(NSMutableArray*)getNotesRangeByChapterPath:(NSString*)pChapterPath
{
    NSMutableArray*pAry=[NSMutableArray array];
    if (pAry) {
        sqlite3_stmt *statementGetChapterIndex;
        int nChapterIndex=0;
        NSString *getChapterIndex =[NSString stringWithFormat:
                                   @"select id from book%@ where %@='%@' ",CurBookID,BookColumn2,pChapterPath];
        sqlite3_prepare_v2(db, [getChapterIndex UTF8String], -1, &statementGetChapterIndex, nil);
        while (sqlite3_step(statementGetChapterIndex) == SQLITE_ROW)
        {
            nChapterIndex=sqlite3_column_int(statementGetChapterIndex, 0);
        }
        sqlite3_finalize(statementGetChapterIndex);
        sqlite3_stmt *statement;
        NSString *getChapterNoteRanges =[NSString stringWithFormat:
                                   @"select %@,%@ from note%@ where %@=%d",NoteColumn2,NoteColumn3,CurBookID,NoteColumn1,nChapterIndex-1];
        sqlite3_prepare_v2(db, [getChapterNoteRanges UTF8String], -1, &statement, nil);
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary*pDic=[NSMutableDictionary dictionary];
            int nBgn = sqlite3_column_int(statement, 0);
            pDic[NoteColumn2]=@(nBgn);
            int nLength = sqlite3_column_int(statement, 1);
            pDic[NoteColumn3]=@(nLength);
            [pAry addObject:pDic];
        }
        sqlite3_finalize(statement);
    }
    return pAry;
}
+(void)UpdateChapterPage:(NSUInteger)nPage byPath:(NSString*)pChapterPath
{
    NSString*sqlUpdate=[NSString stringWithFormat:@"UPDATE book%@ SET %@ = %zi WHERE %@ = '%@'",CurBookID,BookColumn3,nPage,BookColumn2,pChapterPath];
    [self execSql:sqlUpdate];
}
@end
