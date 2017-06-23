//
//  BannerCollectionViewCell.h
//  CYSDemo
//
//  Created by Paul on 2017/5/10.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerModel;
@interface BannerCollectionViewCell : UICollectionViewCell

@property(nonatomic, copy) NSString *url;

@property (nonatomic, strong) BannerModel *model;


@end
