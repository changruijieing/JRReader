//
//  Tools.h
//  LSYReader
//
//  Created by zhangwenqiang on 2016/12/27.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Hex.h"
@interface Tools : NSObject
//图片自适应缩放
+(CGSize)getImgSize:(UIImage*)pImg inSize:(CGSize)pSizeMax;
//获取绝对路径或相对路径,
+(NSString*)getPath:(NSString*)pOrignalPath forAbsolute:(BOOL)bAbs;
//日期和字符串的相互转换
+(NSString*)curDate2NSString;
+(NSDate*)NSString2Date:(NSString*)strDate;
// 获取md5值
+(NSString*)getMD5:(NSString*)input;
// 修改字符串中数字的颜色
+(NSAttributedString *)changeNumnerColorInString:(NSString *)content;
@end
