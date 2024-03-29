//
//  LSYReadUtilites.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tools.h"
@interface LSYReadUtilites : NSObject
+(void)separateChapter:(NSMutableArray **)chapters content:(NSString *)content;
+(NSString *)encodeWithURL:(NSURL *)url;
+(UIButton *)commonButtonSEL:(SEL)sel target:(id)target;
+(UIViewController *)getCurrentVC;
+(void)showAlertTitle:(NSString *)title content:(NSString *)string;
/**
 * ePub格式处理
 * 返回章节信息数组
 */
+(NSMutableArray *)ePubFileHandle:(NSString *)path;
//zwq bgn

+(UIViewController*)getReadPageVC;
+(void)setReadPageVC:(UIViewController*)pVC;
+(BOOL)isMoonMode;
+(void)setMoonMode:(BOOL)bMoon;
//zwqend
@end
