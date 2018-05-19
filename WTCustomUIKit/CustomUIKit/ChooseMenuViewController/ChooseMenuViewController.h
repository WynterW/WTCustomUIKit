//
//  ChooseMenuViewController.h
//  WTCustomUIKit
//
//  Created by Wynter on 2018/5/18.
//  Copyright © 2018年 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanySelectTypeItem;

typedef NS_ENUM(NSInteger, CompanySelectType) {
    CompanySelectTypeArea, // 所属区域
    CompanySelectTypeIndustry, //行业类型
    CompanySelectTypeCondition // 经营状况
};


typedef void(^ChooseFinish)(CompanySelectType type, NSArray <CompanySelectTypeItem *>*selectedAry);

@interface ChooseMenuViewController : UIViewController

@property (nonatomic, assign) CompanySelectType type;
@property (nonatomic, copy) ChooseFinish chooseFinish;

@end

