//
//  JYBannerTableViewCell.m
//  CYSDemo
//
//  Created by Paul on 2017/5/9.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYBannerTableViewCell.h"
#import "BannerCollectionView.h"


#define kBannerCellID @"bannerCellID"

@interface JYBannerTableViewCell ()<BannerCollectionViewDelegate>

@property (nonatomic, strong) BannerCollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation JYBannerTableViewCell

+ (CGFloat)cellHeightForCellModel:(JYTableViewCellModel *)cellModel
{
    return 200;
}

- (BannerCollectionView *)collectionView
{
    if (!_collectionView) {

        _collectionView = [[BannerCollectionView alloc] initBannerCollectionView];
        _collectionView.pageDelegate = self;
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        
    }
    
    return _pageControl;
}

- (void)setup
{
    self.collectionView.hidden = NO;
    
    [self.contentView addSubview:self.pageControl];
    
    WeakSelf(self);
    [RACObserve(self, cellModel.model) subscribeNext:^(NSArray *bannerModels) {
        
        if (!bannerModels.count) return;
        
        weakself.pageControl.numberOfPages = bannerModels.count;
        
        weakself.collectionView.banners = bannerModels;
        [weakself.collectionView updateBannerView];
    }];
    

    [self.contentView bringSubviewToFront:self.pageControl];
}

- (void)updateCellFrame
{
    WeakSelf(self);
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakself.contentView);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.contentView.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 20));
        make.centerX.equalTo(weakself.contentView.mas_centerX);
    }];
}

- (void)bannerCollectionView:(UICollectionView *)collectionView WithCurrentPage:(NSInteger)currentPage
{
//    DLog(@"currentPage %ld", currentPage);
    self.pageControl.currentPage = currentPage;
}

- (void)bannerCollectionView:(UICollectionView *)collectionView cellModel:(id)model didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"didSelectItem");
}





@end
