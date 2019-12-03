//
//  Tools.m
//  LSYReader
//
//  Created by zhangwenqiang on 2016/12/27.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>//for md5
@implementation Tools
+(CGSize)getImgSize:(UIImage*)pImg inSize:(CGSize)pSizeMax;
{
    CGSize pSize=CGSizeZero;
    if (pImg) {
        float fW=CGImageGetWidth(pImg.CGImage);
        float fH=CGImageGetHeight(pImg.CGImage);
        if (fW<pSizeMax.width&&fH<pSizeMax.height) {
            pSize=CGSizeMake(fW, fH);
        }
        else if (fW>=pSizeMax.width&&fH>pSizeMax.height)
        {
            if (fW/fH>pSizeMax.width/pSizeMax.height) {
                pSize=CGSizeMake(pSizeMax.width, fH*(pSizeMax.width/fW));
            }
            else
            {
                pSize=CGSizeMake(fW*(pSizeMax.height/fH), pSizeMax.height);
            }
        }
        else if (fW>=pSizeMax.width)
        {
             pSize=CGSizeMake(pSizeMax.width, fH*(pSizeMax.width/fW));
        }
        else if (fH>pSizeMax.height)
        {
             pSize=CGSizeMake(fW*(pSizeMax.height/fH), pSizeMax.height);
        }
    }
    return pSize;
}
+(NSString*)getPath:(NSString*)pOrignalPath forAbsolute:(BOOL)bAbs
{
    NSString*pRet=nil;
    if (pOrignalPath)
    {
        NSString*pHome=NSHomeDirectory();
        if (bAbs) {
            pRet=[pHome stringByAppendingPathComponent:pOrignalPath];
        }
        else if([pOrignalPath hasPrefix:pHome])
        {
            pRet=[pOrignalPath substringFromIndex:pHome.length];
        }
    }
    return pRet;
}
+(NSString*)curDate2NSString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}
+(NSDate*)NSString2Date:(NSString*)strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:strDate];
    return date;
}
+ (NSDate *)worldTimeToChinaTime:(NSDate *)date
{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    return localeDate;
}

+(NSString*)getMD5:(NSString*)string
{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return [result lowercaseString];
}

#pragma mark 修改字符串中数字的颜色
+(NSAttributedString *)changeNumnerColorInString:(NSString *)content
{
    NSArray *number = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"%"];
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:content];
    for (int i = 0; i < content.length; i ++) {
        
        //这里的小技巧，每次只截取一个字符的范围
        
        NSString *a = [content substringWithRange:NSMakeRange(i, 1)];
        
        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        
        if ([number containsObject:a]) {
            
            [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#C6244C"]} range:NSMakeRange(i, 1)];
            
        }
    }
    return attributeString;
}

@end
