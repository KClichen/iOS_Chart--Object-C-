//
//  WaveChartDemo.m
//  iOS_Chart
//
//  Created by KC on 2017/7/18.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "WaveChartDemo.h"
#import "WaveChart.h"

@interface WaveChartDemo ()<WaveChartDataSource>
@property(nonatomic, strong)NSMutableArray *titles;
@property(nonatomic, strong)NSMutableArray *values;

@end

@implementation WaveChartDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarBarTintColor = [UIColor whiteColor];
    
    NSArray *titles_temp = @[@"数据一",@"数据二",@"数据三",@"数据四",@"数据五",@"数据六",@"数据七",@"数据八",@"数据九",@"数据十",@"数据十一",@"数据十二",@"数据十三",@"数据十四",@"数据十五",@"数据十六",@"数据十七",@"数据十八",@"数据十九",@"数据二十",@"数据二十一",@"数据二十二",@"数据二十三",@"数据二十四",@"数据二十五",@"数据二十六",@"数据二十七",@"数据二十八",@"数据二十九",@"数据三十",@"数据三十一",@"数据三十二",@"数据三十三",@"数据三十四"];
    NSArray *values_temp = @[@(12),@(9),@(38),@(21),@(43),@(29),@(58),@(87),@(20),@(98),@(19),@(60),@(12),@(56),@(38),@(21),@(47),@(29),@(58),@(87),@(36),@(98),@(39),@(60),@(87),@(36),@(98),@(39),@(60),@(87),@(36),@(98),@(39),@(60)];
    _titles = [NSMutableArray arrayWithArray:titles_temp];
    _values = [NSMutableArray arrayWithArray:values_temp];

    
    WaveChart *waveChart = [[WaveChart alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - XGDeviceManager.navigationBarHeight - (XGDeviceManager.tabbarHeight - 49))];
    waveChart.dataSource = self;
    [self.view addSubview:waveChart];
    
    [waveChart reloadData];
    // Do any additional setup after loading the view.
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
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
