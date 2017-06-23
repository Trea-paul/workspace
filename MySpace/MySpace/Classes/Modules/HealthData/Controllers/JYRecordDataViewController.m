//
//  JYRecordDataViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/6/12.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYRecordDataViewController.h"
#import "JYRemarkViewController.h"
#import "RulerTableViewListCell.h"


@interface JYRecordDataViewController ()<JYTableViewControllerDelegate>

@property (nonatomic, strong) JYTableViewController *tableViewController;
@property (nonatomic, strong) JYTableViewModel *viewModel;

@property (nonatomic, strong) UIButton *finishButton;

@end

@implementation JYRecordDataViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"数据记录";
    
    [self setupUI];
}

- (void)setupUI
{
    self.tableViewController.view.frame = CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREENH_HEIGHT - 64);
    
    self.tableViewController.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    [self updateTableView];
    
}






#pragma mark - Lazy Load

- (JYTableViewController *)tableViewController
{
    if (!_tableViewController) {
        _tableViewController = [[JYTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _tableViewController.view.userInteractionEnabled = YES;
        _tableViewController.delegate = self;
        _tableViewController.automaticallyAdjustsScrollViewInsets = NO;
        _tableViewController.tableView.backgroundView.backgroundColor = HexRGB(0xFFFFF0);
        [self addChildViewController:_tableViewController];
        [self.view addSubview:_tableViewController.view];
    }
    return _tableViewController;
}

- (UIButton *)finishButton
{
    if (!_finishButton) {
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton setBackgroundImage:[InterfaceUtils createImageWithColor:COLOR_STYLE_2] forState:UIControlStateNormal];
        [_finishButton setBackgroundImage:[InterfaceUtils createImageWithColor:COLOR_STYLE_11] forState:UIControlStateHighlighted];
        _finishButton.titleLabel.font = FONT_SIZE(17);
        _finishButton.layer.cornerRadius = 23.f;
        _finishButton.clipsToBounds = YES;
        [_finishButton addTarget:self action:@selector(didTouchUpInsideFinishButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _finishButton;
}

#pragma mark - UpdateTableView

- (void)updateTableView
{
    self.viewModel = [[JYTableViewModel alloc] initWithStyle:UITableViewStylePlain sectionModelsBlock:^(NSMutableArray *sectionModels) {
       
        JYTableViewSectionModel *sectionModel = [[JYTableViewSectionModel alloc] initWithCellModelsBlock:^(NSMutableArray *cellModels) {
            JYTableViewListCellModel *penCellModel = [JYTableViewListCellModel new];
            penCellModel.cellClass = [OneImgTwoLbNextTableListCell class];
            penCellModel.key = @"recordDate";
            
            penCellModel.topLeftLbTitle = @"icon_set_time";
            penCellModel.centerLeftLbTitle = @"测量数据";
            penCellModel.centerLbTitle = @"2017年6月19日 上午10:29";
            penCellModel.displayValue = @"2017年6月19日 10:29";
            penCellModel.value = @"2017-06-19 10:29";
            
            [cellModels addObject:penCellModel];
            
            JYTableViewListCellModel *timeCellModel = [JYTableViewListCellModel new];
            timeCellModel.cellClass = [OneImgTwoLbNextTableListCell class];
            timeCellModel.key = @"remark";
            
            timeCellModel.topLeftLbTitle = @"icon_set_pen";
            timeCellModel.centerLeftLbTitle = @"备注";
            timeCellModel.centerLbTitle = @"暂无备注";
            timeCellModel.value = @"";
            timeCellModel.displayValue = @"";
            
            [cellModels addObject:timeCellModel];
            
            // 收缩压
            JYTableViewListCellModel *systolicCellModel = [JYTableViewListCellModel new];
            systolicCellModel.cellClass = [RulerTableViewListCell class];
            systolicCellModel.key = @"systolic";
            
            systolicCellModel.topLeftLbTitle = @"收缩压(高压)mmHg";
            systolicCellModel.centerLbTitle = @"100";
            // @"最大值,最小值,平均值,当前值"
            systolicCellModel.centerRightLbTitle = @"300,10,1,100";
            systolicCellModel.value = @"";
            systolicCellModel.displayValue = @"true";
            
            [cellModels addObject:systolicCellModel];
            
            // 舒张压
            JYTableViewListCellModel *diastolicCellModel = [JYTableViewListCellModel new];
            diastolicCellModel.cellClass = [RulerTableViewListCell class];
            diastolicCellModel.key = @"diastolic";
            
            diastolicCellModel.topLeftLbTitle = @"舒张压(低压)mmHg";
            diastolicCellModel.centerLbTitle = @"80";
            // @"最大值,最小值,平均值,当前值"
            diastolicCellModel.centerRightLbTitle = @"300,10,1,80";
            diastolicCellModel.value = @"";
            diastolicCellModel.displayValue = @"true";
            
            [cellModels addObject:diastolicCellModel];
            
            // 心率范围
            JYTableViewListCellModel *heartRateCellModel = [JYTableViewListCellModel new];
            heartRateCellModel.cellClass = [RulerTableViewListCell class];
            heartRateCellModel.key = @"heartRate";
            
            heartRateCellModel.topLeftLbTitle = @"心率范围bmp";
            heartRateCellModel.centerLbTitle = @"80";
            // @"最大值,最小值,平均值,当前值"
            heartRateCellModel.centerRightLbTitle = @"200,30,1,80";
            heartRateCellModel.topRightBtnTitle = @"是否记录";
            heartRateCellModel.value = @"";
            heartRateCellModel.displayValue = @"true";
            
            [cellModels addObject:heartRateCellModel];
            
            
        }];
        
        [sectionModels addObject:sectionModel];
    }];
    
    self.tableViewController.viewModel = self.viewModel;
    
}

#pragma mark - TableView DataSource

- (CGFloat)tableViewModel:(JYTableViewModel *)tableViewModel heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

- (CGFloat)tableViewModel:(JYTableViewModel *)tableViewModel heightForFooterInSection:(NSInteger)section
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView tableViewModel:(JYTableViewModel *)tableViewModel viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"recordFooterView"];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"recordFooterView"];
        
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55);
        [footerView addSubview:self.finishButton];
        [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(45);
        }];
    }
    
    footerView.contentView.backgroundColor = COLOR_STYLE_1;
    
    return footerView;
}





#pragma mark - TableView Delegate

- (void)tableViewModel:(JYTableViewModel *)tableViewModel didSelectCellModel:(JYTableViewListCellModel *)cellModel atIndexPath:(NSIndexPath *)indexPath
{
    if ([cellModel.key isEqualToString:@"recordDate"]) {
        
        DateTimePickerView *picker = [DateTimePickerView sharedDateTimePickerView];
        picker.datePickerMode = UIDatePickerModeDateAndTime;
        picker.pickerTitle = @"选择测量时间";
        picker.cellModel = cellModel;
        
        [picker show];
        
    } else if ([cellModel.key isEqualToString:@"remark"]) {
        
        JYRemarkViewController *remarkVC = [[JYRemarkViewController alloc] init];
        remarkVC.cellModel = cellModel;
        [self.navigationController pushViewController:remarkVC animated:YES];
        
        
    }
    
    
    
}

- (void)tableViewModel:(JYTableViewModel *)tableViewModel didTouchUpInsideButton:(UIButton *)button cellModel:(JYTableViewCellModel *)cellModel atIndexPath:(NSIndexPath *)indexPath
{
    if ([cellModel.cellClass isSubclassOfClass:[RulerTableViewListCell class]]) {
        
        button.selected = !button.selected;
        
        cellModel.displayValue = button.selected ? @"true" : @"false";
        
        cellModel.rowHeight = button.selected ? 150 : 80;
        
        [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}



#pragma mark - Action


- (void)didTouchUpInsideFinishButton:(UIButton *)button
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
//    [HttpRequestManager POST:@"genericapi/private/healthcenter/healthdata/bloodpressure" parameters:nil success:^(id response, BOOL success) {
// 
//    } failure:^(NSError *error) {
// 
//    }];
    
    
    
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
