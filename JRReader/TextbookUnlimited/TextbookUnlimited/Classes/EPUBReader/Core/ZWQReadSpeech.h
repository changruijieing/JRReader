//
//  ZWQReadspeech.h
//  LSYReader
//
//  Created by zhangwenqiang on 2017/2/10.
//  Copyright © 2017年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<AVFoundation/AVFoundation.h>

@interface ZWQReadspeech : NSObject<AVSpeechSynthesizerDelegate>
@property (nonatomic,strong)AVSpeechSynthesizer * synthsizer;
@property (nonatomic,strong)NSString* strPageContent;
@property(nonatomic)NSUInteger nRemainSentenceOfPage;
@property(nonatomic)Boolean bSpeaking;//区分用户主动停止,还是本页读完了的停止
+(instancetype)shareInstance;
-(void)speakWords:(NSString*)pWords;
-(void)stopSpeak;
@end
