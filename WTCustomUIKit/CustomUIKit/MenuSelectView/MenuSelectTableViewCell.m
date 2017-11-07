//
//  MenuSelectTableViewCell.m
//  Menu
//
//  Created by Wynter on 16/7/21.
//  Copyright © 2016年 wynter. All rights reserved.
//

#import "MenuSelectTableViewCell.h"

@implementation MenuSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    
    self.imageView.frame = CGRectMake(15,10,20,20);
    
    CGRect tmpFrame     = self.textLabel.frame;
    tmpFrame.origin.x   = 45;
    tmpFrame.size.width = 80;
    
    self.textLabel.frame = tmpFrame;

}

@end
