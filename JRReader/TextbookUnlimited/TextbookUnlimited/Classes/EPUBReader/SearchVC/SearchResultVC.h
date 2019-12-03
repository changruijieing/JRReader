//
//  SearchResultVC.h
//  LSYReader
//
//  Created by 张文强 on 2016/12/8.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYReadPageViewController.h"
#import "DocSearchVC.h"
#import "ContentSearchCell.h"
//@class <#name#>
@interface SearchResultVC : UIViewController<UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) UISearchController*   searchController;
@property (nonatomic,strong)  UILabel*              pLabel;
@property (nonatomic, strong) NSMutableArray*       searchList;
@property (nonatomic, strong) NSMutableArray*       dataList;
@property (nonatomic, strong) UITableView   *       tableView;
-(void)searchTxt:(NSString*)pTxt;
@end
