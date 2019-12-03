//
//  LSYReadUtilites.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadUtilites.h"
#import "LSYChapterModel.h"
#import "ZipArchive.h"
#import "TouchXML.h"
@implementation LSYReadUtilites
static UIViewController*pReadPageVC=nil;
+(void)separateChapter:(NSMutableArray **)chapters content:(NSString *)content
{
//    [*chapters removeAllObjects];
//    NSString *parten = @"第[0-9一二三四五六七八九十百千]*[章回].*";
//    NSError* error = NULL;
//    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error];
//    
//    NSArray* match = [reg matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, [content length])];
//    
//    if (match.count != 0)
//    {
//        __block NSRange lastRange = NSMakeRange(0, 0);
//        [match enumerateObjectsUsingBlock:^(NSTextCheckingResult *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSRange range = [obj range];
//            NSInteger local = range.location;
//            if (idx == 0) {
//                LSYChapterModel *model = [[LSYChapterModel alloc] init];
//                model.title = @"开始";
//                NSUInteger len = local;
//                model.content = [content substringWithRange:NSMakeRange(0, len)];
//                [*chapters addObject:model];
//                
//            }
//            if (idx > 0 ) {
//                LSYChapterModel *model = [[LSYChapterModel alloc] init];
//                model.title = [content substringWithRange:lastRange];
//                NSUInteger len = local-lastRange.location;
//                model.content = [content substringWithRange:NSMakeRange(lastRange.location, len)];
//                [*chapters addObject:model];
//                
//            }
//            if (idx == match.count-1) {
//                LSYChapterModel *model = [[LSYChapterModel alloc] init];
//                model.title = [content substringWithRange:range];
//                model.content = [content substringWithRange:NSMakeRange(local, content.length-local)];
//                [*chapters addObject:model];
//            }
//            lastRange = range;
//        }];
//    }
//    else{
//        LSYChapterModel *model = [[LSYChapterModel alloc] init];
//        model.content = content;
//        [*chapters addObject:model];
//    }
}
+(NSString *)encodeWithURL:(NSURL *)url
{
    if (!url) {
        return @"";
    }
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (!content) {
        content = [NSString stringWithContentsOfURL:url encoding:0x80000632 error:nil];
    }
    if (!content) {
        content = [NSString stringWithContentsOfURL:url encoding:0x80000631 error:nil];
    }
    if (!content) {
        return @"";
    }
    return content;
    
}
+(UIButton *)commonButtonSEL:(SEL)sel target:(id)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    UIColor *fontRed = [UIColor colorWithHexString:@"#C6244C"];
    [button setTintColor: fontRed];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+(UIViewController*)getReadPageVC
{
    return pReadPageVC;
}
+(void)setReadPageVC:(UIViewController*)pVC
{
    pReadPageVC=pVC;
}
+(void)showAlertTitle:(NSString *)title content:(NSString *)string
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:string  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    [[self getReadPageVC] presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark - ePub处理
+(NSMutableArray *)ePubFileHandle:(NSString *)path;
{
    NSString *ePubPath = [self unZip:path];
    if (!ePubPath) {
        return nil;
    }
    NSString *OPFPath = [self OPFPath:ePubPath];
    return [self parseOPF:OPFPath];
    
}
#pragma mark - 解压文件路径
+(NSString *)unZip:(NSString *)path
{
    ZipArchive *zip = [[ZipArchive alloc] init];
    NSString *zipFile = [[path stringByDeletingPathExtension] lastPathComponent];
    if ([zip UnzipOpenFile:path]) {
        NSString *zipPath = [NSString stringWithFormat:@"%@/%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject,zipFile];
        NSFileManager *filemanager=[[NSFileManager alloc] init];
        if ([filemanager fileExistsAtPath:zipPath]) {
            NSError *error;
            [filemanager removeItemAtPath:zipPath error:&error];
        }
        if ([zip UnzipFileTo:[NSString stringWithFormat:@"%@/",zipPath] overWrite:YES]) {
            return zipPath;
        }
    }
    return nil;
}
#pragma mark - OPF文件路径
+(NSString *)OPFPath:(NSString *)epubPath
{
    NSString *containerPath = [NSString stringWithFormat:@"%@/META-INF/container.xml",epubPath];
    //container.xml文件路径 通过container.xml获取到opf文件的路径
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:containerPath]) {
        CXMLDocument* document = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:containerPath] options:0 error:nil];
        CXMLNode* opfPath = [document nodeForXPath:@"//@full-path" error:nil];
        // xml文件中获取full-path属性的节点  full-path的属性值就是opf文件的绝对路径
        return [NSString stringWithFormat:@"%@/%@",epubPath,[opfPath stringValue]];
    } else {
        NSLog(@"ERROR: ePub not Valid");
        return nil;
    }

}
#pragma mark - 解析OPF文件
+(NSMutableArray *)parseOPF:(NSString *)opfPath
{
    CXMLDocument* document = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath] options:0 error:nil];
    NSArray* itemsArray = [document nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    //opf文件的命名空间 xmlns="http://www.idpf.org/2007/opf" 需要取到某个节点设置命名空间的键为opf 用opf:节点来获取节点
    NSString *ncxFile;
    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
   // [MBProgressHUD setWaitingDetailTxt:@"开始解析"];
    for (CXMLElement* element in itemsArray){
        [itemDictionary setValue:[[element attributeForName:@"href"] stringValue] forKey:[[element attributeForName:@"id"] stringValue]];
        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]){
            ncxFile = [[element attributeForName:@"href"] stringValue]; //获取ncx文件名称 根据ncx获取书的目录
            //log
            NSInteger nIndex = [itemsArray indexOfObject:element];
            NSString* strDetail = [NSString stringWithFormat:@"开始解析资源(%zi/%zi)",nIndex,itemsArray.count];
            [MBProgressHUD setWaitingDetailTxt:strDetail];
        }
    }
    
    NSString *absolutePath = [opfPath stringByDeletingLastPathComponent];
    CXMLDocument *ncxDoc = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", absolutePath,ncxFile]] options:0 error:nil];
    NSMutableDictionary* titleDictionary = [[NSMutableDictionary alloc] init];
    for (CXMLElement* element in itemsArray) {
        NSString* href = [[element attributeForName:@"href"] stringValue];
        //zwq修改xpath的写法bgn 原来的是content[src = '%@']
        NSString* xpath = [NSString stringWithFormat:@"//ncx:content[starts-with(@src,'%@')]/../ncx:navLabel/ncx:text", href];
        //根据opf文件的href获取到ncx文件中的中对应的目录名称
        NSArray* navPoints = [ncxDoc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
        if([navPoints count]!=0){
            CXMLElement* titleElement = navPoints.firstObject;
            [titleDictionary setValue:[titleElement stringValue] forKey:href];
        }
        //log
        NSInteger nIndex = [itemsArray indexOfObject:element];
        NSString* strDetail = [NSString stringWithFormat:@"开始解析目录(%zi/%zi)",nIndex,itemsArray.count];
        [MBProgressHUD setWaitingDetailTxt:strDetail];
    }
    NSArray* itemRefsArray = [document nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    NSMutableArray *chapters = [NSMutableArray array];
    NSString* pSavedTitle = nil;//zwq
    for (CXMLElement* element in itemRefsArray){
        NSString* chapHref = [itemDictionary valueForKey:[[element attributeForName:@"idref"] stringValue]];
        //zwqbgn
        BOOL bInMenu = false;
        NSString*pTitle = [titleDictionary valueForKey:chapHref];
        if (pTitle != nil) {
            pSavedTitle = pTitle;
            bInMenu =true;
        }
        NSLog(@"当前章节名称是%@",pSavedTitle);
        //zwqend
        LSYChapterModel *model = [LSYChapterModel chapterWithEpub:[NSString stringWithFormat:@"%@/%@",absolutePath,chapHref] title:pSavedTitle isMenu:bInMenu];
        model.m_bInMenu = bInMenu;
        [chapters addObject:model];
        //log
        NSInteger nIndex = [itemRefsArray indexOfObject:element];
        NSString* strDetail = [NSString stringWithFormat:@"开始解析章节(%zi/%zi)",nIndex,itemRefsArray.count];
        [MBProgressHUD setWaitingDetailTxt:strDetail];
    }
    return chapters;
}
#pragma mark zwq
+(BOOL)isMoonMode
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"MoonMode"];
}
+(void)setMoonMode:(BOOL)bMoon
{
    [[NSUserDefaults standardUserDefaults]setBool:bMoon forKey:@"MoonMode"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end
