//
//  popMenu.m
//  LSYReader
//
//  Created by zhangwenqiang on 2017/2/17.
//  Copyright © 2017年 okwei. All rights reserved.
//

#import "popMenu.h"
//#import "AFNetworking.h"
#import "LSYReadPageViewController.h"
#import "SearchResultVC.h"
@interface popMenu()
@property(retain,nonatomic)NSArray*menus;
@property(nonatomic)CGRect targetRect;
@property(nonatomic)CGRect superViewBounds;
@end
@implementation popMenu
+(popMenu*)sharedPopMenu
{
    static popMenu *pPopMenu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray*nibView = [[NSBundle mainBundle] loadNibNamed:@"popMenu" owner:nil options:nil];
        pPopMenu= [nibView objectAtIndex:0];
        pPopMenu.hidden=true;
        pPopMenu.userInteractionEnabled =true;
        pPopMenu.upView.layer.cornerRadius=10;
        pPopMenu.downView.layer.cornerRadius=10;
    });
    return pPopMenu;
}
-(void)setMenuItems:(NSArray*)menuItems
{
    _menus=menuItems;

}
-(void)setTargetRect:(CGRect)targetRect inView:(nonnull UIView *)targetView
{
    //self.center=rtFrame.origin;
    _targetRect=targetRect;
    _superViewBounds=targetView.bounds;
    self.frame=[self getFrameBy:targetRect superViewBounds:targetView.bounds popViewBounds:self.bounds];

    [targetView addSubview:self];
    //添加菜单控件
    int x=10;
    for(UIView* pView in [_menuScroll subviews]){
        [pView removeFromSuperview];
    }
    for (UIMenuItem* pMenuItem in _menus)
    {
        UIButton*pButton=[[UIButton alloc]init];
        CGFloat fW=[pMenuItem.title sizeWithAttributes:@{NSFontAttributeName:pButton.titleLabel.font}].width;
        pButton.frame=CGRectMake(x, 0, fW, ViewSize(_menuScroll).height);
        x+=fW;
        x+=10;
        [pButton setTitle:pMenuItem.title forState:UIControlStateNormal];
        [pButton addTarget:targetView action:pMenuItem.action forControlEvents:UIControlEventTouchUpInside];
        [_menuScroll addSubview:pButton];
    }
}
-(void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
   //   [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self cache:YES];
    }
    [self setHidden:!menuVisible];
    if (animated) {
        [UIView commitAnimations];
    }
    if(menuVisible)
    {
        self.translateWords.text =@"正在查找网络翻译";
        NSString*pStrTo=@"zh";
        if ([self isIncludeChinese:self.originWords.text]) {
            pStrTo=@"en";
        }
        [self TransStr:self.originWords.text ToLanguage:pStrTo];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)TransStr:(NSString *) str ToLanguage:(NSString *)language
{
  //str=@"apple";
    if(!language)
    {
        language=@"en";
    }
    if (str == nil || str.length ==0) {
        self.translateWords.text =@"";
        return;
    }
    NSString*pAppid=@"20170221000039547";
    NSString*pSalt=@"1435660288";
    NSString*pSecret=@"zzVUQQMj_yJ5Qpdqveci";

    NSString*pSignOrign=[NSString stringWithFormat:@"%@%@%@%@",pAppid,str,pSalt,pSecret];
    NSString*pSign= [Tools getMD5:pSignOrign];
    NSString*pHttps=@"https://fanyi-api.baidu.com/api/trans/vip/translate";
    //NSString*pHttp=@"http://api.fanyi.baidu.com/api/trans/vip/translate";
    NSString *url = [NSString stringWithFormat:@"%@?q=%@&from=auto&to=%@&appid=%@&salt=%@&sign=%@",pHttps,str,language,pAppid,pSalt,pSign];
    //url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [HTTP getWithUrlString:url params:nil headers:nil isMainQueue:true success:^(id _Nonnull responseObject) {
        //解析返回结果
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString*pErrorCode=dict[@"error_code"];
        if (!pErrorCode||pErrorCode.intValue==52000)
        {
            NSArray *result = dict[@"trans_result"];
            NSDictionary *dd = [result firstObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.translateWords.text = dd[@"dst"];
            });
        }
        else
        {
            self.translateWords.text = [NSString stringWithFormat:@"翻译出错：%@,%@",dict[@"error_code"],dict[@"error_msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.translateWords.text = [NSString stringWithFormat:@"翻译出错：%@",error];
        });
    }];
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    [mgr GET:url parameters:nil progress:(^(NSProgress *downloadProgress){})
//     success:^(NSURLSessionDataTask *operation,id responseObject) {
//        //解析返回结果
//        NSDictionary *dict = (NSDictionary *)responseObject;
//         NSString*pErrorCode=dict[@"error_code"];
//         if (!pErrorCode||pErrorCode.intValue==52000)
//         {
//             NSArray *result = dict[@"trans_result"];
//             NSDictionary *dd = [result firstObject];
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 self.translateWords.text = dd[@"dst"];
//             });
//         }
//         else
//         {
//              self.translateWords.text = [NSString stringWithFormat:@"翻译出错：%@,%@",dict[@"error_code"],dict[@"error_msg"]];
//         }
//    } failure:^(NSURLSessionDataTask *operation,NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.translateWords.text = [NSString stringWithFormat:@"翻译出错：%@",error];
//        });
//    }];
}
- (IBAction)clickSystemDictionary:(id)sender
{
    UIReferenceLibraryViewController *referenceLibraryViewController =
    [[UIReferenceLibraryViewController alloc] initWithTerm:self.originWords.text];
    UIViewController*pPageVC=[LSYReadUtilites getReadPageVC];
    [pPageVC presentViewController:referenceLibraryViewController
                          animated:YES
                        completion:nil];
}

- (IBAction)clickBaiduBaike:(id)sender {
}

- (IBAction)searchInBook:(id)sender
{
    LSYReadPageViewController*pPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    NSString*pTxt=self.originWords.text;
    if (pPageVC&&pTxt)
    {
        SearchResultVC*pSearchRetVC=[[SearchResultVC alloc]init];
        pSearchRetVC.dataList=pPageVC.model.chapters;
        [pPageVC presentViewController:pSearchRetVC animated:YES completion:^{
            [pSearchRetVC.searchController setActive:true];
            pSearchRetVC.searchController.searchBar.text=pTxt;
            [pSearchRetVC searchTxt:pTxt];
        }];
    }
}
-(BOOL)isIncludeChinese:(NSString*)input
{
    if (input)
    {
        for(int i=0; i< [input length];i++)
        {
            int a =[input characterAtIndex:i];
            if( a >0x4e00&& a <0x9fff){
                return YES;
            }
        }
    }
    return NO;
}
-(void)changeDictionaryVisiable
{
//    [UIView beginAnimations:@"animation" context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    BOOL bDicHidden= [[NSUserDefaults standardUserDefaults]boolForKey:@"ReaderHiddenDictionary"];
    
    [[NSUserDefaults standardUserDefaults]setBool:!bDicHidden forKey:@"ReaderHiddenDictionary"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    CGRect AimRect=CGRectZero;
    if(bDicHidden)
    {
        CGRect rtBig=CGRectMake(0, 0, self.bounds.size.width, _upView.bounds.size.height+_downView.bounds.size.height+5);
        AimRect=[self getFrameBy:_targetRect superViewBounds:_superViewBounds popViewBounds:rtBig];
    }
    else
    {
        CGRect rtBig=CGRectMake(0, 0, self.bounds.size.width, _upView.bounds.size.height+20);
        AimRect=[self getFrameBy:_targetRect superViewBounds:_superViewBounds popViewBounds:rtBig];
    }
    //CGFloat fY=AimRect.size.height/ViewSize(self).height;
    self.layer.position=CGPointMake(CGRectGetMaxX(AimRect), CGRectGetMaxY(AimRect));
    self.layer.anchorPoint=CGPointMake(1, 1);
    [UIView animateWithDuration:0.5 animations:^{
        _downView.hidden=!bDicHidden;
        self.frame=AimRect;
//        self.center=CGPointMake(CGRectGetMidX(AimRect), CGRectGetMidY(AimRect));
//        self.bounds=CGRectMake(0, 0, CGRectGetMaxX(AimRect), CGRectGetMaxY(AimRect));
       //self.transform = CGAffineTransformMakeScale(1, fY);
    } completion:^(BOOL finished) {
        
        
        //self.transform = CGAffineTransformMakeScale(1, 1/fY);
    }];
    
}
-(CGRect)getFrameBy:(CGRect)targetRect superViewBounds:(CGRect)superViewBounds popViewBounds:(CGRect)popBounds
{
    //计算弹窗的区域
    CGRect rtBounds=popBounds;

    rtBounds.origin.x=CGRectGetMidX(targetRect)-popBounds.size.width*.5;
    if (rtBounds.origin.x<0)
    {
        rtBounds.origin.x=0;
    }
    else if (rtBounds.origin.x>superViewBounds.size.width-popBounds.size.width)
    {
        rtBounds.origin.x=superViewBounds.size.width-popBounds.size.width;
    }

    _downImg.hidden=true;
    _upImg.hidden=true;
    if( popBounds.size.height<=targetRect.origin.y)
    {
        rtBounds.origin.y=targetRect.origin.y-popBounds.size.height;
        _downImg.hidden=false;
        //_downImg.center=CGPointMake(CGRectGetMaxX(targetRect)-rtBounds.origin.x, targetRect.origin.y-5);
        _downArrowX.constant=CGRectGetMidX(targetRect)-rtBounds.origin.x-ViewSize(_downImg).width*.5;
    }
    else if (popBounds.size.height<= CGRectGetMaxY(superViewBounds)-CGRectGetMaxY(targetRect))
    {
        rtBounds.origin.y=CGRectGetMaxY(targetRect);
        _upImg.hidden=false;
        _topArrowX.constant=CGRectGetMidX(targetRect)-rtBounds.origin.x-ViewSize(_upImg).width*.5;
       // _upImg.center=CGPointMake(CGRectGetMaxX(targetRect)-rtBounds.origin.x, rtBounds.origin.y+5);
    }
    else
    {
        rtBounds.origin.y= CGRectGetMidY(superViewBounds)-popBounds.size.height*.5;
    }
    return rtBounds;
}
@end
