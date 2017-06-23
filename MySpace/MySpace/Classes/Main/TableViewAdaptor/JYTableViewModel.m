//
//  JYTableViewModel.m
//  CYSDemo
//
//  Created by Paul on 2017/5/5.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYTableViewModel.h"
#import "JYTableViewCellModel.h"

@implementation JYTableViewModel

- (NSMutableArray *)sectionModels
{
    if (!_sectionModels) {
        _sectionModels = [NSMutableArray array];
    }
    return _sectionModels;
}

- (NSInteger)numberOfSections
{
    return self.sectionModels.count;
}

- (NSUInteger)numberOfRowsInSection:(NSInteger)section
{
    return [self sectionModelForSection:section].cellModels.count;
}


- (JYTableViewCellModel *)cellModelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self sectionModelForSection:indexPath.section] cellModelAtRow:indexPath.row];
}

- (JYTableViewSectionModel *)sectionModelForSection:(NSInteger)section
{
    return self.sectionModels[section];
}


- (instancetype)initWithStyle:(UITableViewStyle)style sectionModelsBlock:(void (^)(NSMutableArray *sectionModels))sectionModelsBlock
{
    self = [self init];
    if (self)
    {
//        self.tableViewStyle = style;
        [self setupTableViewModelWithAddingSectionModelBlock:sectionModelsBlock];
    }
    return self;
}

- (void)setupTableViewModelWithAddingSectionModelBlock:(void (^)(NSMutableArray *sectionModels))addingBlock
{
    if (addingBlock)
    {
        addingBlock(self.sectionModels);
    }
}

- (void)iterateCellClassBlock:(void (^)(Class cellClass, NSString *cellReuseIdentifier))cellClassBlock
{
    for (JYTableViewSectionModel *sectionModel in self.sectionModels)
    {
        for (JYTableViewCellModel *cellModel in sectionModel.cellModels)
        {
            if (cellClassBlock)
            {
                cellClassBlock(cellModel.cellClass, NSStringFromClass(cellModel.cellClass));
            }
        }
    }
}



@end







@implementation JYTableViewSectionModel

- (NSMutableArray *)cellModels
{
    if (!_cellModels) {
        _cellModels = [NSMutableArray array];
    }
    return _cellModels;
}

- (instancetype)initWithCellModelsBlock:(void (^)(NSMutableArray *cellModels))cellModelsBlock
{
    self = [self init];
    if (self)
    {
        [self setupSectionModelWithAddingCellModelBlock:cellModelsBlock];
    }
    return self;
}

- (void)setupSectionModelWithAddingCellModelBlock:(void (^)(NSMutableArray *cellModels))addingBlock
{
    if (addingBlock)
    {
        addingBlock(self.cellModels);
    }
}



- (JYTableViewCellModel *)cellModelAtRow:(NSInteger)row
{
    if (self.cellModels.count <= row)
    {
        return nil;
    }
    
    return self.cellModels[row];
}

@end
