//
//  JYTableViewCell.m
//  CYSDemo
//
//  Created by Paul on 2017/5/5.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYTableViewCell.h"

@interface JYTableViewCell ()

@end

@implementation JYTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    [self setup];
    
    return self;
}


- (void)setCellModel:(JYTableViewCellModel *)cellModel
{
    if (cellModel) {
        _cellModel = cellModel;
        [self setCellModel];
        [self layoutIfNeeded];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateCellFrame];
}

- (void)setup
{
    // SubClass overwrite
}


- (void)updateCellFrame
{
    // SubClass overwrite
}

- (void)setCellModel
{
    // SubClass overwrite
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


// 计算高度
+ (CGFloat)heightForRowWithModel:(NSDictionary *)model
{
    CGFloat Height = 0;
    
    NSString *title = [model objectForKey:@"title"];
    NSString *subTitle = [model objectForKey:@"value"];
    
    if (title.length)
    {
        Height += 40;
    }
    
    if (subTitle.length) {
        Height += 20;
    }
    
    
    return Height;
}

+ (CGFloat)cellHeightForCellModel:(JYTableViewCellModel *)cellModel
{
    return 0;
}



// 控件初始化
#pragma mark - Lazy Initialization
- (UILabel *)initializedLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:label];
    
    return label;
}

- (UIImageView *)initializedImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:imageView];
    
    return imageView;
}

- (UIButton *)initializedButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:button];
    
    return button;
}

- (UISwitch *)initializedSwitch
{
    UISwitch * switchBtn = [[UISwitch alloc] init];
    [switchBtn addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventValueChanged];
    
    [self.contentView addSubview:switchBtn];
    
    return switchBtn;
}



// 响应按钮的点击事件，并回调给控制器
- (void)didTouchUpInsideButton:(UIButton *)button
{
    JYTableViewCell *cell = self;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchUpInsideCell:clickButton:)]) {
        [self.delegate didTouchUpInsideCell:cell clickButton:button];
    }
    
    
}

- (void)dealloc
{
    [self setCellModel:nil];
//    [self setDelegate:nil];
}


@end


#pragma mark - JYTableViewListCell

@implementation JYTableViewListCell

@dynamic cellModel;

//@dynamic cellModel;
//
//- (JYTableViewListCellModel *)cellModel
//{
//    
//    return cellModel;
//}
//
//- (void)setCellModel:(JYTableViewListCellModel *)cellModel
//{
//    if (_cellModel != cellModel)
//    {
//        _cellModel = cellModel;
//    }
//}

- (void)setCellModel
{
    _topLeftLb.text      = self.cellModel.topLeftLbTitle;
    _topCenterLb.text    = self.cellModel.topCenterLbTitle;
    _topRightLb.text     = self.cellModel.topRightLbTitle;
    _centerLeftLb.text   = self.cellModel.centerLeftLbTitle;
    _centerLb.text       = self.cellModel.centerLbTitle;
    _centerRightLb.text  = self.cellModel.centerRightLbTitle;
    _bottomLeftLb.text   = self.cellModel.bottomLeftLbTitle;
    _bottomCenterLb.text = self.cellModel.bottomCenterLbTitle;
    _bottomRightLb.text  = self.cellModel.bottomRightLbTitle;
    
    [_topLeftBtn      setTitle:self.cellModel.topLeftBtnTitle forState:UIControlStateNormal];
    [_topCenterBtn    setTitle:self.cellModel.topCenterBtnTitle forState:UIControlStateNormal];
    [_topRightBtn     setTitle:self.cellModel.topRightBtnTitle forState:UIControlStateNormal];
    [_centerLeftBtn   setTitle:self.cellModel.centerLeftBtnTitle forState:UIControlStateNormal];
    [_centerBtn       setTitle:self.cellModel.centerBtnTitle forState:UIControlStateNormal];
    [_centerRightBtn  setTitle:self.cellModel.centerRightBtnTitle forState:UIControlStateNormal];
    [_bottomLeftBtn   setTitle:self.cellModel.bottomLeftBtnTitle forState:UIControlStateNormal];
    [_bottomCenterBtn setTitle:self.cellModel.bottomCenterBtnTitle forState:UIControlStateNormal];
    [_bottomRightBtn  setTitle:self.cellModel.bottomRightBtnTitle forState:UIControlStateNormal];
}

- (void)dealloc
{
    [self setCellModel:nil];
    
    [self setTopLeftLb:nil];
    [self setTopCenterLb:nil];
    [self setTopRightLb:nil];
    [self setCenterLeftLb:nil];
    [self setCenterLb:nil];
    [self setCenterRightLb:nil];
    [self setBottomLeftLb:nil];
    [self setBottomCenterLb:nil];
    [self setBottomRightLb:nil];
    
    [self setTopLeftBtn:nil];
    [self setTopCenterBtn:nil];
    [self setTopRightBtn:nil];
    [self setCenterLeftBtn:nil];
    [self setCenterBtn:nil];
    [self setCenterRightBtn:nil];
    [self setBottomLeftBtn:nil];
    [self setBottomCenterBtn:nil];
    [self setBottomRightBtn:nil];
    
    [self setTopLeftImg:nil];
    [self setTopRightImg:nil];
//    [self setCenterLeftImg:nil];
//    [self setCenterRightImg:nil];
    [self setBottomLeftImg:nil];
    [self setBottomRightImg:nil];
}

#pragma mark Label Initialization

- (UILabel *)topLeftLb
{
    if (!_topLeftLb)
    {
        _topLeftLb = [self initializedLabel];
    }
    return _topLeftLb;
}

- (UILabel *)topCenterLb
{
    if (!_topCenterLb)
    {
        //方法将Label加载至视图
        _topCenterLb= [self initializedLabel];
    }
    return _topCenterLb;
}

- (UILabel *)topRightLb
{
    if (!_topRightLb)
    {
        _topRightLb = [self initializedLabel];
    }
    return _topRightLb;
}

- (UILabel *)centerLeftLb
{
    if (!_centerLeftLb)
    {
        _centerLeftLb = [self initializedLabel];
    }
    return _centerLeftLb;
}

- (UILabel *)centerLb
{
    if (!_centerLb)
    {
        _centerLb = [self initializedLabel];
    }
    return _centerLb;
}

- (UILabel *)centerRightLb
{
    if (!_centerRightLb)
    {
        _centerRightLb = [self initializedLabel];
    }
    return _centerRightLb;
}

- (UILabel *)bottomLeftLb
{
    if (!_bottomLeftLb)
    {
        _bottomLeftLb = [self initializedLabel];
    }
    return _bottomLeftLb;
}

- (UILabel *)bottomCenterLb
{
    if (!_bottomCenterLb)
    {
        _bottomCenterLb = [self initializedLabel];
    }
    return _bottomCenterLb;
}

- (UILabel *)bottomRightLb
{
    if (!_bottomRightLb)
    {
        _bottomRightLb = [self initializedLabel];
    }
    return _bottomRightLb;
}

#pragma mark Button Initialization

- (UIButton *)topLeftBtn
{
    if (!_topLeftBtn)
    {
        //同理将btn加载至视图
        _topLeftBtn = [self initializedButton];
    }
    return _topLeftBtn;
}

- (UIButton *)topCenterBtn
{
    if (!_topCenterBtn)
    {
        _topCenterBtn = [self initializedButton];
    }
    return _topCenterBtn;
}

- (UIButton *)topRightBtn
{
    if (!_topRightBtn)
    {
        _topRightBtn = [self initializedButton];
    }
    return _topRightBtn;
}

- (UIButton *)centerLeftBtn
{
    if (!_centerLeftBtn)
    {
        _centerLeftBtn = [self initializedButton];
    }
    return _centerLeftBtn;
}

- (UIButton *)centerBtn
{
    if (!_centerBtn)
    {
        _centerBtn = [self initializedButton];
    }
    return _centerBtn;
}

- (UIButton *)centerRightBtn
{
    if (!_centerRightBtn)
    {
        _centerRightBtn = [self initializedButton];
    }
    return _centerRightBtn;
}

- (UIButton *)bottomLeftBtn
{
    if (!_bottomLeftBtn)
    {
        _bottomLeftBtn = [self initializedButton];
    }
    return _bottomLeftBtn;
}

- (UIButton *)bottomCenterBtn
{
    if (!_bottomCenterBtn)
    {
        _bottomCenterBtn = [self initializedButton];
    }
    return _bottomCenterBtn;
}

- (UIButton *)bottomRightBtn
{
    if (!_bottomRightBtn)
    {
        _bottomRightBtn = [self initializedButton];
    }
    return _bottomRightBtn;
}

#pragma mark ImageView Initialization

- (UIImageView *)topLeftImg
{
    if (!_topLeftImg)
    {
        _topLeftImg = [self initializedImageView];
    }
    return _topLeftImg;
}

//- (UIImageView *)centerLeftImg
//{
//    if (!_centerLeftImg)
//    {
//        _centerLeftImg = [self initializedImageView];
//    }
//    return _centerLeftImg;
//}
//
//- (UIImageView *)centerRightImg
//{
//    if (!_centerRightImg)
//    {
//        _centerRightImg = [self initializedImageView];
//    }
//    return _centerRightImg;
//}

- (UIImageView *)topRightImg
{
    if (!_topRightImg)
    {
        _topRightImg = [self initializedImageView];
    }
    return _topRightImg;
}

- (UIImageView *)bottomLeftImg
{
    if (!_bottomLeftImg)
    {
        _bottomLeftImg = [self initializedImageView];
    }
    return _bottomLeftImg;
}

- (UIImageView *)bottomRightImage
{
    if (!_bottomRightImg)
    {
        _bottomRightImg = [self initializedImageView];
    }
    return _bottomRightImg;
}





@end




