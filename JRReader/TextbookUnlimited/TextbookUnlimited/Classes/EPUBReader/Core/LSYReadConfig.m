//
//  LSYReadConfig.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadConfig.h"
#define defaultbookBgColor [UIColor colorWithWhite:239.0/255 alpha:1]
@implementation LSYReadConfig
+(instancetype)shareInstance
{
    static LSYReadConfig *readConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        readConfig = [[self alloc] init];
        
    });
    return readConfig;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReadConfig"];
        if (data) {
            NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
            LSYReadConfig *config = [unarchive decodeObjectForKey:@"ReadConfig"];
            [config addObserver:config forKeyPath:@"fontSize" options:NSKeyValueObservingOptionNew context:NULL];
            [config addObserver:config forKeyPath:@"lineSpace" options:NSKeyValueObservingOptionNew context:NULL];
            [config addObserver:config forKeyPath:@"fontColor" options:NSKeyValueObservingOptionNew context:NULL];
            [config addObserver:config forKeyPath:@"theme" options:NSKeyValueObservingOptionNew context:NULL];
            [config addObserver:config forKeyPath:@"brightness" options:NSKeyValueObservingOptionNew context:NULL];
            return config;
        }
        _lineSpace = 10.0f;
        _fontSize = 14.0f;
        _fontColor = [UIColor blackColor];
        _theme = defaultbookBgColor;
        _brightness=kMaxTransparent;
        [self addObserver:self forKeyPath:@"fontSize" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"lineSpace" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"fontColor" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"theme" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"brightness" options:NSKeyValueObservingOptionNew context:NULL];
        [LSYReadConfig updateLocalConfig:self];
        
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [LSYReadConfig updateLocalConfig:self];
}
+(void)updateLocalConfig:(LSYReadConfig *)config
{
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:config forKey:@"ReadConfig"];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"ReadConfig"];
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.fontSize forKey:@"fontSize"];
    [aCoder encodeDouble:self.lineSpace forKey:@"lineSpace"];
    [aCoder encodeObject:self.fontColor forKey:@"fontColor"];
    [aCoder encodeObject:self.theme forKey:@"theme"];
    [aCoder encodeDouble:self.brightness forKey:@"brightness"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.fontSize = [aDecoder decodeDoubleForKey:@"fontSize"];
        self.lineSpace = [aDecoder decodeDoubleForKey:@"lineSpace"];
        self.fontColor = [aDecoder decodeObjectForKey:@"fontColor"];
        self.theme = [aDecoder decodeObjectForKey:@"theme"];
        self.brightness = [aDecoder decodeDoubleForKey:@"brightness"];
    }
    return self;
}
#pragma mark zwq
//用当前的配置格式化富文本
-(void)formatString:(NSMutableAttributedString**)attributedString by:(CGFloat)CurContentFontSize;
{
    if (!*attributedString||_fontOffset==0) {
        return;
    }
    //字体
    [*attributedString enumerateAttributesInRange:NSMakeRange(0, [*attributedString length])
                                          options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                                       usingBlock:^(NSDictionary<NSString *, id> *attrs, NSRange range, BOOL *stop)
    {
        //字体
        UIFont*font=attrs[NSFontAttributeName];
        CGFloat CurfontSize=_fontSize;
        CGFloat TargetFontSize=_fontSize;
        if (font)
        {
            UIFontDescriptor *ctfFont = font.fontDescriptor;
            NSNumber* FontSize= [ctfFont objectForKey:@"NSFontSizeAttribute"];
           // CGFloat LastFontSize=_fontSize+_fontOffset;
            if (FontSize.floatValue!=CurContentFontSize)
            {
               TargetFontSize=FontSize.floatValue+_fontOffset;
            }
        }
        [*attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:TargetFontSize] range:range];
        
        //段落
        NSMutableParagraphStyle *paragraphStyle =[attrs[NSParagraphStyleAttributeName] mutableCopy];
        if(!paragraphStyle)
        {
            paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment =NSTextAlignmentLeft;
        }
        paragraphStyle.lineSpacing = _lineSpace;
        if (paragraphStyle.alignment!=NSTextAlignmentCenter)
        {
            CGSize size2words= [@"两个"   sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:CurfontSize]}];
            paragraphStyle.firstLineHeadIndent = size2words.width;
        }
        else
        {
            paragraphStyle.firstLineHeadIndent =0;
        }
        [*attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    }];
    _fontOffset=0;
}
@end
