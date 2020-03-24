//
//  FullScreenShowController.m
//  iOS_Chart
//
//  Created by 李郴 on 2020/3/22.
//  Copyright © 2020 KC. All rights reserved.
//

#import "FullScreenShowController.h"
#import "WaveChart.h"

@interface FullScreenShowController ()<WaveChartDataSource,UIContentContainer>
@property(nonatomic, strong)NSMutableArray *titles;
@property(nonatomic, strong)NSMutableArray *values;
@property(nonatomic, strong)WaveChart *myWaveChart;

@property(nonatomic, strong)UIButton *backBtn;
@end

@implementation FullScreenShowController

- (instancetype)init {
    self = [super init];
    if (self) {
//        [super viewWillTransitionToSize:CGSizeMake(ScreenHeight, ScreenWidth) withTransitionCoordinator:self.transitionCoordinator];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarBarTintColor = [UIColor whiteColor];
    
    NSArray *titles_temp = @[@"数据一",@"数据二",@"数据三",@"数据四",@"数据五",@"数据六",@"数据七",@"数据八",@"数据九",@"数据十",@"数据十一",@"数据十二",@"数据十三",@"数据十四",@"数据十五",@"数据十六",@"数据十七",@"数据十八",@"数据十九",@"数据二十",@"数据二十一",@"数据二十二",@"数据二十三",@"数据二十四"];
    NSArray *values_temp = @[@(12),@(9),@(38),@(21),@(43),@(29),@(58),@(87),@(20),@(98),@(19),@(60),@(12),@(56),@(38),@(21),@(47),@(29),@(58),@(87),@(36),@(98),@(39),@(60)];
    _titles = [NSMutableArray arrayWithArray:titles_temp];
    _values = [NSMutableArray arrayWithArray:values_temp];

    
    self.myWaveChart = [[WaveChart alloc]initWithFrame:CGRectMake(XGDeviceManager.navigationBarHeight - 64, 0, self.view.height - (XGDeviceManager.navigationBarHeight - 64), self.view.width - (XGDeviceManager.tabbarHeight - 49))];
    self.myWaveChart.dataSource = self;
    [self.view addSubview:self.myWaveChart];
    
    
    [self.view addSubview:self.backBtn];
    
//    [super viewWillTransitionToSize:CGSizeMake(self.view.height, self.view.width) withTransitionCoordinator:self.transitionCoordinator];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//
//    self.myWaveChart.frame = CGRectMake(0, 0, self.view.height, self.view.width - (XGDeviceManager.tabbarHeight - 49));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
//    [self.myWaveChart reloadData];
//    [super viewWillTransitionToSize:CGSizeMake(ScreenHeight, ScreenWidth) withTransitionCoordinator:self.transitionCoordinator];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.myWaveChart reloadData];
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


#pragma mark - WaveChartDataSource
- (NSUInteger)numbersOfWaveChart:(WaveChart *)waveChart
{
    return _titles.count;
}
- (NSString *)waveChart:(WaveChart *)waveChart titleOfValuesOfIndex:(NSUInteger)index
{
    return _titles[index];
}
- (NSString *)xAxisUnitOfWaveChart:(WaveChart *)waveChart
{
    return @"观察类型";
}
- (NSString *)yAxisUnitOfWaveChart:(WaveChart *)wavechart
{
    return @"观察数值";
}
- (CGFloat)waveChart:(WaveChart *)waveChart valueOfIndex:(NSUInteger)index
{
    return [_values[index]floatValue];
}

- (BOOL)showWithAnimateOfWaveChart:(WaveChart *)waveChart {
    return YES;
}

- (BOOL)supportFullScreenShowOfWaveChart:(WaveChart *)waveChart {
    return NO;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    NSLog(@"+++++++++++++  fullscreen.width = %.2f, fullscreen.height = %.2f  ++++++ didRotate +++++",self.view.frame.size.width,self.view.frame.size.height);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"+++++++++++++  fullscreen.width = %.2f, fullscreen.height = %.2f  ++++++ didRotate +++++",self.view.frame.size.width,self.view.frame.size.height);
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
- (void)backToPreviouse:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)finglerDoubleTap:(UITapGestureRecognizer *)tap
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
