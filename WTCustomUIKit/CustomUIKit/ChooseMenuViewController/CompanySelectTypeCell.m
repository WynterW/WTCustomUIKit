//
//  CompanySelectTypeCell.m
//  WTCustomUIKit
//
//  Created by Wynter on 2018/4/20.
//  Copyright © 2018年 Wynter All rights reserved.
//

#import "CompanySelectTypeCell.h"
#import "CompanySelectTypeItem.h"

@implementation CompanySelectTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(CompanySelectTypeItem *)item {
    _item = item;
    _titleNameLb.text = item.name;
    _selectedImageView.hidden = !item.isSelected;
}

@end
