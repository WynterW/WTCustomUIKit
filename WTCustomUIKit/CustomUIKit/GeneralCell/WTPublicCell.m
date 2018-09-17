//
//  WTPublicCell.m
//  WTCustomUIKit
//
//  Created by Wynter on 2018/9/4.
//  Copyright © 2018年 Wynter. All rights reserved.
//

#import "WTPublicCell.h"
#import "Masonry.h"

@implementation WTPublicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setupDefault {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:self.leftImgView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.accessoryImgView];
    self.accessoryImgView.hidden = self.isHiddenAccessory;
    [self.contentView addSubview:self.bottomLineLb];
    
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(24, 24));
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.leftImgView.mas_right).offset(5);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.accessoryImgView.mas_left).offset(10);
    }];
    [self.accessoryImgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(24, 24));
    }];
    
    [self.bottomLineLb mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.offset(0.5);
        make.bottom.right.left.equalTo(self.self.contentView);
    }];
}

- (void)setupCenterText {
    [self.contentView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.bottomLineLb];
    [self.bottomLineLb mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.offset(0.5);
        make.bottom.right.left.equalTo(self.self.contentView);
    }];
}

- (void)setupChecked {
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.rightImgView];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(24, 24));
    }];
    
    [self.contentView addSubview:self.bottomLineLb];
    [self.bottomLineLb mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.offset(0.5);
        make.bottom.right.left.equalTo(self.self.contentView);
    }];
}

- (void)setupValue1 {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.leftImgView];
    [self.contentView addSubview:self.rightImgView];
    [self.contentView addSubview:self.subtitleLb];
    [self.contentView addSubview:self.accessoryImgView];
    [self.contentView addSubview:self.bottomLineLb];
    self.rightImgView.hidden = YES;
    self.subtitleLb.hidden = YES;
    self.accessoryImgView.hidden = self.isHiddenAccessory;
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(24, 24));
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.leftImgView.mas_right).offset(5);
        make.centerY.equalTo(self.contentView);
        make.width.lessThanOrEqualTo(self.contentView.mas_width).multipliedBy(0.5);
    }];
    [self.accessoryImgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(24, 24));
    }];
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make){
        if (self.isHiddenAccessory) {
            make.right.equalTo(self.contentView).offset(-12);
        } else {
            make.right.equalTo(self.accessoryImgView.mas_left).offset(5);
        }
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(24, 24));
    }];
    
    [self.subtitleLb mas_makeConstraints:^(MASConstraintMaker *make){
        if (self.isHiddenAccessory) {
            make.right.equalTo(self.contentView).offset(-12);
        } else {
            make.right.equalTo(self.accessoryImgView.mas_left).offset(5);
        }
        make.left.greaterThanOrEqualTo(self.titleLb.mas_right).with.offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.bottomLineLb mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.offset(0.5);
        make.bottom.right.left.equalTo(self.self.contentView);
    }];
    
}

- (void)setupValue2 {
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.subtitleLb];
    [self.contentView addSubview:self.accessoryImgView];
    self.accessoryImgView.hidden = self.isHiddenAccessory;
    [self.contentView addSubview:self.bottomLineLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
        make.width.lessThanOrEqualTo(self.contentView.mas_width).multipliedBy(0.5);
    }];
    
    [self.accessoryImgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(24, 24));
    }];
    
    [self.subtitleLb mas_makeConstraints:^(MASConstraintMaker *make){
        if (self.isHiddenAccessory) {
            make.right.equalTo(self.contentView).offset(-12);
        } else {
            make.right.equalTo(self.accessoryImgView.mas_left).offset(5);
        }
        make.left.greaterThanOrEqualTo(self.titleLb.mas_right).with.offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.bottomLineLb mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.offset(0.5);
        make.bottom.right.left.equalTo(self.self.contentView);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCustomCellStyle:(WTTableViewCellStyle)customCellStyle {
    _customCellStyle = customCellStyle;
    switch (customCellStyle) {
        case WTTableViewCellStyleDefault:
            [self setupDefault];
            break;
        case WTTableViewCellStyleCenterText:
            [self setupCenterText];
            break;
        case WTTableViewCellStyleChecked:
            [self setupChecked];
            break;
        case WTTableViewCellStyleValue1:
            [self setupValue1];
            break;
        case WTTableViewCellStyleValue2:
            [self setupValue2];
            break;
        default:
            [self setupDefault];
            break;
    }
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont systemFontOfSize:14];
        _titleLb.textColor = [UIColor colorWithRed:12/255.0 green:14/255.0 blue:14/255.0 alpha:1];
    }
    return _titleLb;
}

- (UILabel *)subtitleLb {
    if (!_subtitleLb) {
        _subtitleLb = [[UILabel alloc]init];
        _subtitleLb.font = [UIFont systemFontOfSize:14];
        _subtitleLb.textColor = [UIColor colorWithRed:122/255.0 green:142/255.0 blue:135/255.0 alpha:1];
    }
    return _subtitleLb;
}

- (UIImageView *)leftImgView {
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc]init];
    }
    return _leftImgView;
}

- (UIImageView *)rightImgView {
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc]init];
    }
    return _rightImgView;
}

- (UIImageView *)accessoryImgView {
    if (!_accessoryImgView) {
        _accessoryImgView = [[UIImageView alloc]init];
        _accessoryImgView.image = [UIImage imageNamed:@"cell_right_Indicator"];

    }
    return _accessoryImgView;
}

- (UILabel *)bottomLineLb {
    if (!_bottomLineLb) {
        _bottomLineLb = [[UILabel alloc]init];
        _bottomLineLb.backgroundColor = [UIColor colorWithRed:241/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        _bottomLineLb.hidden = YES;
    }
    return _bottomLineLb;
}

- (void)setIsHiddenAccessory:(BOOL)isHiddenAccessory {
    _isHiddenAccessory = isHiddenAccessory;
    [self setCustomCellStyle:_customCellStyle];
    
}

@end
