//
//  popMenu.h
//  LSYReader
//
//  Created by zhangwenqiang on 2017/2/17.
//  Copyright © 2017年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface popMenu : UIView<UIScrollViewDelegate>
+(nonnull popMenu*)sharedPopMenu;
-(void)setMenuItems:(nullable NSArray*)menuItems;
-(void)setTargetRect:(CGRect)targetRect inView:(nonnull UIView *)targetView;
-(void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated;
@property (weak, nonatomic) IBOutlet  UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (weak, nonatomic) IBOutlet UIScrollView *menuScroll;
@property (weak, nonatomic) IBOutlet UILabel *originWords;
@property (weak, nonatomic) IBOutlet UITextView *translateWords;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UIImageView *upImg;//向上的箭头
@property (weak, nonatomic) IBOutlet UIImageView *downImg;//向下的箭头
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topArrowX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downArrowX;
- (IBAction)clickSystemDictionary:(nullable id)sender;
- (IBAction)clickBaiduBaike:(nullable id)sender;
- (IBAction)searchInBook:(id)sender;
-(void)changeDictionaryVisiable;
@end
