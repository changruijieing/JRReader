//
//  LSYReadView.h
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"
@protocol LSYReadViewControllerDelegate;
@interface LSYReadView : UIView<UIDocumentInteractionControllerDelegate>
@property (nonatomic,assign) CTFrameRef frameRef;
@property (nonatomic,strong) NSArray *imageArray;
//@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSMutableAttributedString *ChapterAttributedTxt;
@property (nonatomic,strong) id<LSYReadViewControllerDelegate>delegate;

-(void)cancelSelected;
//zwqbgn 默认返回空,如果点击的是链接,则返回链接内容
-(NSString*)handleTapPoint:(CGPoint)ptTab;

//zwqend
@end
