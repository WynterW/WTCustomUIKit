//
//  CompanySelectTypeItem.h
//  WTCustomUIKit
//
//  Created by Wynter on 2018/4/20.
//  Copyright © 2018年 Wynter All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanySelectTypeItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray <CompanySelectTypeItem *> *child;
@property (nonatomic, assign) BOOL isSelected;

@end
