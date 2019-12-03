//
//  shareScreen.m
//  LSYReader
//
//  Created by zhangwenqiang on 2017/2/15.
//  Copyright © 2017年 okwei. All rights reserved.
//

#import "shareScreen.h"

@implementation shareScreen

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(NSString*)saveScreenShot
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSString*pPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/shareScrren.jpg"];
    NSData*pImgData=UIImageJPEGRepresentation(image, 1.0);
    BOOL bRet=[pImgData writeToFile:pPath atomically:YES];
    return  bRet?pPath:nil;
}
-(void)resize
{
    CGFloat fDltHeight=_shareContent.contentSize.height-_shareContent.frame.size.height;
    if (fDltHeight>0)
    {
        self.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height+fDltHeight);
        [self layoutSubviews];
    }
}
@end
