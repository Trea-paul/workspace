//
//  JYTableViewCell.h
//  CYSDemo
//
//  Created by Paul on 2017/5/5.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYTableViewCellModel.h"

@class JYTableViewCell;
@protocol JYTableViewCellDelegate <NSObject>

@optional
- (void)didTouchUpInsideCell:(JYTableViewCell *)cell clickButton:(UIButton *)button;



@end

@interface JYTableViewCell : UITableViewCell


/** 代理*/
@property (nonatomic, weak) id <JYTableViewCellDelegate> delegate;

@property (nonatomic, strong) JYTableViewCellModel *cellModel;


- (void)setup;
- (void)updateCellFrame;
- (void)setCellModel;

// 根据模型计算高度
+ (CGFloat)heightForRowWithModel:(id)model;

// 返回指定高度
+ (CGFloat)cellHeightForCellModel:(JYTableViewCellModel *)cellModel;

- (void)didTouchUpInsideButton:(UIButton *)button;


@end


// 通用列表（以下控件可以满足需求时使用）
@interface JYTableViewListCell : JYTableViewCell


@property (nonatomic, strong) JYTableViewListCellModel *cellModel;


// UILabel
@property (nonatomic, strong) UILabel *topLeftLb;
@property (nonatomic, strong) UILabel *topCenterLb;
@property (nonatomic, strong) UILabel *topRightLb;
@property (nonatomic, strong) UILabel *centerLeftLb;
@property (nonatomic, strong) UILabel *centerLb;
@property (nonatomic, strong) UILabel *centerRightLb;
@property (nonatomic, strong) UILabel *bottomLeftLb;
@property (nonatomic, strong) UILabel *bottomCenterLb;
@property (nonatomic, strong) UILabel *bottomRightLb;

// UIButton
@property (nonatomic, strong) UIButton *topLeftBtn;
@property (nonatomic, strong) UIButton *topCenterBtn;
@property (nonatomic, strong) UIButton *topRightBtn;
@property (nonatomic, strong) UIButton *centerLeftBtn;
@property (nonatomic, strong) UIButton *centerBtn;
@property (nonatomic, strong) UIButton *centerRightBtn;
@property (nonatomic, strong) UIButton *bottomLeftBtn;
@property (nonatomic, strong) UIButton *bottomCenterBtn;
@property (nonatomic, strong) UIButton *bottomRightBtn;

// UIImageView
@property (nonatomic, strong) UIImageView *topLeftImg;
@property (nonatomic, strong) UIImageView *topRightImg;
//@property (nonatomic, strong) UIImageView *centerLeftImg;
//@property (nonatomic, strong) UIImageView *centerRightImg;
@property (nonatomic, strong) UIImageView *bottomLeftImg;
@property (nonatomic, strong) UIImageView *bottomRightImg;




@end
