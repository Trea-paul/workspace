//
//  BannerCollectionView.m
//  CYSDemo
//
//  Created by Paul on 2017/5/10.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "BannerCollectionView.h"
#import "BannerCollectionViewCell.h"
#import "BannerCollectionViewLayout.h"
#import "HomeModel.h"

NSString * const kCollectionViewCellId = @"BannerCollectionViewCellId";

@interface BannerCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger currentIndex;



@end

@implementation BannerCollectionView {
//    NSArray <NSString *>   *self.urls;
    UIScrollView        *_scrollV;
    NSTimer             *_timer;
}

- (instancetype)initBannerCollectionView
{
    self = [super initWithFrame:CGRectZero collectionViewLayout:[[BannerCollectionViewLayout alloc] init]];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[BannerCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellId];
        
    }
    return self;
}

- (void)updateBannerView
{
    self.currentIndex = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath * path = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
        [self scrollToItemAtIndexPath:path atScrollPosition:0 animated:NO];
    });
    [self addTimer];
    
    [self reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}



- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)startTimer {
    [self addTimer];
}

- (void)addTimer {
    if (!_timer && self.banners.count > 1) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)nextPage {

    NSIndexPath *currentIndexPath = [[self indexPathsForVisibleItems] lastObject];
    
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:200/2];
    [self scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = currentIndexPathReset.item +1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.banners.count) {
        nextItem = 0;
        nextSection ++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    
    
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.banners.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 200;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BannerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId forIndexPath:indexPath];
    
//    cell.url = self.urls[indexPath.item];
    cell.model = self.banners[indexPath.item];
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5) % self.banners.count;
//        self.pageControl.currentPage =page;
    
    
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(bannerCollectionView:WithCurrentPage:)])
    {
        [self.pageDelegate bannerCollectionView:nil WithCurrentPage:page];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BannerModel *model = self.banners[indexPath.item];
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(bannerCollectionView:cellModel:didSelectItemAtIndexPath:)]) {
        [self.pageDelegate bannerCollectionView:collectionView cellModel:model didSelectItemAtIndexPath:indexPath];
    }
}


- (void)dealloc
{
    [self stopTimer];
}



@end
