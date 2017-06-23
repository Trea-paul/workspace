//
//  JYSubTitleScrollView.h
//  CYSDemo
//
//  Created by Paul on 2017/5/10.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYSJYSubTitleScrollViewDelegate <NSObject>

- (void)didTouchUpInsideSubTitle:(NSString *)title categoryId:(NSString *)categoryId;

@end

@interface JYSubTitleScrollView : UIScrollView


/**
 *  实现标题的滚动
 *  尺寸自适应
 *
 */

// 是否固定尺寸 标题自适应 标题间距
//

- (instancetype)initWithSubTitles:(NSArray *)subTitle;
- (instancetype)initWithSubTitles:(NSArray *)subTitle scrollWidth:(CGFloat)width;

@property (nonatomic, weak) id<JYSJYSubTitleScrollViewDelegate>clickDelegate;

@end
