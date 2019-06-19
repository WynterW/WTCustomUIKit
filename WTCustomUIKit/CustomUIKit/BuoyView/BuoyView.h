//
//  BuoyView.h
//  WTCustomUIKit
//
//  Created by Wynter on 2019/6/3.
//  Copyright © 2019 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuoyView : UIImageView

@property (nonatomic, copy) void (^clickViewBlock)(void);

@end

NS_ASSUME_NONNULL_END
