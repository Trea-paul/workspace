//
//  JYHistoryViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/6/21.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYHistoryViewController.h"
#import "JHChart.h"
#import "JHLineChart.h"

@interface JYHistoryViewController ()

@end

@implementation JYHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史记录";
    
    [self showFirstQuardrant];
}

//第一象限折线图
- (void)showFirstQuardrant{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH, 250)];
    scrollView.showsHorizontalScrollIndicator = NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 160, 20)];
    titleLabel.text = @"血压曲线图(mmHg)";
    titleLabel.font = FONT_SIZE(17);
    [scrollView addSubview:titleLabel];
    
    [self.view addSubview:scrollView];
    
    
    
    /*     Create object        */
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH * 2, 200) andLineChartType:JHChartLineValueNotForEveryX];
    
    /* The scale value of the X axis can be passed into the NSString or NSNumber type and the data structure changes with the change of the line chart type. The details look at the document or other quadrant X axis data source sample.*/
    
    lineChart.xLineDataArr = @[@"一月份",@"二月份",@"三月份",@"四月份",@"五月份",@"六月份",@"七月份",@"八月份",@"六月份",@"七月份",@"八月份",@"八月份",@"八月份",@"八月份",@"八月份",@"八月份"];
    lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    /* The different types of the broken line chart, according to the quadrant division, different quadrant correspond to different X axis scale data source and different value data source. */
    
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    
    lineChart.valueArr = @[@[@"1",@"12",@"1",@6,@4,@9,@6,@7,@6,@4,@9,@6,@7],@[@"3",@"1",@"2",@16,@2,@3,@25,@10,@6,@4,@9,@6,@7]];
    lineChart.showYLevelLine = YES;
    lineChart.showYLine = NO;
    lineChart.showValueLeadingLine = NO;
    lineChart.valueFontSize = 9.0;
    lineChart.backgroundColor = [UIColor whiteColor];
    /* Line Chart colors */
    lineChart.valueLineColorArr =@[ [UIColor greenColor], [UIColor orangeColor]];
    /* Colors for every line chart*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    /* color for XY axis */
    lineChart.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    lineChart.positionLineColorArr = @[[UIColor blueColor],[UIColor greenColor]];
    /*        Set whether to fill the content, the default is False         */
    lineChart.contentFill = NO;
    /*        Set whether the curve path         */
    lineChart.pathCurve = NO;
    /*        Set fill color array         */
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.468],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.468]];
    
    
    
    scrollView.contentSize = CGSizeMake(lineChart.frame.size.width, lineChart.frame.size.height);
    [scrollView addSubview:lineChart];
    /*       Start animation        */
    [lineChart showAnimation];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
