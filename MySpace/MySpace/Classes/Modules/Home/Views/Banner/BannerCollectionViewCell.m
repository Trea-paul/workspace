//
//  BannerCollectionViewCell.m
//  CYSDemo
//
//  Created by Paul on 2017/5/10.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "BannerCollectionViewCell.h"
#import "HomeModel.h"

@implementation BannerCollectionViewCell
{
    UIImageView * _imageView;
}

- (void)setUrl:(NSString *)url{
    
    NSURL * dataUrl = [NSURL URLWithString:url];
    [_imageView sd_setImageWithURL:dataUrl placeholderImage:[UIImage imageNamed:@"pageOther.png"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bigBig:) name:@"zys" object:nil];
}

- (void)setModel:(BannerModel *)model
{
    NSURL * dataUrl = [NSURL URLWithString:model.image_url];
    [_imageView sd_setImageWithURL:dataUrl placeholderImage:[UIImage imageNamed:@"pageOther.png"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bigBig:) name:@"zys" object:nil];
}


- (void)bigBig:(NSNotification*)info {
    NSDictionary * dict = (NSDictionary *)info.userInfo;
    NSString * dic = dict[@"offset"];
    CGFloat off = dic.floatValue;
    //        NSLog(@"%f",off);
    CGRect newFrame = self.frame;
    newFrame.size = CGSizeMake(375, 200 - off- 1);
    _imageView.frame = newFrame;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}


@end
