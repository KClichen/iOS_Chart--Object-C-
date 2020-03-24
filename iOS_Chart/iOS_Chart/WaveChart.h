//
//  WaveChart.h
//  iOS_Chart
//
//  Created by KC on 2017/7/26.
//  Copyright © 2017年 KC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaveChart;

@protocol WaveChartDataSource <NSObject>
@required
/** 传递数据个数 */
- (NSUInteger)numbersOfWaveChart:(WaveChart *)waveChart;
/** 传递x轴方向的数组 */
- (NSString *)waveChart:(WaveChart *)waveChart titleOfValuesOfIndex:(NSUInteger)index;
/** 传递x轴方向的单位标题 */
- (NSString *)xAxisUnitOfWaveChart:(WaveChart *)waveChart;
/** 传递y轴方向的单位标题 */
- (NSString *)yAxisUnitOfWaveChart:(WaveChart *)wavechart;
/** 传递某一个索引的数值 */
- (CGFloat)waveChart:(WaveChart *)waveChart valueOfIndex:(NSUInteger)index;
@optional

- (UIColor *)lineColorOfWaveChart:(WaveChart *)waveChart;
/** 传递填充图层的起始颜色 */
- (UIColor *)fillColorOfWaveChart:(WaveChart *)waveChart;
/** 传递十字架的颜色 */
- (UIColor *)crossLineColorOfWaveChart:(WaveChart *)waveChart;
/** 传递浮动显示字的颜色 */
- (UIColor *)showTextColorOfWaveChart:(WaveChart *)waveChart;
/** 传递坐标轴的颜色 */
- (UIColor *)axisColorOfWaveChart:(WaveChart *)waveChart;
/** 传递坐标单位的颜色 */
- (UIColor *)unitTextColorOfWaveChart:(WaveChart *)waveChart;
/** 是否开启显示动画 */
- (BOOL)showWithAnimateOfWaveChart:(WaveChart *)waveChart;
/** 设置y轴方向的段数 */
- (NSUInteger)numbersOfYAxisSection:(WaveChart *)waveChart;
/** 设置线条的粗细 */
- (CGFloat)strokeLineWidthOfWaveChart:(WaveChart *)waveChart;
/** 设置X轴方向的标题颜色 */
- (UIColor *)xAxisTextColorOfWaveChart:(WaveChart *)waveChart;
/** 设置Y轴方向的标题颜色 */
- (UIColor *)yAxisTextColorOfWaveChart:(WaveChart *)waveChart;
/** 是否支持全屏展示，双击就可以触发 */
- (BOOL)supportFullScreenShowOfWaveChart:(WaveChart *)waveChart;



@end

@interface WaveChart : UIView
@property(nonatomic, weak)id<WaveChartDataSource>dataSource;
- (void)reloadData;

@end
