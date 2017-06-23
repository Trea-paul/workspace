//
//  JYHealthDataViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/5/2.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYHealthDataViewController.h"
#import "JYNewsListViewController.h"
#import "JYRecordDataViewController.h"
#import "JYHistoryViewController.h"
#import "JYHardwareViewController.h"
#import "JYRemindViewController.h"

#import "HeathDataRecordBGView.h"


@interface JYHealthDataViewController ()

@property (nonatomic, strong) HeathDataRecordBGView *recordView;
@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UILabel *recordTime;
@property (nonatomic, strong) UILabel *recordData;
@property (nonatomic, strong) UILabel *recordStatus;

//@property (nonatomic, strong) UILabel *recordTime;


@end

@implementation JYHealthDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_STYLE_1;;
    
    self.title = @"健康数据";
    
    [self setupUI];
}

- (void)setupUI
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
    [self setupRecordView];
    
    [self setupMoreView];
    
}

- (void)rightItemClick
{
    JYNewsListViewController *newsVC = [[JYNewsListViewController alloc] init];
    newsVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:newsVC animated:YES];
}



- (void)setupRecordView
{
    self.recordView = [[HeathDataRecordBGView alloc] init];
    self.recordView.backgroundColor = COLOR_STYLE_8;
    self.recordView.frame = CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREENH_HEIGHT * 0.6);
    self.recordView.clipsToBounds = YES;
    [self.view addSubview:self.recordView];
    
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPA_STYLE_2, 40, SCREEN_WIDTH - 2 * SPA_STYLE_2, 20)];
    startLabel.text = @"开始记录您的血压";
    startLabel.textColor = COLOR_STYLE_6;
    startLabel.font = FONT_SIZE(20);
    startLabel.textAlignment = NSTextAlignmentCenter;
    [self.recordView addSubview:startLabel];
    
    
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordBtn setImage:ImageNamed(@"icon_index_add") forState:UIControlStateNormal];
    [self.recordBtn addTarget:self action:@selector(startRecordData:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordView addSubview:self.recordBtn];
    
    self.recordTime = [[UILabel alloc] init];
    self.recordTime.text = @"2017年4月8日 下午18:30";
    self.recordTime.textColor = COLOR_STYLE_5;
    self.recordTime.font = FONT_SIZE(14);
    self.recordTime.textAlignment = NSTextAlignmentCenter;
    [self.recordView addSubview:self.recordTime];
    
    self.recordData = [[UILabel alloc] init];
    self.recordData.text = @"血压 110/86 mmHg\n心率 78 bmp";
    self.recordData.textColor = COLOR_STYLE_2;
    self.recordData.font = FONT_SIZE(16);
    self.recordData.numberOfLines = 0;
    self.recordData.textAlignment = NSTextAlignmentCenter;
    [self.recordView addSubview:self.recordData];
    
    self.recordStatus = [[UILabel alloc] init];
    self.recordStatus.text = @"血压和心率正常";
    self.recordStatus.textColor = COLOR_STYLE_6;
    self.recordStatus.font = FONT_SIZE(20);
    self.recordStatus.textAlignment = NSTextAlignmentCenter;
    [self.recordView addSubview:self.recordStatus];
    
    
    WeakSelf(self);
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(startLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(startLabel);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.recordTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakself.recordBtn.mas_bottom).offset(40);
        make.centerX.mas_equalTo(weakself.recordBtn.center.x);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 2 * SPA_STYLE_2, 14));
    }];
    
    [self.recordData mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(weakself.recordTime.mas_bottom).offset(20);
        make.centerX.mas_equalTo(weakself.recordBtn.center.x);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 2 * SPA_STYLE_2, 50));
        make.width.mas_equalTo(SCREEN_WIDTH - 2 * SPA_STYLE_2);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
    
    [self.recordStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakself.recordData.mas_bottom).offset(20);
        make.centerX.mas_equalTo(weakself.recordBtn.center.x);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 2 * SPA_STYLE_2, 20));
    }];
    
}


- (void)setupMoreView
{
    UIView *moreView = [[UIView alloc] init];
    moreView.backgroundColor = COLOR_STYLE_8;
    
    [self.view addSubview:moreView];
    
    WeakSelf(self);
    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(weakself.recordView.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    
    UIButton *historyBtn = [self setupButtonWithImage:@"icon_index_history" title:@"历史记录" targetSEL:@selector(didTouchUpMoreButton:)];
    historyBtn.tag = 101;
    [moreView addSubview:historyBtn];
    
    UIButton *hardwareBtn = [self setupButtonWithImage:@"icon_index_hardware" title:@"智能硬件" targetSEL:@selector(didTouchUpMoreButton:)];
    hardwareBtn.tag = 102;
    [moreView addSubview:hardwareBtn];
    
    UIButton *remindBtn = [self setupButtonWithImage:@"icon_index_clock" title:@"提醒设置" targetSEL:@selector(didTouchUpMoreButton:)];
    remindBtn.tag = 103;
    [moreView addSubview:remindBtn];
    
    
    [historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(64, 80));
    }];
    
    [hardwareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(moreView);
        make.size.mas_equalTo(CGSizeMake(64, 80));
    }];
    
    [remindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(64, 80));
    }];
    
    [historyBtn buttonLayoutStyle:JYButtonLayoutStyleTop imageTitleSpace:5];
    [hardwareBtn buttonLayoutStyle:JYButtonLayoutStyleTop imageTitleSpace:5];
    [remindBtn buttonLayoutStyle:JYButtonLayoutStyleTop imageTitleSpace:5];
    
}

- (UIButton *)setupButtonWithImage:(NSString *)image title:(NSString *)title targetSEL:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:ImageNamed(image) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:COLOR_STYLE_6 forState:UIControlStateNormal];
    [button setTitleColor:COLOR_STYLE_13 forState:UIControlStateHighlighted];
    button.titleLabel.font = FONT_SIZE(14);
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)startRecordData:(UIButton *)button
{
    JYRecordDataViewController *recordVC = [[JYRecordDataViewController alloc] init];
    recordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recordVC animated:YES];
}


- (void)didTouchUpMoreButton:(UIButton *)button
{
    if (button.tag == 101) {
        
        // 历史记录
        JYHistoryViewController *historyVC = [[JYHistoryViewController alloc] init];
        historyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:historyVC animated:YES];
    }
    else if (button.tag == 102) {
        
        // 智能硬件
        JYHardwareViewController *hardwareVC = [[JYHardwareViewController alloc] init];
        hardwareVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hardwareVC animated:YES];
    }
    else if (button.tag == 103) {
        
        // 提醒设置
        JYRemindViewController *remindVC = [[JYRemindViewController alloc] init];
        remindVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:remindVC animated:YES];
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
