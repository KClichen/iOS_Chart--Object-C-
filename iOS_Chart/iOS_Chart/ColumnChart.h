//
//  ColumnChart.h
//  iOS_Chart
//
//  Created by KC on 2017/7/20.
//  Copyright © 2017年 KC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColumnChart;

@protocol ColumnChartDataSource <NSObject>

@required

/**
 设置柱状图个数

 @param columnChart 返回图表
 @return 返回柱状图个数
 */
- (NSUInteger)numbersOfColumnCharts:(ColumnChart *)columnChart;

/**
 设置各柱状图的数值

 @param columnChart 传入图表
 @param index 传入索引
 @return 返回数值
 */
- (CGFloat)columnChart:(ColumnChart *)columnChart YAxisValueOfIndex:(NSUInteger)index;

/**
 设置各柱状图的名称

 @param columnChart 传入图表
 @param index 传入索引
 @return 返回名称
 */
- (NSString *)columnChart:(ColumnChart *)columnChart XAxisTitleOfIndex:(NSUInteger)index;

/**
 设置X轴单位

 @param columnChart 传入图表
 @return 返回单位
 */
- (NSString *)XAxisUnitOfColumnChart:(ColumnChart *)columnChart;

/**
 设置Y轴单位

 @param columnChart 传入图表
 @return 返回单位
 */
- (NSString *)YAxisUnitOfColumnChart:(ColumnChart *)columnChart;
@optional

/**
 设置Y轴分段数量

 @param columnChart 传入图表
 @return 返回数量
 */
- (NSUInteger)numberOfYAxisSectionOfColumnChart:(ColumnChart *)columnChart;

/**
 设置各柱状图的颜色（默认随机）

 @param columnnChart 传入图表
 @param index 传入索引
 @return 返回颜色值
 */
- (UIColor *)columnChart:(ColumnChart *)columnnChart colorOfIndex:(NSUInteger)index;

/**
 设置是否需要动画展示柱状图（默认动画）

 @param columnChart 传入图表
 @return 返回设置结果
 */
- (BOOL)showChartWithAnimation:(ColumnChart *)columnChart;

/**
 设置坐标轴颜色

 @param columnChart 传入图表
 @return 返回颜色值
 */
- (UIColor *)axisColorOfColumnChart:(ColumnChart *)columnChart;

/**
 设置X轴各柱状图名称的颜色

 @param columnChart 传入图表
 @return 返回颜色值
 */
- (UIColor *)xAxisDataTitleColorOfColumnChart:(ColumnChart *)columnChart;

/**
 设置Y轴各分段值得颜色

 @param columnChart 传入图表
 @return 返回颜色值
 */
- (UIColor *)yAxisDataTitleColorOfColumnChart:(ColumnChart *)columnChart;

@end

@interface ColumnChart : UIView
@property(nonatomic, weak)id<ColumnChartDataSource>dataSource;
- (void)reloadData;

@end
