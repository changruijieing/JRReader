//
//  shareScreen.h
//  LSYReader
//
//  Created by zhangwenqiang on 2017/2/15.
//  Copyright © 2017年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shareScreen : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *Namelabel;
@property (weak, nonatomic) IBOutlet UILabel *Datelabel;
@property (weak, nonatomic) IBOutlet UITextView *shareContent;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UIImageView *bookCover;
//返回图片路径
-(NSString*)saveScreenShot;
//重新计算高度,使所有分享内容都能在图片中显示
-(void)resize;
@end
