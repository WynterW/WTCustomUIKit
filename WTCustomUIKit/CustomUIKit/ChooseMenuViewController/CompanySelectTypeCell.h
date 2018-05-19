//
//  CompanySelectTypeCell.h
//  WTCustomUIKit
//
//  Created by Wynter on 2018/4/20.
//  Copyright © 2018年 Wynter All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanySelectTypeItem;

@interface CompanySelectTypeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleNameLb;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;

@property (nonatomic, strong) CompanySelectTypeItem *item;

@end
