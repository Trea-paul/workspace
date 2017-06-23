//
//  UIButton+Layout.h
//  CYSDemo
//
//  Created by Paul on 2017/5/11.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JYButtonLayoutStyle) {
    JYButtonLayoutStyleTop,                          // image在上，label在下
    JYButtonLayoutStyleLeft,                         // image在左，label在右
    JYButtonLayoutStyleBottom,                       // image在下，label在上
    JYButtonLayoutStyleRight                         // image在右，label在左
};

@interface UIButton (Layout)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  注意：调用该布局需要在Buttton Frame确认之后，否则imageView和titleLabel 为zero
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)buttonLayoutStyle:(JYButtonLayoutStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
