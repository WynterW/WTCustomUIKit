//
//  TitlePickerViewController.m
//  WTCustomUIKit
//
//  Created by Wynter on 2018/9/14.
//  Copyright © 2018年 Wynter. All rights reserved.
//

#import "TitlePickerViewController.h"

static const CGFloat kDataPickerViewH = 160.f;
static const CGFloat kToolBarH = 44.f;

@interface TitlePickerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView *dataPickerBgView;
@property (nonatomic, strong) UIPickerView *dataPickerView;
@property (nonatomic, strong) UILabel* titleLb;
@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation TitlePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor colorWithRed:73.f / 255.f green:73.f / 255.f blue:73.f / 255.f alpha:1] colorWithAlphaComponent:.5];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self show];
}

#pragma mark - PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataAry.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        pickerLabel.textColor = [UIColor colorWithRed:12.f/255.f green:14.f/255.f blue:14.f/255.f alpha:1];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    [self changeSpearatorLineColor];
    return pickerLabel;
}

#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor {
    for(UIView *speartorView in _dataPickerView.subviews) {
        if (speartorView.frame.size.height < 1) {
            speartorView.backgroundColor = [UIColor greenColor];
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataAry[row];
}

#pragma mark - event response
-(void)setTime:(id)sender {
    if (_finishBlock) {
        NSInteger row = [_dataPickerView selectedRowInComponent:0];
        _finishBlock(self.dataAry[row], row);
    }
    [self dissmiss];
}

#pragma mark - private methods
- (void)setupView {
    _dataPickerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), kToolBarH + self.pickerViewHeight>0?self.pickerViewHeight:kDataPickerViewH)];
    _dataPickerBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_dataPickerBgView];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kToolBarH)];
    [_dataPickerBgView addSubview:_toolbar];
    
    UIBarButtonItem* doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(setTime:)];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dissmiss)];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *array = [NSArray arrayWithObjects:cancelButtonItem,spaceButtonItem,doneButtonItem, nil];
    [_toolbar setItems:array];
    
    self.titleLb.center = _toolbar.center;
    [_toolbar addSubview:self.titleLb];
    [_dataPickerBgView addSubview:self.dataPickerView];
}

- (void)show {
    CGFloat pickerBgViewH = (self.pickerViewHeight>0?self.pickerViewHeight:kDataPickerViewH) + kToolBarH;
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGFloat calendarViewY = (CGRectGetHeight(self.view.frame) - pickerBgViewH);
                         self.dataPickerBgView.frame = CGRectMake(0, calendarViewY, CGRectGetWidth(self.view.frame), pickerBgViewH);
                     }];
}

- (void)dissmiss {
    CGFloat pickerBgViewH = (self.pickerViewHeight>0?self.pickerViewHeight:kDataPickerViewH) + kToolBarH;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.dataPickerBgView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), pickerBgViewH);
                     }
                     completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:NO completion:nil];
                     }];
}

#pragma mark - getters and  setters
- (UIPickerView *)dataPickerView {
    if (!_dataPickerView) {
        UIPickerView *dataPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kToolBarH, CGRectGetWidth(self.view.frame), self.pickerViewHeight>0?self.pickerViewHeight:kDataPickerViewH)];
        dataPickerView.delegate = self;
        _dataPickerView = dataPickerView;
    }
    return _dataPickerView;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        UILabel* label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"请选择标题";
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        _titleLb = label;
    }
    return _titleLb;
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    
    if (titleName) {
        self.titleLb.text = titleName;
        [self.titleLb sizeToFit];
    }
}

#pragma mark - life cycle
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touche = [touches anyObject];
    if ([touche.view isEqual:self.view]) {
        [self dissmiss];
    }
}

@end

