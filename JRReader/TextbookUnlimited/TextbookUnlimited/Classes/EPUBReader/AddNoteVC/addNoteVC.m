//
//  addNoteVC.m
//  LSYReader
//
//  Created by zhangwenqiang on 2017/1/11.
//  Copyright © 2017年 okwei. All rights reserved.
//

#import "addNoteVC.h"
#import "LSYReadPageViewController.h"
#import "IQKeyboardManager.h"
@interface addNoteVC ()

@end

@implementation addNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    _noteView.inputAccessoryView=[[UIView alloc]initWithFrame:CGRectZero];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self back];
}

- (IBAction)addNote:(id)sender
{
    LSYNoteModel *model = [[LSYNoteModel alloc] init];
   // model.content = _ContentView.text;
    model.note = _noteView.text;
    model.date = [NSDate date];
    model.ChapterRange=_rangeSelect;
    [[NSNotificationCenter defaultCenter] postNotificationName:LSYNoteNotification object:model];
    [self back];
}
-(void)back
{
    LSYReadPageViewController*pPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    [pPageVC dismissViewControllerAnimated:YES completion:^{}];
}

-(void)setNoteFrame:(NSNotification *)notification //willShow:(BOOL)bHidden
{
    //return;1
    CGFloat fGapH=10;
    CGFloat fStatusBarH=[UIApplication sharedApplication].statusBarFrame.size.height;

    CGRect rtView=self.view.frame;
    CGFloat dltY=-rtView.origin.y+fStatusBarH;
    _NavBarTop.constant=dltY;
 
    NSDictionary *info = [notification userInfo];
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
   // NSLog(@"横屏%f",keyboardSize.height);
    CGFloat keyboardHeight = keyboardSize.height;
    CGFloat fScreenH=[UIScreen mainScreen].bounds.size.height;
    CGFloat fHeadHeight=fStatusBarH+_ContentView.frame.size.height+44+fGapH*3;
    float NoteHeigth=fScreenH-fHeadHeight-keyboardHeight;
    _NoteHeight.constant=NoteHeigth;
}

-(void)KeyboardWillShow:(NSNotification *)notification
{
   // [self setNoteFrame:notification willShow:YES];
}
-(void)KeyboardDidShow:(NSNotification *)notification
{
    //[self setNoteFrame:notification willShow:NO];
    [self performSelector:@selector(setNoteFrame:) withObject:notification afterDelay:0];
    
}
-(void)viewWillLayoutSubviews
{
    
}
@end
