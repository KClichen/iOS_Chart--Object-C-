//
//  ColumnChartDemo.m
//  iOS_Chart
//
//  Created by KC on 2017/7/18.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "ColumnChartDemo.h"
#import "ColumnChart.h"

@interface ColumnChartDemo ()<ColumnChartDataSource>

@property(nonatomic, strong)NSMutableArray *columnValues;
@property(nonatomic, strong)NSMutableArray *columnNames;
@property(nonatomic, strong)NSMutableArray *columnColors;

@end

@implementation ColumnChartDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _columnNames = @[].mutableCopy;
//    _columnValues = @[].mutableCopy;
    _columnColors = @[].mutableCopy;
    
    for (NSInteger index = 0; index<6; index ++) {
        CGFloat red = arc4random()%255/255.0;
        CGFloat green = arc4random()%255/255.0;
        CGFloat blue = arc4random()%255/255.0;
        
        //        NSInteger temp = arc4random();
        //        NSLog(@"temp : %d",temp);
        NSLog(@"red: %.2f, green: %.2f, blue: %.2f",red, green, blue);
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        [_columnColors addObject:color];
    }
    
    
    
    NSArray *values = @[@(24),@(35),@(13),@(98),@(25),@(76)];
    NSArray *names = @[@"数据一",@"数据二",@"数据三",@"数据四",@"数据五",@"数据六"];
    
    _columnValues = [NSMutableArray arrayWithArray:values];
    _columnNames = [NSMutableArray arrayWithArray:names];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpView];
    
    // Do any additional setup after loading the view.
}

- (void)setUpView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    ColumnChart *column = [[ColumnChart alloc]initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height  - XGDeviceManager.navigationBarHeight - (XGDeviceManager.tabbarHeight - 49))];
    column.dataSource = self;
    [self.view addSubview:column];
    [column reloadData];
    
    
}





#pragma mark - ColumnChartDataSource
- (NSUInteger)numbersOfColumnCharts:(ColumnChart *)columnChart
{
    return _columnValues.count;
}
- (CGFloat)columnChart:(ColumnChart *)columnChart YAxisValueOfIndex:(NSUInteger)index
{
    return [_columnValues[index] floatValue];
}
- (NSString *)columnChart:(ColumnChart *)columnChart XAxisTitleOfIndex:(NSUInteger)index
{
    return _columnNames[index];
}
- (NSString *)XAxisUnitOfColumnChart:(ColumnChart *)columnChart
{
    return @"观察类型";
}
- (NSString *)YAxisUnitOfColumnChart:(ColumnChart *)columnChart
{
    return @"观察对象";
}

- (NSUInteger)numberOfYAxisSectionOfColumnChart:(ColumnChart *)columnChart
{
    return 6;
}
- (UIColor *)columnChart:(ColumnChart *)columnnChart colorOfIndex:(NSUInteger)index
{
    return _columnColors[index];
}
//- (UIColor *)axisColorOfColumnChart:(ColumnChart *)columnChart
//{
//    return [UIColor blackColor];
//}

- (BOOL)showChartWithAnimation:(ColumnChart *)columnChart
{
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
