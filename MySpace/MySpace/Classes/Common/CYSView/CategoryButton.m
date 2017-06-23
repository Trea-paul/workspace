//
//  CategoryButton.m
//  CYSDemo
//
//  Created by Paul on 2017/6/16.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CategoryButton.h"

@implementation CategoryButton

- (UIButton *)setupButtonWithTitle:(NSString *)title titleId:(NSString *)titleId
{
    CategoryButton *button = [CategoryButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:COLOR_STYLE_13 forState:UIControlStateNormal];
    [button setTitleColor:COLOR_STYLE_6 forState:UIControlStateSelected];
    
    button.titleLabel.font = FONT_SIZE(16);
    
//    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
