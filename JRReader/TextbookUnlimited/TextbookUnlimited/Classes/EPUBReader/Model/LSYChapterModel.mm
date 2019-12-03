//
//  LSYChapterModel.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYChapterModel.h"
#import "LSYReadConfig.h"
#import "LSYReadParser.h"
//#import "NSString+HTML.h"
#include <vector>

#import "LSYReadPageViewController.h"
@implementation LSYImageData
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeInteger:self.position forKey:@"position"];
    [aCoder encodeObject:[NSValue valueWithCGRect:self.imageRect] forKey:@"imageRect"];

}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.url        =[aDecoder decodeObjectForKey:@"url"];
        self.position   =[aDecoder decodeIntegerForKey:@"position"];
        NSValue *pRect  =[aDecoder decodeObjectForKey:@"imageRect"];
        self.imageRect  =[pRect CGRectValue];
    }
    return self;
}
@end
@interface LSYChapterModel ()
@property (nonatomic,strong) NSMutableArray *pageArray;
@property (nonatomic,strong) NSString* absFilePath;//绝对路径

@end

@implementation LSYChapterModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageArray = [NSMutableArray array];
    }
    return self;
}
+(id)chapterWithEpub:(NSString *)chapterpath title:(NSString *)title isMenu:(BOOL)bMenu
{
    LSYChapterModel *model = [[LSYChapterModel alloc] init];
    model.title = title;
    //测试用
    if ([chapterpath hasSuffix:@"chapter2.html"]) {
        NSLog(@"调试用");
    }
    //zwqbgn20161216 zwqattributedstring
    
    model.filePath=[Tools getPath:chapterpath forAbsolute:false];
    
    
    model.AttributedTxt = [LSYChapterModel getAttrStrFromFileUrl:chapterpath];
    
    [model handleImage];
    model.contentFontSize=12.0;
    [model paginate];
    [bookdatabase insertChapter:title Path:model.filePath PageCount:model.pageCount isMenu:bMenu];
    //zwqend
    //model.content =model.AttributedTxt.string;// [html stringByConvertingHTMLToPlainText];
    return model;
}

-(id)copyWithZone:(NSZone *)zone
{
    LSYChapterModel *model = [[LSYChapterModel allocWithZone:zone] init];
    model.title = self.title;
    model.pageCount = self.pageCount;
    
    model.AttributedTxt=self.AttributedTxt;

    
    model.imageArray=self.imageArray;
    model.filePath=self.filePath;
    model.epubContent=self.epubContent;
    return model;
    
}
-(void)paginate
{
    [self paginateWithBounds:[LSYReadParser getContentRect]];
}
-(void)updateFont
{
    if (!_AttributedTxt)
    {
        [self initChapterContent];
    }
    NSUInteger nPage=_pageCount;
    [self paginateWithBounds:[LSYReadParser getContentRect]];
    if (nPage!=_pageCount) {
        [bookdatabase UpdateChapterPage:_pageCount byPath:_filePath];
    }
    
}
-(void)paginateWithBounds:(CGRect)bounds
{

    [_pageArray removeAllObjects];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithAttributedString:_AttributedTxt];
    //处理字体bgn
    CGFloat fTargetFontSize=[LSYReadConfig shareInstance].fontSize;
    [LSYReadConfig shareInstance].fontOffset=fTargetFontSize-_contentFontSize;
    [[LSYReadConfig shareInstance]formatString:&attrString by:_contentFontSize];
    _contentFontSize=[LSYReadConfig shareInstance].fontSize;
    //处理字体end
    self.AttributedTxt= attrString;
   
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGPathRef path = CGPathCreateWithRect(bounds, NULL);
    int currentOffset = 0;
    int currentInnerOffset = 0;
    BOOL hasMorePages = YES;
    // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
    int preventDeadLoopSign = currentOffset;
    int samePlaceRepeatCount = 0;
    
    while (hasMorePages) {
        if (preventDeadLoopSign == currentOffset) {
            ++samePlaceRepeatCount;
        } else {
            samePlaceRepeatCount = 0;
        }
        
        if (samePlaceRepeatCount > 1) {
            // 退出循环前检查一下最后一页是否已经加上
            if (_pageArray.count == 0) {
                [_pageArray addObject:@(currentOffset)];
            }
            else {
                NSUInteger lastOffset = [[_pageArray lastObject] integerValue];
                if (lastOffset != currentOffset) {

                    [_pageArray addObject:@(currentOffset)];
                }
            }
            break;
        }
        [_pageArray addObject:@(currentOffset)];
        
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
        
        if ((range.location + range.length) != attrString.length) {
            //zwqbgn
            if (range.length == 0){
                //可能是遇到了图片
                range.length = 1;
            }
            //zwqend
            currentOffset += range.length;
            currentInnerOffset += range.length;
            
        } else {
            // 已经分完，提示跳出循环
            hasMorePages = NO;
        }
        if (frame) CFRelease(frame);
    }
    
    CGPathRelease(path);
    CFRelease(frameSetter);
//    _pageCount = _pages.size();
    _pageCount = _pageArray.count;
}
-(NSString *)stringOfPage:(NSUInteger)index
{
    [self initChapterContentAndPagenate];
    if (index>=_pageArray.count) {
        index=_pageArray.count-1;
    }
//    NSUInteger local = _pages[index];
    NSUInteger local = [_pageArray[index] integerValue];
    NSUInteger length;
    if (index<_pageArray.count-1) {
//        length = _pages[index+1] -_pages[index];
        length=  [_pageArray[index+1] integerValue] - [_pageArray[index] integerValue];
    }
    else{
//        length = _content.length-_pages[index];
        length = _AttributedTxt.length - [_pageArray[index] integerValue];
    }
    return [_AttributedTxt.string substringWithRange:NSMakeRange(local, length)];
}
-(NSString *)stringOfRange:(NSRange)rangeNoteContent
{
    [self initChapterContentAndPagenate];
    if (NSMaxRange(rangeNoteContent)>self.AttributedTxt.length) {
        NSLog(@"范围超出区域内容");
    }
    return [self.AttributedTxt.string substringWithRange:rangeNoteContent];
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInteger:self.pageCount forKey:@"pageCount"];
//    for(int i = 0; i < _pages.size(); i++){
//       [array addObject:[NSValue value:&_pages[i] withObjCType:@encode(int)]];
//    }
    [aCoder encodeObject:self.pageArray forKey:@"pageArray"];
    

    [aCoder encodeObject:self.filePath forKey:@"filePath"];
    [aCoder encodeObject:self.epubContent forKey:@"epubContent"];
    [aCoder encodeObject:self.imageArray   forKey:@"imageArray"];
   // NSData* data = [_AttributedTxt dataFromRange:NSMakeRange(0, _AttributedTxt.length)
//                      documentAttributes:@{NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType}
//                                   error:nil];
    //NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[_AttributedTxt copy]];
//    [aCoder encodeObject:data forKey:@"AttributedTxtData"];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.pageCount = [aDecoder decodeIntegerForKey:@"pageCount"];
        self.pageArray = [aDecoder decodeObjectForKey:@"pageArray"];

        self.filePath=[aDecoder decodeObjectForKey:@"filePath"];
        self.epubContent=[aDecoder decodeObjectForKey:@"epubContent"];
        self.imageArray=[aDecoder decodeObjectForKey:@"imageArray"];
        [self initChapterContentAndPagenate];
    }
    return self;
}
#pragma mark zwq for diy
-(void)initChapterContentAndPagenate
{
    if(!self.AttributedTxt)
    {
        [self initChapterContent];
        [self paginate];
    }
}
-(void)initChapterContent
{
    if(!self.AttributedTxt)
    {
        self.contentFontSize=12;
//        NSDictionary*pDicOption=@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
        //   dispatch_async(dispatch_get_main_queue(),^{
       /*self.AttributedTxt=[[NSMutableAttributedString alloc]
                            initWithURL:[NSURL fileURLWithPath:self.absFilePath]
                            options:pDicOption
                            documentAttributes:nil
                            error:nil];*/
        self.AttributedTxt=[LSYChapterModel  getAttrStrFromFileUrl:self.absFilePath];
        // });
        [self handleImage];
        NSArray*aryNoteRanges=[bookdatabase getNotesRangeByChapterPath:self.filePath];
        if (aryNoteRanges)
        {
            for (NSDictionary*pDic in aryNoteRanges)
            {
                int nBgn=((NSNumber* )pDic[NoteColumn2]).intValue;
                int nLen=((NSNumber* )pDic[NoteColumn3]).intValue;
                NSRange rangeNote=NSMakeRange(nBgn,nLen);
                [self addNoteAttribute:rangeNote];
            }
        }
        
    }
}
+(NSMutableAttributedString*)getAttrStrFromFileUrl:(NSString*)chapterpath{
NSDictionary*pDicOption=@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSURL* pUrl = [NSURL fileURLWithPath:chapterpath];
    NSMutableAttributedString* pAttrM = nil;
    if (pUrl) {
        if (@available(iOS 9.0, *)) {
            pAttrM = [[NSMutableAttributedString alloc]initWithURL:pUrl options:pDicOption documentAttributes:nil error:nil];
        }else{
            pAttrM = [[NSMutableAttributedString alloc]initWithFileURL:pUrl options:pDicOption documentAttributes:nil error:nil];
        }
    }
    return pAttrM;
}
-(NSString*)absFilePath
{
    if (!_absFilePath) {
        _absFilePath=[Tools getPath:_filePath forAbsolute:YES];
    }
    return _absFilePath;
}
// search page href 从0页开始,实际页数应该从1开始
-(NSUInteger)getPageByLocation:(NSUInteger)nLocation
{
    NSUInteger nRet=0;
    for (int i=0; i<_pageCount; i++)
    {
        NSNumber*pNumber=_pageArray[i];
        if (pNumber.integerValue>nLocation)
        {
            break;
        }
        nRet=i;
    }
    return nRet;
}
//搜到的字符串在章节中的位置转换为在页码中的位置
-(NSRange)getPageRangeBy:(NSRange)ChapterRange withPage:(NSUInteger)nPage
{
    NSNumber*pNumber=_pageArray[nPage];
    NSUInteger nPageLoctaionBgn=pNumber.integerValue;
    NSRange rangeRet=NSMakeRange(ChapterRange.location-nPageLoctaionBgn, ChapterRange.length);
    return rangeRet;
}
-(NSRange)getChapterRangeBy:(NSRange)PageRange withPage:(NSUInteger)nPage
{
    NSNumber*pNumber=_pageArray[nPage];
    NSUInteger nPageLoctaionBgn=pNumber.integerValue;
    NSRange rangeRet=NSMakeRange(PageRange.location+nPageLoctaionBgn, PageRange.length);
    return rangeRet;
}
-(NSRange)getPageRange:(NSUInteger)nPage
{
    if(_pageArray.count==0)
    {
        [self initChapterContentAndPagenate];
    }
    if (nPage>=_pageArray.count)
    {
        NSLog(@"章节页数%zi大于了页数数组总数%zi",nPage,_pageArray.count);
        nPage=_pageArray.count-1;//字体缩小后再向后翻页,可能会越界
    }
    NSNumber* pNumberCur=_pageArray[nPage];
    NSUInteger Location=pNumberCur.integerValue;
    NSUInteger Length=_AttributedTxt.length-Location;
    if (nPage<_pageArray.count-1)
    {
        NSNumber* pNumberNext=_pageArray[nPage+1];
        Length=pNumberNext.integerValue-pNumberCur.integerValue;
    }
    NSRange range=NSMakeRange(Location, Length);
    return range;
}
//把笔记显示在正文中
-(void)addNoteAttributesBy:(NSArray*)pAryNotes CurChapterIndex:(NSUInteger)nIndex
{
    for (LSYNoteModel*pNoteModel in pAryNotes)
    {
        if (pNoteModel.recordModel.chapter== nIndex)
        {
            NSRange rangeNote=pNoteModel.ChapterRange;
            [self addNoteAttribute:rangeNote];
        }
    }
}
-(void)addNoteAttribute:(NSRange)rangeNote
{
    [self.AttributedTxt addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:rangeNote];
    // crj修改 做笔记之后的选中颜色 20181207
    [self.AttributedTxt addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithHexString:@"#ebbac6"] range:rangeNote];
}
-(void)removeNoteAttribute:(NSRange)rangeNote
{
    [self.AttributedTxt removeAttribute:NSUnderlineStyleAttributeName  range:rangeNote];
    [self.AttributedTxt removeAttribute:NSBackgroundColorAttributeName range:rangeNote];
}
//解析图片转化为占位字符串,加入原字符串

-(void)handleImage
{
    NSMutableArray*aryImagePath=[self getAllImagePath];
    if (aryImagePath.count==0) {
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *imageArray = [NSMutableArray array];
    [self.AttributedTxt enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.AttributedTxt.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop)
    {
        if (value&&[value isKindOfClass:[NSTextAttachment class]])
        {
            NSTextAttachment*attachment=(NSTextAttachment*)value;
            NSString*fileType=attachment.fileType;
            if ([fileType isEqualToString:@"public.jpeg"]||[fileType isEqualToString:@"public.png"])
            {
                NSString *imageString=@"";
                if (attachment&&attachment.fileWrapper)
                {
                    NSString*pImgName=attachment.fileWrapper.filename;
                    NSString*pImgRelPath=aryImagePath.lastObject;
                    if(![pImgRelPath hasSuffix:pImgName])
                    {
                        NSLog(@"图片名字不正确");
                    }
                    [aryImagePath removeLastObject];
                    NSString*folderPath=[self.absFilePath stringByDeletingLastPathComponent];
                    imageString= [folderPath stringByAppendingPathComponent:pImgRelPath];
                }
                UIImage *image = [UIImage imageWithContentsOfFile:imageString];
       //         attachment.image=image;
                CGSize size = [Tools getImgSize:image inSize:[LSYReadParser getContentRect].size];
                NSDictionary*pDic=@{@"type":@"img",@"content":imageString,@"width":@(size.width),@"height":@(size.height)};
                [array insertObject:pDic atIndex:0];
                
                //zwqbgn 把图片作为附件加入富文本中
                NSAttributedString*pPlace=[LSYReadParser parserEpubImageWithSize:pDic config:[LSYReadConfig shareInstance]];
                LSYImageData *imageData = [[LSYImageData alloc] init];
                imageData.url =[Tools getPath:imageString forAbsolute:NO] ;
                imageData.position = range.location;
                imageData.imageRect = CGRectMake(0, 0, size.width, size.height);
                [imageArray insertObject:imageData atIndex:0];
                [self.AttributedTxt replaceCharactersInRange:range withAttributedString:pPlace];
            }

        }
    }];
    //剔除末尾的空格
    if (self.AttributedTxt.length>0)
    {
        while ([self.AttributedTxt.string hasSuffix:@" "]||[self.AttributedTxt.string hasSuffix:@"\n"])
        {
            [self.AttributedTxt deleteCharactersInRange:NSMakeRange(self.AttributedTxt.length-1, 1)];
        }
    }
    self.epubContent = [array copy];
    self.imageArray = [imageArray copy];

//    NSString* html = [[NSString alloc] initWithData:self.chapterData encoding:NSUTF8StringEncoding];
//    //先把<p> </p>转化为<p></p>
//    NSMutableString*pMutHtml=[html mutableCopy];
//    NSString *parten = @"<p> +</p>";
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:parten  options:NSRegularExpressionCaseInsensitive error:nil];
//    NSArray *array = [regex matchesInString:pMutHtml options:0 range:NSMakeRange(0, [pMutHtml length])];
//    for (NSTextCheckingResult* b in [array reverseObjectEnumerator])
//    {
//        [pMutHtml replaceCharactersInRange:b.range withString:@"<p></p>"];
//    }
//    NSString* pTxt=[pMutHtml stringByConvertingHTMLToPlainText];
//    [self parserEpubToDictionary:pTxt];
}
-(NSMutableArray*)getAllImagePath
{
    NSMutableArray*aryRet=[NSMutableArray array];
    NSString* html=[NSString stringWithContentsOfURL:[NSURL fileURLWithPath:self.absFilePath] encoding:NSUTF8StringEncoding error:nil];
    if (html)
    {
        NSScanner *scanner = [NSScanner scannerWithString:html];
        //scanner.charactersToBeSkipped=nil;
        while (![scanner isAtEnd])

        {
            [scanner scanUpToString:@"<img" intoString:nil];
             [scanner scanUpToString:@"src=" intoString:nil];
            NSCharacterSet*pSet=[NSCharacterSet characterSetWithCharactersInString:@"\'\""];
            [scanner scanUpToCharactersFromSet:pSet intoString:NULL];//搜索词在首行时,会直接返回false.
            [scanner scanCharactersFromSet:pSet intoString:NULL];
            NSString *img;
            [scanner scanUpToCharactersFromSet:pSet intoString:&img];
            if (img)
            {
                [aryRet addObject:img];
            }
        }
        
    }
    return aryRet;
}
@end
