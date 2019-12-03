//
//  LSYReadParser.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadParser.h"
#import "LSYReadConfig.h"
@implementation LSYReadParser
#pragma CTRunCallBack

static NSDictionary *CFRunInfo;

static CGFloat ascentCallback(void *ref){
    
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
    
}

static CGFloat descentCallback(void *ref){
    return 0;
}

static CGFloat widthCallback(void* ref){
    return  [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

+(CTFrameRef)parserContent:(NSString *)content config:(LSYReadConfig *)parser bouds:(CGRect)bounds
{
    if(!content)
    {
        return nil;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    //zwqbgn 添加高亮区域的属性设置
    [self setHightLight:&attributedString withRange:parser withContent:content];
    //zwqend
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    CGPathRef pathRef = CGPathCreateWithRect(bounds, NULL);
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, NULL);
    CFRelease(setterRef);
    CFRelease(pathRef);
    return frameRef;
}
//把图片转化成占位的富文本
+(NSAttributedString *)parserEpubImageWithSize:(NSDictionary *)dic config:(LSYReadConfig *)config
{
    CTRunDelegateCallbacks callbacks;
    
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(dic));
    unichar objectReplacementChar = 0xFFFC;
    NSDictionary *attr = [self parserAttribute:config];
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:content attributes:attr];
    
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attrString, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return [attrString copy];
    
    
}
+(NSDictionary *)parserAttribute:(LSYReadConfig *)config
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = config.fontColor;
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:config.fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = config.lineSpace;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    dict[NSParagraphStyleAttributeName] = paragraphStyle;
    return [dict copy];
}
+(CFIndex)parserIndexWithPoint:(CGPoint)point frameRef:(CTFrameRef)frameRef
{
    CFIndex index = -1;
    CGPathRef pathRef = CTFrameGetPath(frameRef);
    CGRect bounds = CGPathGetBoundingBox(pathRef);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);
    if (!lines) {
        return index;
    }
    NSInteger lineCount = [lines count];
    CGPoint *origins = malloc(lineCount * sizeof(CGPoint)); //给每行的起始点开辟内存
    if (lineCount) {
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
        for (int i = 0; i<lineCount; i++) {
            CGPoint baselineOrigin = origins[i];
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
            CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CGRect lineFrame = CGRectMake(baselineOrigin.x, CGRectGetHeight(bounds)-baselineOrigin.y-ascent, lineWidth, ascent+descent+linegap+[LSYReadConfig shareInstance].lineSpace);    //没有转换坐标系左下角为坐标原点 字体高度为上行高度加下行高度
            if (CGRectContainsPoint(lineFrame,point)){
                //zwqbgn 点应该转换成相对于该行原点的点
                point=[self getPoint:point relativeTo:baselineOrigin];
                //zwqend
                index = CTLineGetStringIndexForPosition(line, point);
                break;
            }
        }
    }
    free(origins);
    return index;
    
}
+(CGRect)parserRectWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef
{
    CFIndex index = -1;
    CGPathRef pathRef = CTFrameGetPath(frameRef);
    CGRect bounds = CGPathGetBoundingBox(pathRef);
    CGRect rect = CGRectZero;
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);
    if (!lines) {
        return rect;
    }
    NSInteger lineCount = [lines count];
    CGPoint *origins = malloc(lineCount * sizeof(CGPoint)); //给每行的起始点开辟内存
    if (lineCount) {
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
        for (int i = 0; i<lineCount; i++) {
            CGPoint baselineOrigin = origins[i];
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
            CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CGRect lineFrame = CGRectMake(baselineOrigin.x, CGRectGetHeight(bounds)-baselineOrigin.y-ascent, lineWidth, ascent+descent+linegap+[LSYReadConfig shareInstance].lineSpace);    //没有转换坐标系左下角为坐标原点 字体高度为上行高度加下行高度
            if (CGRectContainsPoint(lineFrame,point)){
                CFRange stringRange = CTLineGetStringRange(line);
                //zwqbgn 点应该转换成相对于该行原点的点
                point=[self getPoint:point relativeTo:baselineOrigin];
                //zwqend
                index = CTLineGetStringIndexForPosition(line, point);
                CGFloat xStart = CTLineGetOffsetForStringIndex(line, index, NULL);
                CGFloat xEnd;
                //默认选中两个单位
                if (index > stringRange.location+stringRange.length-2) {
                    xEnd = xStart;
                    xStart = CTLineGetOffsetForStringIndex(line,index-2,NULL);
                    (*selectRange).location = index-2;
                }
                else{
                    xEnd = CTLineGetOffsetForStringIndex(line,index+2,NULL);
                    (*selectRange).location = index;
                }
                
                (*selectRange).length = 2;
                rect = CGRectMake(origins[i].x+xStart,baselineOrigin.y-descent,fabs(xStart-xEnd), ascent+descent);
                
                break;
            }
        }
    }
    free(origins);
    return rect;
}

+(NSArray *)parserRectsWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef paths:(NSArray *)paths
{
    CFIndex index = -1;
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);
    NSMutableArray *muArr = [NSMutableArray array];
    NSInteger lineCount = [lines count];
    CGPoint *origins = malloc(lineCount * sizeof(CGPoint)); //给每行的起始点开辟内存
    index = [self parserIndexWithPoint:point frameRef:frameRef];
    if (index == -1) {
        return paths;
    }
    if (!(index>(*selectRange).location)) {
        (*selectRange).length = (*selectRange).location-index+(*selectRange).length;
        (*selectRange).location = index;
    }
    else{
        (*selectRange).length = index-(*selectRange).location;
    }
//    NSLog(@"selectRange - %@",NSStringFromRange((*selectRange)));
    if (lineCount) {
        
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
        for (int i = 0; i<lineCount; i++){
            CGPoint baselineOrigin = origins[i];
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
            CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CFRange stringRange = CTLineGetStringRange(line);
            CGFloat xStart;
            CGFloat xEnd;
            NSRange drawRange = [self selectRange:NSMakeRange((*selectRange).location, (*selectRange).length) lineRange:NSMakeRange(stringRange.location, stringRange.length)];
            
            if (drawRange.length) {        
                xStart = CTLineGetOffsetForStringIndex(line, drawRange.location, NULL);
                xEnd = CTLineGetOffsetForStringIndex(line, drawRange.location+drawRange.length, NULL);
                CGRect rect = CGRectMake(xStart, baselineOrigin.y-descent, fabs(xStart-xEnd), ascent+descent);
                if (rect.size.width ==0 || rect.size.height == 0) {
                    continue;
                }
                [muArr addObject:NSStringFromCGRect(rect)];
            }
            
    }
        
}
    free(origins);
    return muArr;
}
+(NSArray *)parserRectsWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef paths:(NSArray *)paths direction:(BOOL) direction
{
    //zwqbgn测试
   // NSLog(@"选择区域长度为%zi",(*selectRange).length);
    if((*selectRange).length==0)
    {
        NSLog(@"选择区域长度为0了");
    }
    CFIndex index = -1;
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);
    NSMutableArray *muArr = [NSMutableArray array];
    NSInteger lineCount = [lines count];
    CGPoint *origins = malloc(lineCount * sizeof(CGPoint)); //给每行的起始点开辟内存
    index = [self parserIndexWithPoint:point frameRef:frameRef];
    if (index == -1) {
        return paths;
    }
    if (direction) //从右侧滑动
    {
        if (!(index>(*selectRange).location)) {
            (*selectRange).length = (*selectRange).location-index+(*selectRange).length;
            (*selectRange).location = index;
        }
        else{
            (*selectRange).length = index-(*selectRange).location;
        }
    }
    else    //从左侧滑动
    {
        if (!(index>(*selectRange).location+(*selectRange).length)) {
            (*selectRange).length = (*selectRange).location-index+(*selectRange).length;
            (*selectRange).location = index;
        }
    }
    //    NSLog(@"selectRange - %@",NSStringFromRange((*selectRange)));
    if (lineCount) {
        
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
        for (int i = 0; i<lineCount; i++){
            CGPoint baselineOrigin = origins[i];
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
            CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CFRange stringRange = CTLineGetStringRange(line);
            CGFloat xStart;
            CGFloat xEnd;
            NSRange drawRange = [self selectRange:NSMakeRange((*selectRange).location, (*selectRange).length) lineRange:NSMakeRange(stringRange.location, stringRange.length)];
            //
            if (drawRange.length)
            {
                xStart = CTLineGetOffsetForStringIndex(line, drawRange.location, NULL);
                xEnd = CTLineGetOffsetForStringIndex(line, drawRange.location+drawRange.length, NULL);
                CGRect rect = CGRectMake(xStart+baselineOrigin.x, baselineOrigin.y-descent, fabs(xStart-xEnd), ascent+descent);
                if (rect.size.width ==0 || rect.size.height == 0) {
                    continue;
                }
                [muArr addObject:NSStringFromCGRect(rect)];
            }
            
        }
        
    }
    free(origins);
    return muArr;
}
+(NSRange)selectRange:(NSRange)selectRange lineRange:(NSRange)lineRange
{
    NSRange range = NSMakeRange(NSNotFound, 0);
    if (lineRange.location>selectRange.location) {
        NSRange tmp = lineRange;
        lineRange = selectRange;
        selectRange = tmp;
    }
    if (selectRange.location<lineRange.location+lineRange.length) {
        range.location = selectRange.location;
        NSUInteger end = MIN(selectRange.location+selectRange.length, lineRange.location+lineRange.length);
        range.length = end-range.location;
    }
    return range;
}
#pragma mark zwq
//设置高亮的代码
+(void)setHightLight:(NSMutableAttributedString**)attributedString withRange:(LSYReadConfig *)parser withContent:(NSString*)content
{
    if(parser.HeightLightString)
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:parser.HeightLightString options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
        NSArray *array = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];
        for (NSTextCheckingResult* b in array)
        {
            [*attributedString addAttribute:(NSString *)kCTBackgroundColorAttributeName
                                     value:(id)[UIColor yellowColor].CGColor
                                     range:b.range];
        }
    }
    if(parser.HeightLightRange.length>0)
    {
        if (parser.HeightLightRange.location<content.length) {
            if(NSMaxRange(parser.HeightLightRange)>content.length)
            {
                parser.HeightLightRange=NSMakeRange(parser.HeightLightRange.location,content.length-parser.HeightLightRange.location);
            }
            [*attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                     value:(id)[UIColor redColor].CGColor
                                     range:parser.HeightLightRange];
        }
        else
        {
            NSLog(@"超出边界了");
        }
    }
    if(parser.readRange.length>0)
    {
        if (parser.readRange.location<content.length) {
            if(NSMaxRange(parser.readRange)>content.length)
            {
                parser.readRange=NSMakeRange(parser.readRange.location,content.length-parser.readRange.location);
            }
            [*attributedString addAttribute:NSBackgroundColorAttributeName
                                      value:[UIColor colorWithRed:0.6 green:0 blue:0 alpha:0.5]
                                      range:parser.readRange];
        }
        else
        {
            NSLog(@"阅读区域超出边界了");
        }
    }
}
+(CTFrameRef)parserAttributedTxt:(NSMutableAttributedString *)attributedString config:(NSRange)range bouds:(CGRect)bounds
{
    LSYReadConfig*parser=[LSYReadConfig shareInstance];
    //zwqbgn 添加高亮区域的属性设置
    NSMutableAttributedString*pAttrTemp=[[NSMutableAttributedString alloc]initWithAttributedString:attributedString];
    [self setHightLight:&pAttrTemp withRange:parser withContent:attributedString.string];
    //zwqend
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)pAttrTemp);
    CGPathRef pathRef = CGPathCreateWithRect(bounds, NULL);
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(range.location, range.length), pathRef, NULL);
    CFRelease(setterRef);
    CFRelease(pathRef);
    return frameRef;
}

+(CGRect)getContentRect
{
    CGRect rtContent=CGRectMake(LeftSpacing, TopSpacing, ScreenSize.width-LeftSpacing-RightSpacing, ScreenSize.height-TopSpacing-BottomSpacing);
    return rtContent;
}
+(CGPoint)getPoint:(CGPoint)ptTouch relativeTo:(CGPoint)ptLineOrigin
{
    ptTouch.x-=ptLineOrigin.x;
    ptTouch.y-=ptLineOrigin.y;
    return CGPointMake(ptTouch.x, ptTouch.y);
}
@end
