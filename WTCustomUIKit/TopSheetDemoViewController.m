//
//  TopSheetDemoViewController.m
//  WTCustomUIKit
//
//  Created by Wynter on 2018/9/4.
//  Copyright © 2018年 Wynter. All rights reserved.
//

#import "TopSheetDemoViewController.h"
#import "TopSheetViewController.h"

@interface TopSheetDemoViewController ()

@end

@implementation TopSheetDemoViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (IBAction)btn1Action:(UIButton *)sender {
    TopSheetViewController *vc = [[TopSheetViewController alloc]init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.dataSource = @[@"item1",@"item2",@"item3"];
    vc.selectTitle = sender.titleLabel.text;
    vc.topH = CGRectGetMaxY(sender.frame) + [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    vc.tableViewH = 48 * 3;
    vc.showBtn = sender;
    vc.title = @"顶部弹出选择器";
    vc.selecBlock = ^(NSInteger selectIndex, NSString *selectTitle) {
        [sender setTitle:selectTitle forState:UIControlStateNormal];
    };
    [self presentViewController:vc animated:NO completion:nil];
}

- (IBAction)btn2Action:(UIButton *)sender {
    TopSheetViewController *vc = [[TopSheetViewController alloc]init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.dataSource = @[@"item1",@"item2",@"item3",@"item4",@"item5",@"item6"];
    vc.selectTitle = sender.titleLabel.text;
    vc.topH = CGRectGetMaxY(sender.frame) + [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    vc.tableViewH = 48 * 5;
    vc.showBtn = sender;
    vc.isShowBtnTransform = YES;
    vc.title = @"顶部弹出选择器";
    vc.selecBlock = ^(NSInteger selectIndex, NSString *selectTitle) {
        [sender setTitle:selectTitle forState:UIControlStateNormal];
    };
    [self presentViewController:vc animated:NO completion:nil];
}

@end
