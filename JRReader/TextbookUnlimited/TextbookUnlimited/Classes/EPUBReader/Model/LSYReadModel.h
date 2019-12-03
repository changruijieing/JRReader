//
//  LSYReadModel.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSYMarkModel.h"
#import "LSYNoteModel.h"
#import "LSYChapterModel.h"
#import "LSYRecordModel.h"
#import "bookdatabase.h"
#define kNoteEditHeight 45//笔记\书签底部编辑区域高度
@interface LSYReadModel : NSObject<NSCoding>
@property (nonatomic,strong) NSURL *resource;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSMutableArray <LSYMarkModel *>*marks;
@property (nonatomic,strong) NSMutableArray <LSYNoteModel *>*notes;
//以opf文件中的idhref为准
@property (nonatomic,strong) NSMutableArray <LSYChapterModel *>*chapters;
//zwq章节中只有一部分是目录,以ncx文件中的navMap为准
@property (nonatomic,strong) NSMutableArray <LSYChapterModel *>*menuChapters;
@property (nonatomic,strong) NSMutableDictionary *marksRecord;
@property (nonatomic,strong) LSYRecordModel *record;
-(instancetype)initWithContent:(NSString *)content;
-(instancetype)initWithePub:(NSString *)ePubPath;
+(void)updateLocalModel:(LSYReadModel *)readModel url:(NSURL *)url;
+(id)getLocalModelWithURL:(NSURL *)url;
//zwq 获取图书总页数
-(NSUInteger)getBookPageCount;
//zwq 根据章节数和章节页数，计算出在整个书中的第几页
-(NSUInteger)getBookPageByChapter:(NSUInteger)nChapter PageInChapter:(NSUInteger)nChapterPage;
//根据书中页数,得到在当前书中的页数和章节数 loc表示章节数 len表示页数
-(NSRange)getChapterPage:(NSUInteger)nBookPage;
@end
