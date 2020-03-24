//
//  PolylineChartDemo.m
//  iOS_Chart
//
//  Created by KC on 2017/7/18.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "PolylineChartDemo.h"
#import "PolyLineChart.h"

@interface PolylineChartDemo ()<PolyLineChartDataSource>
@property(nonatomic, strong)NSMutableArray *titles;
@property(nonatomic, strong)NSMutableArray *values;

@end

@implementation PolylineChartDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titles_temp = @[@"数据一",@"数据二",@"数据三",@"数据四",@"数据五",@"数据六",@"数据七",@"数据八",@"数据九",@"数据十",@"数据十一",@"数据十二",];
    NSArray *values_temp = @[@(12),@(9),@(38),@(21),@(43),@(29),@(58),@(87),@(20),@(98),@(19),@(60)];
    _titles = [NSMutableArray arrayWithArray:titles_temp];
    _values = [NSMutableArray arrayWithArray:values_temp];
    
    
    
    PolyLineChart *polyLine = [[PolyLineChart alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height  - XGDeviceManager.navigationBarHeight - (XGDeviceManager.tabbarHeight - 49))];
    polyLine.dataSource = self;
    [self.view addSubview:polyLine];
    
    
    [polyLine reloadData];
    
    // Do any additional setup after loading the view.
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
