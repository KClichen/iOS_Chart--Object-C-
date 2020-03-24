//
//  PolyLineChart.h
//  iOS_Chart
//
//  Created by KC on 2017/7/24.
//  Copyright © 2017年 KC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PolyLineChart;

@protocol PolyLineChartDataSource <NSObject>

@required
- (NSUInteger)numbersOfPolylineChart:(PolyLineChart *)polyLineChart;
- (NSString *)polyLineChart:(PolyLineChart *)polyLineChart titleOfValuesOfIndex:(NSUInteger)index;
- (CGFloat)polyLineChart:(PolyLineChart *)polyLineChart valueOfIndex:(NSUInteger)index;
- (NSString *)xAxisUnitOfPolyLineChart:(PolyLineChart *)polyLineChart;
- (NSString *)YAxisUnitOfPolyLineChart:(PolyLineChart *)polyLineChart;
@optional
- (BOOL)showWithAnimateOfPolyLineChart:(PolyLineChart *)polyLineChart;
- (UIColor *)lineColorOfPolyLineChart:(PolyLineChart *)polyLineChart;
- (UIColor *)fillColorOfPolyLineChart:(PolyLineChart *)polyLineChart;
- (UIColor *)crossLineColorOfPolyLineChart:(PolyLineChart *)polyLineChart;
- (UIColor *)showTextColorOfPolyLineChart:(PolyLineChart *)polyLineChart;
- (UIColor *)axisColorOfPolyLineChart:(PolyLineChart *)polyLineChart;
- (UIColor *)unitTextColorOfPolyLineChart:(PolyLineChart *)polyLineChart;

- (NSUInteger)numbersOfYAxisSection:(PolyLineChart *)polyLineChart;
- (CGFloat)strokeLineWidthOfPolyLineChart:(PolyLineChart *)polyLineChart;
- (UIColor *)xAxisTextColorOfPolyLineChart:(PolyLineChart *)polyLineChart;
- (UIColor *)yAxisTextColorOfPolyLineChart:(PolyLineChart *)polyLineChart;
/** 是否支持全屏展示，双击就可以触发 */
- (BOOL)supportFullScreenShowOfPolyLineChart:(PolyLineChart *)polyLineChart;
@end

@interface PolyLineChart : UIView
@property(nonatomic, weak)id<PolyLineChartDataSource>dataSource;
- (void)reloadData;

@end


