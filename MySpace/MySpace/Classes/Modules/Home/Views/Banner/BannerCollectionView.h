//
//  BannerCollectionView.h
//  CYSDemo
//
//  Created by Paul on 2017/5/10.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerCollectionViewDelegate <NSObject>

- (void)bannerCollectionView :(UICollectionView *)collectionView WithCurrentPage:(NSInteger)currentPage;

- (void)bannerCollectionView:(UICollectionView *)collectionView cellModel:(id)model didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BannerCollectionView : UICollectionView

@property (nonatomic, strong) NSArray *banners;

@property (nonatomic, strong) NSArray <NSString *> *urls;
- (instancetype)initBannerCollectionView;

- (void)updateBannerView;

@property (nonatomic, weak) id <BannerCollectionViewDelegate>pageDelegate;

@end
