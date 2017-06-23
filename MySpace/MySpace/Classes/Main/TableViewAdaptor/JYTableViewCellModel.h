//
//  JYTableViewCellModel.h
//  CYSDemo
//
//  Created by Paul on 2017/5/5.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYTableViewCellModel : NSObject

@property (nonatomic, strong) Class cellClass;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *displayValue;
@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, strong) id model;

@property (nonatomic, copy) NSString *linkUrl;  

// the height of the row
@property (nonatomic, assign) CGFloat rowHeight;

// 分割线位置
@property (nonatomic, assign) UIEdgeInsets separatorInset;



@end

@interface JYTableViewListCellModel : JYTableViewCellModel

// Label
@property (nonatomic, copy) NSString *topLeftLbTitle;
@property (nonatomic, copy) NSString *topCenterLbTitle;
@property (nonatomic, copy) NSString *topRightLbTitle;

@property (nonatomic, copy) NSString *centerLeftLbTitle;
@property (nonatomic, copy) NSString *centerLbTitle;
@property (nonatomic, copy) NSString *centerRightLbTitle;

@property (nonatomic, copy) NSString *bottomLeftLbTitle;
@property (nonatomic, copy) NSString *bottomCenterLbTitle;
@property (nonatomic, copy) NSString *bottomRightLbTitle;

// button
@property (nonatomic, copy) NSString *topLeftBtnTitle;
@property (nonatomic, copy) NSString *topCenterBtnTitle;
@property (nonatomic, copy) NSString *topRightBtnTitle;

@property (nonatomic, copy) NSString *centerLeftBtnTitle;
@property (nonatomic, copy) NSString *centerBtnTitle;
@property (nonatomic, copy) NSString *centerRightBtnTitle;

@property (nonatomic, copy) NSString *bottomLeftBtnTitle;
@property (nonatomic, copy) NSString *bottomCenterBtnTitle;
@property (nonatomic, copy) NSString *bottomRightBtnTitle;



@end

@interface JYTableViewAttributeListCellModel : JYTableViewListCellModel

@property (nonatomic, copy) NSAttributedString *attributeString;



@end
