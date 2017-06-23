//
//  JYNewsTableHeaderView.h
//  CYSDemo
//
//  Created by Paul on 2017/5/8.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYNewsTableHeaderViewDelegate <NSObject>

@optional
- (void)didTouchUpInsideHeaderViewButton:(UIButton *)button buttonUrl:(NSString *)buttonUrl;

- (void)didTouchUpScrollViewSubTitle:(NSString *)title titleId:(NSString *)titleId;

@end

static NSString *const liveHeaderViewIdentifier = @"liveHeaderViewIdentifier";
static NSString *const newsHeaderViewIdentifier = @"newsHeaderViewIdentifier";

@interface JYNewsTableHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSNumber *showMoreButton;
@property (nonatomic, copy)   NSString *moreButtonUrl;

- (instancetype)initWithTitle:(NSString *)title reuseIdentifier:(NSString *)reuseIdentifier;

- (instancetype)initWithTitleArray:(NSArray *)titleArray reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, weak) id<JYNewsTableHeaderViewDelegate>delegate;

@end
