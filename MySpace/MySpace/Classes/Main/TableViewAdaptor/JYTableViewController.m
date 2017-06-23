//
//  JYTableViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/5/5.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYTableViewController.h"
#import "JYTableViewModel.h"
#import "JYTableViewCellModel.h"
#import "JYTableViewCell.h"


@interface JYTableViewController ()<UITableViewDelegate,UITableViewDataSource, JYTableViewCellDelegate>

@end

@implementation JYTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self)
    {
        //初始化tableView
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.tableView.separatorColor = COLOR_STYLE_7;
        
//        self.tableView.tableFooterView = [[UIView alloc] init];
        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
//        view.backgroundColor = [UIColor redColor];
//        self.tableView.tableHeaderView = view;
        
//        UIEdgeInsets tableContentInset = UIEdgeInsetsMake(-20, 0, 50, 0);
//
//        self.tableView.contentInset = tableContentInset;

        self.view = self.tableView;
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self init];
    if (self)
    {
        self.tableView.frame = frame;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//setter方法,主要是为了监听ViewModel赋值然后与tableview联动
- (void)setViewModel:(JYTableViewModel *)viewModel
{
    _viewModel = viewModel;
    
    if (_viewModel && _viewModel.sectionModels.count && _tableView)
    {
        [_viewModel iterateCellClassBlock:^(__unsafe_unretained Class cellClass, NSString *cellReuseIdentifier)
         {
             [self.tableView registerClass:cellClass forCellReuseIdentifier:cellReuseIdentifier];
         }];
        
//        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            
//        }];
//        
//        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            
//        }];
        
        
        [self.tableView setDataSource:nil];
        [self.tableView setDelegate:nil];
        
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
    }
    else
    {
        
        [self.tableView setDataSource:nil];
        [self.tableView setDelegate:nil];
    }
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfRowsInSection:section];
}

// 应用了重用机制直接联立model
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYTableViewCellModel *cellModel = [self.viewModel cellModelForRowAtIndexPath:indexPath];
    
    Class cellClass = cellModel.cellClass;
    
    JYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
//    [cell tableViewModel:self.viewModel configureCellStyleForIndexPath:indexPath];
    cell.delegate = self;
    
    cell.cellModel = cellModel;
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tablevView:scrollViewDidScroll:)])
    {
        return [self.delegate tablevView:self.tableView scrollViewDidScroll:scrollView];
    }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYTableViewCellModel *cellModel = [self.viewModel cellModelForRowAtIndexPath:indexPath];
    
    if (!cellModel || !cellModel.rowHeight || cellModel.rowHeight == 0.0f)
    {
        Class cellClass = cellModel.cellClass;
        return [cellClass cellHeightForCellModel:cellModel];
    }
    
    return cellModel.rowHeight;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(__unused UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // 获取Header高度的方法：代理实现优先
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewModel:heightForHeaderInSection:)])
    {
        return [self.delegate tableViewModel:self.viewModel heightForHeaderInSection:section];
    }
    
    
    JYTableViewSectionModel *sectionModel = self.viewModel.sectionModels[section];
    if (!sectionModel.sectionHeaderHeight || sectionModel.sectionHeaderHeight == 0.0f) {
        return 0;
    }
    return sectionModel.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewModel:heightForFooterInSection:)])
    {
        return [self.delegate tableViewModel:self.viewModel heightForFooterInSection:section];
    }
    
    return 0.01f;
}

- (UIView *)tableView:(__unused UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 获取HeaderView：代理实现优先
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:tableViewModel:viewForHeaderInSection:)])
    {
        return [self.delegate tableView:tableView tableViewModel:self.viewModel viewForHeaderInSection:section];
    }
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:tableViewModel:viewForFooterInSection:)])
    {
        return [self.delegate tableView:tableView tableViewModel:self.viewModel viewForFooterInSection:section];
    }
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}

//- (UIView *)tableView:(__unused UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    // 获取FooterView：代理实现优先
////    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewModel:viewForHeaderInSection:)])
////    {
////        return [self.delegate tableViewModel:self.viewModel viewForFooterInSection:section];
////    }
//    
////    if (section == 0) {
//        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
//        view.backgroundColor = COLOR_STYLE_8;
//        return view ;
////    }
////    else
////    {
////        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
////        view.backgroundColor = [UIColor redColor];
////        return view ;
////    }
//    
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewModel:didSelectCellModel:atIndexPath:)])
    {
        JYTableViewCellModel *cellModel = [self.viewModel cellModelForRowAtIndexPath:indexPath];
        [self.delegate tableViewModel:self.viewModel didSelectCellModel:cellModel atIndexPath:indexPath];
    }
}

#pragma mark - JYTableViewCellDelegate

- (void)didTouchUpInsideCell:(JYTableViewCell *)cell clickButton:(UIButton *)button
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewModel:didTouchUpInsideButton:cellModel:atIndexPath:)])
    {
        JYTableViewCellModel *cellModel = [self.viewModel cellModelForRowAtIndexPath:indexPath];
        [self.delegate tableViewModel:self.viewModel didTouchUpInsideButton:button cellModel:cellModel atIndexPath:indexPath];
    }
    
    
    
}

- (void)dealloc
{
    [self setDelegate:nil];
    
    [_tableView setDataSource:nil];
    [_tableView setDelegate:nil];
    
    [self setTableView:nil];
    [self setViewModel:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
