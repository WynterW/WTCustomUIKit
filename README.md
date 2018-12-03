# WTCustomUIKit

WTCustomUIKit是一个日常开发积累下来的自定义UI控件的项目。

![demo](https://github.com/WynterW/WTCustomUIKit/blob/master/WTCustomUIKit.gif)

## 酒店日历组件

```obj
#pragma mark - private instance method
- (void)initCalendarViews {
    HotelCalendarViewController *vc = [[HotelCalendarViewController alloc]init];
    vc.delegate = self;
    vc.dataSource = self;
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark - HotelCalendarViewDataSource
- (NSDate *)minimumDateForHotelCalendar {
    NSDate *nowDate = [NSDate new];
    NSDate *lastDate = [NSDate dateWithTimeInterval:-24 * 60 * 60 sinceDate:nowDate];
    return lastDate;
}

- (NSDate *)maximumDateForHotelCalendar {
    return [NSCalendar date:[NSDate new] addMonth:2];
}

- (NSDate *)defaultSelectFromDate {
    return [NSDate new];
}

- (NSDate *)defaultSelectToDate {
    NSDate *nowDate = [NSDate new];
    NSDate *nextDate = [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:nowDate];
    return nextDate;
}

#pragma mark - HotelCalendarViewDelegate
- (NSInteger)rangeDaysForHotelCalendar {
    return 365;
}

- (void)selectNSStringFromDate:(NSString *)fromDate toDate:(NSString *)toDate {
    if (!fromDate) {
        NSLog(@"未完成日期选择");
        return;
    }
    NSLog(@"fromDate: %@, toDate: %@", fromDate, toDate);
}

- (NSInteger)itemWidthForHotelCalendar{
    return 50;
}
```

## 日期时间选择框
```obj
   DatePickerViewController *vc = [[DatePickerViewController alloc]init];
    vc.datePickerMode = UIDatePickerModeDate;
    vc.titleName = @"请选择日期";
    vc.dateBlock = ^(NSDate *date) {
        NSLog(@"%@", date);
    };
    [self presentViewController:vc animated:NO completion:nil];
```

## 增减控件
```obj
@property (nonatomic, strong) StepperView *accessoryView;

cell.accessoryView = self.accessoryView;

- (StarView *)starView {
    if (!_starView) {
        _starView = [[StarView alloc]initWithFrame:CGRectMake(0, 0, 200, 25) withTotalStar:5 withTotalPoint:5 starSpace:8];
        _starView.type = StarTypeComment;
        _starView.starAliment = StarAlimentCenter;
        _starView.commentPoint = 0;
    }
    return _starView;
}
```

## 评星控件
```obj
@property (nonatomic, strong) StarView *starView;
cell.accessoryView = self.starView;
- (StarView *)starView {
    if (!_starView) {
        _starView = [[StarView alloc]initWithFrame:CGRectMake(0, 0, 200, 25) withTotalStar:5 withTotalPoint:5 starSpace:8];
        _starView.type = StarTypeComment;
        _starView.starAliment = StarAlimentCenter;
        _starView.commentPoint = 0;
    }
    return _starView;
}
```

## 右侧弹出选择框
```obj
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
```

## 分段视图控制器
```obj
  SegmentedController *vc = [[SegmentedController alloc]init];
    vc.title = @"分段视图控制器";
    TestViewController *childVc1 = [[TestViewController alloc]init];
    TestViewController *childVc2 = [[TestViewController alloc]init];
    childVc1.title = @"子视图1";
    childVc2.title = @"子视图2";
    vc.childViewControllerAry = @[childVc1, childVc2];
    [self.navigationController pushViewController:vc animated:YES];
```

## 关联菜单选择器

```obj
ChooseMenuViewController *vc = [[ChooseMenuViewController alloc] init];
vc.modalPresentationStyle = UIModalPresentationCustom;
vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
vc.type = CompanySelectTypeIndustry;
vc.chooseFinish = ^(CompanySelectType type, NSArray<CompanySelectTypeItem *> *selectedAry) {
    NSLog(@"%@", selectedAry);
};
[self presentViewController:vc animated:NO completion:nil];
```

## 公用cell

```obj
PublicCellListTableViewController *vc = [[PublicCellListTableViewController alloc]init];
vc.title = @"公用cell示例";
[self.navigationController pushViewController:vc animated:YES];
```

## 公用cell

```obj
TopSheetDemoViewController *vc = [[TopSheetDemoViewController alloc]init];
vc.title = @"顶部弹出选择";
[self.navigationController pushViewController:vc animated:YES];
```

## 标题选择器

```obj
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
```
## 新功能引导

```obj
BOOL finish = [[NSUserDefaults standardUserDefaults] boolForKey:@"需要新功能引导的版本号"];
if (!finish) {
    WTFeatureGuideViewController *vc = [[WTFeatureGuideViewController alloc]init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.markStyle = WTMarkStyleRect;
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
```


