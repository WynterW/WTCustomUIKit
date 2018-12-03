//
//  ViewController.m
//  WTCustomUIKit
//
//  Created by Wynter on 2017/11/7.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+HotelCalendarViewController.h"
#import "DatePickerViewController.h"
#import "StepperView.h"
#import "StarView.h"
#import "MenuSelectViewController.h"
#import "SegmentedController.h"
#import "TestViewController.h"
#import "ChooseMenuViewController.h"
#import "PublicCellListTableViewController.h"
#import "TopSheetDemoViewController.h"
#import "TitlePickerViewController.h"
#import "WTFeatureGuideViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) StepperView *accessoryView;
@property (nonatomic, strong) StarView *starView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = _dataSource[indexPath.row];
    if ([cell.textLabel.text isEqualToString:@"增减控件"]) {
        cell.accessoryView = self.accessoryView;
    } else if ([cell.textLabel.text isEqualToString:@"评星控件"]) {
        cell.accessoryView = self.starView;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self initCalendarViews];
            break;
        case 1:
            [self setupDatePickerView];
            break;
        case 2:
            NSLog(@"StepperView");
            break;
        case 3:
            NSLog(@"打分为：%.2f", _starView.commentPoint);
            break;
        case 4:
            [self menuSelectView];
            break;
        case 5:
            [self segmentedController];
            break;
        case 6:
            [self chooseMenuViewController];
            break;
        case 7:
            [self publicCell];
            break;
        case 8:
            [self topSheetViewController];
            break;
        case 9:
            [self titlePickerView];
            break;
        case 10:
            [self featureGuideView];
            break;
        default:
            break;
    }
}

#pragma mark - DatePickerViewController
- (void)setupDatePickerView {
    DatePickerViewController *vc = [[DatePickerViewController alloc]init];
    vc.datePickerMode = UIDatePickerModeDate;
    vc.titleName = @"请选择日期";
    vc.dateBlock = ^(NSDate *date) {
        NSLog(@"%@", date);
    };
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - StepperView
- (StepperView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [[StepperView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        _accessoryView.backgroundColor = [UIColor clearColor];
        _accessoryView.valueBlock = ^(NSInteger value) {
            NSLog(@"StepperView value is %ld", value);
        };
    }
    return _accessoryView;
}

#pragma mark - StarView
- (StarView *)starView {
    if (!_starView) {
        _starView = [[StarView alloc]initWithFrame:CGRectMake(0, 0, 200, 25) withTotalStar:5 withTotalPoint:5 starSpace:8];
        _starView.type = StarTypeComment;
        _starView.starAliment = StarAlimentCenter;
        _starView.commentPoint = 4.5;
    }
    return _starView;
}

#pragma mark - 关联菜单选择器
- (void)chooseMenuViewController {
    ChooseMenuViewController *vc = [[ChooseMenuViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.type = CompanySelectTypeIndustry;
    vc.chooseFinish = ^(CompanySelectType type, NSArray<CompanySelectTypeItem *> *selectedAry) {
        NSLog(@"%@", selectedAry);
    };
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark - MenuSelectViewController
- (void)menuSelectView {
    
    NSMutableArray *_selectListItems = [NSMutableArray arrayWithCapacity:0];
    NSArray * images = @[@"more_msg", @"more_share"];
    NSArray * titles = @[@"消息", @"分享"];
    
    [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MenuSelectItem * item = [[MenuSelectItem alloc] init];
        item.iconImage = images[idx];
        item.title = titles[idx];
        [_selectListItems addObject:item];
    }];
    
    MenuSelectViewController *_selectListVC = [[MenuSelectViewController alloc] initWithItems:_selectListItems];
    _selectListVC.alphaComponent        = 0.0;
    _selectListVC.showListViewControl   = self;
    _selectListVC.clickBlock = ^(NSInteger selectIndex) {
        NSLog(@"%zi", selectIndex);
    };
    [_selectListVC show];
}

#pragma mark - 分段控制器
- (void)segmentedController {
    SegmentedController *vc = [[SegmentedController alloc]init];
    vc.title = @"分段视图控制器";
    TestViewController *childVc1 = [[TestViewController alloc]init];
    TestViewController *childVc2 = [[TestViewController alloc]init];
    childVc1.title = @"子视图1";
    childVc2.title = @"子视图2";
    vc.childViewControllerAry = @[childVc1, childVc2];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 公用cell
- (void)publicCell {
    PublicCellListTableViewController *vc = [[PublicCellListTableViewController alloc]init];
    vc.title = @"公用cell示例";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 顶部弹出选择
- (void)topSheetViewController {
    TopSheetDemoViewController *vc = [[TopSheetDemoViewController alloc]init];
    vc.title = @"顶部弹出选择";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 标题选择器
- (void)titlePickerView {
    TitlePickerViewController *dataPickView = [[TitlePickerViewController alloc]init];
    dataPickView.pickerViewHeight = 180.f;
    dataPickView.titleName = @"";
    dataPickView.dataAry = self.dataSource;
    dataPickView.finishBlock = ^(NSString *name, NSInteger index) {
        NSLog(@"%@", name);
    };
    dataPickView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    dataPickView.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:dataPickView animated:NO completion:nil];
}

#pragma mark - 新功能引导
- (void)featureGuideView {
    BOOL finish = [[NSUserDefaults standardUserDefaults] boolForKey:@"需要新功能引导的版本号"];
    if (!finish) {
        WTFeatureGuideViewController *vc = [[WTFeatureGuideViewController alloc]init];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.markStyle = WTMarkStyleOval;
        vc.msgImageNames = @[@"home_guide_guahao",@"home_guide_daozhen",@"home_guide_hospital",@"home_guide_doctor"];
        vc.guideContentFrames = @[[NSValue valueWithCGRect:CGRectMake(20, 600, 100, 70)],[NSValue valueWithCGRect:CGRectMake(66, 260, 200, 100)],[NSValue valueWithCGRect:CGRectMake(100, 180, 300, 120)],[NSValue valueWithCGRect:CGRectMake(200, 300, 150, 100)]];
        if (vc.markStyle == WTMarkStyleRound) {
            vc.roundRadius = @[@10, @20 , @30 , @40];
        }
        [self presentViewController:vc animated:YES completion:nil];
        
        // 正式开发不需要注释下面两行代码
        // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"需要新功能引导的版本号"];
        // [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark * init values
- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"酒店日历", @"日期选择框", @"增减控件", @"评星控件", @"右侧弹出选择框", @"分段视图控制器",@"关联菜单选择器",@"公用cell",@"顶部弹出选择器",@"标题选择器",@"新功能引导"];
    }
    return _dataSource;
}
@end

