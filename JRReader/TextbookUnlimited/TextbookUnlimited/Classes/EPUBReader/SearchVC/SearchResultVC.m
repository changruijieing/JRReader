//
//  SearchResultVC.m
//  LSYReader
//
//  Created by 张文强 on 2016/12/8.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "SearchResultVC.h"
#import "LSYChapterModel.h"

#import "LSYReadPageViewController.h"
@interface SearchResultVC ()

@end

@implementation SearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}
-(UISearchController*)searchController
{
    if (!_searchController)
    {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.searchBar.delegate=self;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        
        _searchController.searchBar.frame = CGRectMake(_searchController.searchBar.frame.origin.x, _searchController.searchBar.frame.origin.y, _searchController.searchBar.frame.size.width, 44.0);
        self.tableView.tableHeaderView = _searchController.searchBar;
        [self.view addSubview:self.tableView];
    }
    return _searchController;
}
-(NSMutableArray*)searchList
{
    if (!_searchList)
    {
        _searchList=[[NSMutableArray alloc]initWithCapacity:10];
    }
    return _searchList;
}
-(UITableView*)tableView
{
    if (!_tableView)
    {
        CGFloat fBarH=[UIApplication sharedApplication].statusBarFrame.size.height;
        CGRect rtTable=CGRectMake(0, fBarH, ScreenSize.width, ScreenSize.height-fBarH);
        _tableView=[[UITableView alloc]initWithFrame:rtTable];
        _tableView.dataSource=self;
        _tableView.delegate=self;
    }
    return _tableView;
}
-(void)searchTxt:(NSString*)searchString
{
    [self.searchList removeAllObjects];
    //    //过滤数据
    //    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    for (LSYChapterModel*pChapter in self.dataList) {
        if (pChapter.title )
        {
            NSString*content=pChapter.title;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:searchString  options:NSRegularExpressionCaseInsensitive error:nil];
            NSArray *array = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
            for (NSTextCheckingResult* b in array)
            {
                ContentSearchModel*pMode=[[ContentSearchModel alloc]init];
                pMode.pChapterName=pChapter.title;
                pMode.nChapter=[self.dataList indexOfObject:pChapter];
                pMode.rangeInChapter=b.range;
                pMode.bInTitle=true;
                [_searchList addObject:pMode];
            }
        }
        if(pChapter.AttributedTxt.string)
        {
            NSString*content=pChapter.AttributedTxt.string;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:searchString  options:NSRegularExpressionCaseInsensitive error:nil];
            NSArray *array = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
            for (NSTextCheckingResult* b in array)
            {
                ContentSearchModel*pMode=[[ContentSearchModel alloc]init];
                pMode.pChapterName=pChapter.title;
                pMode.nChapter=[self.dataList indexOfObject:pChapter];
                pMode.rangeInChapter=b.range;
                pMode.bInTitle=false;
                [_searchList addObject:pMode];
            }
        }
    }
    //刷新表格
    [self.tableView reloadData];
}
#pragma mark SearchBar delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self back];
}
#pragma mark Search delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchController.searchBar text];
    if (searchString&&![searchString isEqualToString:@""])
    {
         [self searchTxt:searchString];
    }
   
 
}
#pragma mark tableview delegate
//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchList count];
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *flag=@"cellFlag";
    ContentSearchCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell==nil) {
        cell=[[ContentSearchCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:flag];
    }
    NSString*pStr=self.searchController.searchBar.text;
//    if (self.searchController.active)
    {
        ContentSearchModel*pModel=(ContentSearchModel*)self.searchList[indexPath.row];
        [cell.textLabel setText:pModel.pChapterName];
        cell.pSearchModel=pModel;
        if (pModel.bInTitle)
        {
            //富文本
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:cell.textLabel.text];
            //添加文字颜色
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:pModel.rangeInChapter];
            cell.textLabel.attributedText=attrStr;
        }
        else
        {
            LSYChapterModel*pChapter=self.dataList[pModel.nChapter];
            NSRange SearchRange=pModel.rangeInChapter;
            NSRange displayRange=NSMakeRange(SearchRange.location, SearchRange.length);
            //显示位置是搜索位置前后加10
            displayRange.location=SearchRange.location>10?SearchRange.location-10:0;
            displayRange.length=MIN(SearchRange.length+20,pChapter.AttributedTxt.length-displayRange.location);
            //如果中间有换行或空格,则从换行或或空格开始
            NSRange rangLastSpaceOrNextLine=[pChapter.AttributedTxt.string rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] options:NSBackwardsSearch range:NSMakeRange(0, SearchRange.location)];
            if (rangLastSpaceOrNextLine.length>0&&SearchRange.location-rangLastSpaceOrNextLine.location<10) {
                displayRange.location=NSMaxRange(rangLastSpaceOrNextLine);
            }
            cell.detailTextLabel.text=[pChapter.AttributedTxt.string substringWithRange:displayRange];
            //富文本
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:cell.detailTextLabel.text];
            //添加文字颜色
            NSRange rangeInDispalyText=NSMakeRange(SearchRange.location-displayRange.location,pStr.length);
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangeInDispalyText];
            cell.detailTextLabel.attributedText=attrStr;
        }
    }
//    else
//    {
//        LSYChapterModel*pModel=(LSYChapterModel*)self.dataList[indexPath.row];
//        [cell.textLabel setText:pModel.title];
//    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContentSearchCell*pCell=[tableView cellForRowAtIndexPath:indexPath];
    LSYChapterModel*pChapterModel=nil;
    NSUInteger nPage=0;
    NSUInteger nChapterIndex=indexPath.row;//搜索页面默认显示的是章数
//    if (self.searchController.active)
//    {
         nChapterIndex=pCell.pSearchModel.nChapter;
        pChapterModel=(LSYChapterModel*)self.dataList[pCell.pSearchModel.nChapter];
        NSUInteger nIndex=pCell.pSearchModel.rangeInChapter.location;
        nPage=[pChapterModel getPageByLocation:nIndex];
//    }
//    else if(indexPath.row<self.dataList.count)
//    {
//        pChapterModel=(LSYChapterModel*)self.dataList[indexPath.row];
//    }
    LSYReadPageViewController*pPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    if (pPageVC)
    {
        [LSYReadConfig shareInstance].HeightLightString=self.searchController.searchBar.text;
        [LSYReadConfig shareInstance].HeightLightRange=pCell.pSearchModel.rangeInChapter;
        [pPageVC menuViewJumpChapter:nChapterIndex page:nPage];
        [pPageVC dismissViewControllerAnimated:YES completion:^{
            [pPageVC hiddenMenu];
        }];
    }
}
-(void)back
{
    LSYReadPageViewController*pPageVC=(LSYReadPageViewController*)[LSYReadUtilites getReadPageVC];
    if (pPageVC)
    {
        [pPageVC dismissViewControllerAnimated:YES completion:^{
            [pPageVC hiddenMenu];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
