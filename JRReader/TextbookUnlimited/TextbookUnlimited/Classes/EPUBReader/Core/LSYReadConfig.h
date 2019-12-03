//
//  LSYReadConfig.h
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kMaxTransparent 0.5f//遮罩层最大的不透明度
@interface LSYReadConfig : NSObject<NSCoding>
+(instancetype)shareInstance;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat lineSpace;
@property (nonatomic,strong) UIColor *fontColor;
@property (nonatomic,strong) UIColor *theme;
#pragma mark heightlight 高亮区域和字符串
@property (nonatomic)NSRange  HeightLightRange;
@property (nonatomic,strong) NSString* HeightLightString;
@property (nonatomic)NSRange readRange;//朗读时的区域位置
#pragma mark zwq
@property (nonatomic) CGFloat fontOffset;
@property (nonatomic) CGFloat brightness;//控制阅读界面的亮度
//用当前的配置格式化富文本
-(void)formatString:(NSMutableAttributedString**)AttributeString by:(CGFloat)CurContentFontSize;
@end
