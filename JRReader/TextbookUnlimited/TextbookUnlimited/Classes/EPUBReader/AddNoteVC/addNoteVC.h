//
//  addNoteVC.h
//  LSYReader
//
//  Created by zhangwenqiang on 2017/1/11.
//  Copyright © 2017年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addNoteVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *ContentView;
@property (weak, nonatomic) IBOutlet UITextView *noteView;
@property(nonatomic)NSRange rangeSelect; //笔记选中内容的位置及长度
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
- (IBAction)cancel:(id)sender;
- (IBAction)addNote:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NavBarTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NoteHeight;


@end
