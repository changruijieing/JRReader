//
//  LSYChapterModel.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
@interface LSYImageData : NSObject<NSCoding>
@property (nonatomic,strong) NSString *url; //图片链接
@property (nonatomic,assign) CGRect imageRect;  //图片位置
@property (nonatomic,assign) NSInteger position;
@end

@interface LSYChapterModel : NSObject<NSCopying,NSCoding>
//@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *title;
@property (nonatomic) NSUInteger pageCount;
@property BOOL m_bInMenu;//zwq


-(NSString *)stringOfPage:(NSUInteger)index;
-(NSString*)stringOfRange:(NSRange)rangeNoteContent;
-(void)updateFont;
+(id)chapterWithEpub:(NSString *)chapterpath title:(NSString *)title isMenu:(BOOL)bMenu;
//zwqbgn
//用于转化成富文本
@property (nonatomic,strong) NSMutableAttributedString*AttributedTxt;
//文件路径,用于找到图片
@property (nonatomic,strong) NSString*filePath;//相对路径
@property (nonatomic,strong) NSString*fileName;
@property (nonatomic,copy) NSArray <LSYImageData *> *imageArray;
@property (nonatomic,copy) NSArray *epubContent;
////用于记录笔记
//@property (nonatomic,strong) NSMutableArray<NSString*>*aryNotes;//笔记内容
//@property (nonatomic,strong) NSMutableArray*aryNotesRange;//笔记区域
//记录当前章节的标准字体
@property (nonatomic) CGFloat contentFontSize;//记录富文本初始化时的字体大小
-(NSUInteger)getPageByLocation:(NSUInteger)nLocation;
//搜到的字符串在章节中的位置转换为在页码中的位置
-(NSRange)getPageRangeBy:(NSRange)ChapterRange withPage:(NSUInteger)nPage;
-(NSRange)getChapterRangeBy:(NSRange)PageRange withPage:(NSUInteger)nPage;
//获得某页在章节中的范围
-(NSRange)getPageRange:(NSUInteger)nPage;
//增删笔记效果
-(void)addNoteAttributesBy:(NSArray*)pAryNotes CurChapterIndex:(NSUInteger)nIndex;//添加所有的笔记效果
-(void)addNoteAttribute:(NSRange)rangeNote;
-(void)removeNoteAttribute:(NSRange)rangeNote;
//初始化章节内容
-(void)initChapterContentAndPagenate;
//zwqend
@end
