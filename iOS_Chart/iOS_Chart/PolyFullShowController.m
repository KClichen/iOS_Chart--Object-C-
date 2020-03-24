//
//  PolyFullShowController.m
//  iOS_Chart
//
//  Created by 李郴 on 2020/3/24.
//  Copyright © 2020 KC. All rights reserved.
//

#import "PolyFullShowController.h"
#import "PolyLineChart.h"

@interface PolyFullShowController ()<PolyLineChartDataSource>
@property(nonatomic, strong)NSMutableArray *titles;
@property(nonatomic, strong)NSMutableArray *values;
@property(nonatomic, strong)PolyLineChart *myPolyChart;

@property(nonatomic, strong)UIButton *backBtn;

@end

@implementation PolyFullShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarBarTintColor = [UIColor whiteColor];
    
     NSArray *titles_temp = @[@"数据一",@"数据二",@"数据三",@"数据四",@"数据五",@"数据六",@"数据七",@"数据八",@"数据九",@"数据十",@"数据十一",@"数据十二",];
       NSArray *values_temp = @[@(12),@(9),@(38),@(21),@(43),@(29),@(58),@(87),@(20),@(98),@(19),@(60)];
       _titles = [NSMutableArray arrayWithArray:titles_temp];
       _values = [NSMutableArray arrayWithArray:values_temp];

    
    self.myPolyChart = [[PolyLineChart alloc]initWithFrame:CGRectMake(XGDeviceManager.navigationBarHeight - 64, 0, self.view.height - (XGDeviceManager.navigationBarHeight - 64), self.view.width - (XGDeviceManager.tabbarHeight - 49))];
    self.myPolyChart.dataSource = self;
    [self.view addSubview:self.myPolyChart];
    
    
    [self.view addSubview:self.backBtn];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.myPolyChart reloadData];
}

#pragma mark - PolyLineChartDataSource
- (NSUInteger)numbersOfPolylineChart:(PolyLineChart *)polyLineChart
{
    return _titles.count;
}
- (NSString *)polyLineChart:(PolyLineChart *)polyLineChart titleOfValuesOfIndex:(NSUInteger)index
{
    return _titles[index];
}
- (CGFloat)polyLineChart:(PolyLineChart *)polyLineChart valueOfIndex:(NSUInteger)index
{
    return [_values[index] floatValue];
}
- (NSString *)xAxisUnitOfPolyLineChart:(PolyLineChart *)polyLineChart
{
    return @"观察类型";
}
- (NSString *)YAxisUnitOfPolyLineChart:(PolyLineChart *)polyLineChart{
    return @"观察数值";
}

- (BOOL)showWithAnimateOfPolyLineChart:(PolyLineChart *)polyLineChart {
    
    return YES;
}

- (BOOL)supportFullScreenShowOfPolyLineChart:(PolyLineChart *)polyLineChart {
    return NO;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       //[self.waveChartVC.waveChart.backBtn setImage:[UIImage imageNamed:@"closebtn"] forState:UIControlStateNormal];
       [_backBtn setBackgroundImage:[UIImage imageNamed:@"guanbi.png"] forState:UIControlStateNormal];
       [_backBtn setFrame:CGRectMake(self.view.height -40, 10, 30, 30)];
       [self.view addSubview:_backBtn];
       [_backBtn addTarget:self action:@selector(backToPreviouse:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)backToPreviouse:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

@end
