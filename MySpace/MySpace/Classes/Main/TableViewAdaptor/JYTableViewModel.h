//
//  JYTableViewModel.h
//  CYSDemo
//
//  Created by Paul on 2017/5/5.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYTableViewCellModel;

// 数据处理
@interface JYTableViewModel : NSObject


@property (nonatomic, strong) id model;


@property (nonatomic, strong) NSMutableArray *sectionModels;


@property (nonatomic, assign) CGFloat headerHeight;


- (NSInteger)numberOfSections;
- (NSUInteger)numberOfRowsInSection:(NSInteger)section;

- (JYTableViewCellModel *)cellModelForRowAtIndexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithStyle:(UITableViewStyle)style sectionModelsBlock:(void (^)(NSMutableArray *sectionModels))sectionModelsBlock;


- (void)iterateCellClassBlock:(void (^)(Class cellClass, NSString *cellReuseIdentifier))cellClassBlock;




@end

#pragma mark -
#pragma mark JYTableViewSectionModel

@interface JYTableViewSectionModel : NSObject

@property (nonatomic, strong) NSMutableArray *cellModels;

@property (nonatomic, assign) CGFloat sectionHeaderHeight;

@property (nonatomic, readonly) UITableViewStyle tableViewStyle;

@property (nonatomic, strong) id dataModel;

// 标识符
@property (nonatomic, copy) NSString *mark;

- (JYTableViewCellModel *)cellModelAtRow:(NSInteger)row;

- (instancetype)initWithCellModelsBlock:(void (^)(NSMutableArray *cellModels))cellModelsBlock;



@end
