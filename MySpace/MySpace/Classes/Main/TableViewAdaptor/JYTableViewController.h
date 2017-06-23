//
//  JYTableViewController.h
//  CYSDemo
//
//  Created by Paul on 2017/5/5.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYTableViewModel, JYTableViewCellModel;

@protocol JYTableViewControllerDelegate <NSObject>

@optional

- (CGFloat)tableViewModel:(JYTableViewModel *)tableViewModel heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableViewModel:(JYTableViewModel *)tableViewModel heightForFooterInSection:(NSInteger)section;


- (UIView *)tableView:(UITableView *)tableView tableViewModel:(JYTableViewModel *)tableViewModel viewForHeaderInSection:(NSInteger)section;

- (UIView *)tableView:(UITableView *)tableView tableViewModel:(JYTableViewModel *)tableViewModel viewForFooterInSection:(NSInteger)section;


/**
 代理方法： 响应TableView点击事件

 @param tableViewModel 当前的ViewModel
 @param cellModel 当前Cell的CellModel
 @param indexPath 点击位置
 */
- (void)tableViewModel:(JYTableViewModel *)tableViewModel didSelectCellModel:(JYTableViewCellModel *)cellModel atIndexPath:(NSIndexPath *)indexPath;


/**
 代理方法：响应一行Cell中的按钮的点击事件

 @param tableViewModel 当前的ViewModel
 @param button 当前点击的Button
 @param cellModel 当前Cell的CellModel
 @param indexPath 点击位置
 */
- (void)tableViewModel:(JYTableViewModel *)tableViewModel didTouchUpInsideButton:(UIButton *)button cellModel:(JYTableViewCellModel *)cellModel atIndexPath:(NSIndexPath *)indexPath;


/**
 tableView的scrollView代理方法

 @param tableView 当前tableView
 @param scrollView 当前滚动的scrollView
 */
- (void)tablevView:(UITableView *)tableView scrollViewDidScroll:(UIScrollView *)scrollView;


@end

@interface JYTableViewController : UIViewController


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JYTableViewModel *viewModel;

- (instancetype)initWithStyle:(UITableViewStyle)style;


@property (nonatomic, weak) id<JYTableViewControllerDelegate> delegate;

@end
