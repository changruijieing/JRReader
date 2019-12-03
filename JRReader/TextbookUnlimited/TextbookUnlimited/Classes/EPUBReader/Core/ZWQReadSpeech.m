//
//  ZWQReadspeech.m
//  LSYReader
//
//  Created by zhangwenqiang on 2017/2/10.
//  Copyright © 2017年 okwei. All rights reserved.
//

#import "ZWQReadSpeech.h"
#import "LSYReadUtilites.h"
#import "LSYReadPageViewController.h"
@interface ZWQReadspeech()<AVSpeechSynthesizerDelegate>
@property(nonatomic)NSRange rangeDisplay;//页面内容中 正在朗读的句子所在的区域
@end
@implementation ZWQReadspeech
+(instancetype)shareInstance
{
    static ZWQReadspeech *pSelf = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pSelf = [[self alloc] init];
        
    });
    return pSelf;
}
-(void)speakWords:(NSString*)pWords
{
    if (self.synthsizer.paused)
    {
        [self stopSpeak];
        return;
    }
    //pWords=@"每天读懂一点好玩心理学.";
    if (pWords)
    {
        _strPageContent=pWords;
        NSArray*aryWords=[pWords componentsSeparatedByString:@"\n"];
        _nRemainSentenceOfPage=aryWords.count;
        for (NSString* pWord in aryWords)
        {
            AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc] initWithString:pWord];//需要转换的文本
            utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//国家语言
            utterance.rate = 0.4f;//声速
            //utterance.postUtteranceDelay=0.5;
            [self.synthsizer speakUtterance:utterance];
        }
        
    }
}
-(void)stopSpeak
{
    _strPageContent=nil;
    self.bSpeaking=false;
    [self.synthsizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    LSYReadPageViewController*pPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    if (pPageVC)
    {
        [LSYReadConfig shareInstance].readRange=NSMakeRange(0, 0);
        [pPageVC RefreshPage];
    }
}
-(AVSpeechSynthesizer *)synthsizer
{
    if (!_synthsizer) {
        _synthsizer=[[AVSpeechSynthesizer alloc] init];
        _synthsizer.delegate=self;
    }
    return _synthsizer;
}
#pragma mark delegate
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    self.bSpeaking=true;
    //计算页面内容中的阅读句子显示区域
    NSRange rangeSentence=[_strPageContent rangeOfString:utterance.speechString];
    NSCharacterSet*SentenceOverSet=[self getSentenceOverSet];
    NSRange SentenceOverRange= [utterance.speechString rangeOfCharacterFromSet:SentenceOverSet];
    if (SentenceOverRange.length>0) {
        _rangeDisplay=NSMakeRange(rangeSentence.location,NSMaxRange(SentenceOverRange));
    }
    else
    {
        _rangeDisplay=NSMakeRange(rangeSentence.location,utterance.speechString.length);
    }
    LSYReadPageViewController*pPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    if (pPageVC)
    {
        LSYChapterModel*curChapter=[pPageVC.model.record getRecordChapterModal];
        [LSYReadConfig shareInstance].readRange=[curChapter getChapterRangeBy:_rangeDisplay withPage:pPageVC.model.record.page];
        [pPageVC RefreshPage];
    }
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    _nRemainSentenceOfPage--;
    NSLog(@"%zi\n",_nRemainSentenceOfPage);
    if (self.bSpeaking&&_nRemainSentenceOfPage==0)//需要翻页
    {
        self.bSpeaking=false;
        LSYReadPageViewController*pPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
        if (pPageVC) {
            if([pPageVC ShowNextPage])
            {
                [pPageVC readBook];
            }
            else
            {
                [self stopSpeak];
            }
        }
    }
//    else
//    {
//        self.bSpeaking=false;
//        [LSYReadConfig shareInstance].readRange=NSMakeRange(0, 0);
//    }
}


- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance
{
    self.bSpeaking=false;
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance
{
    self.bSpeaking=true;
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance
{
    self.bSpeaking=false;
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
    NSRange rangeSentence=[_strPageContent rangeOfString:utterance.speechString];
    NSRange pageRange=NSMakeRange(characterRange.location+rangeSentence.location,characterRange.length);
    if (NSIntersectionRange(pageRange, _rangeDisplay).length==0)
    {
        NSString*SubString=[utterance.speechString substringFromIndex:characterRange.location];
        NSCharacterSet*SentenceOverSet=[self getSentenceOverSet];
        NSRange SentenceOverRange= [SubString rangeOfCharacterFromSet:SentenceOverSet];
        
        if (SentenceOverRange.length>0) {
            _rangeDisplay=NSMakeRange(rangeSentence.location+characterRange.location, NSMaxRange(SentenceOverRange));
        }
        else
        {
            _rangeDisplay=NSMakeRange(rangeSentence.location+characterRange.location, SubString.length);
        }
        LSYReadPageViewController*pPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
        if (pPageVC)
        {
            LSYChapterModel*curChapter=[pPageVC.model.record getRecordChapterModal];
            [LSYReadConfig shareInstance].readRange=[curChapter getChapterRangeBy:_rangeDisplay withPage:pPageVC.model.record.page];
            [pPageVC RefreshPage];
        }
    }

}
-(NSCharacterSet*)getSentenceOverSet
{
    return [NSCharacterSet characterSetWithCharactersInString:@".。?？\n"];
}
@end
