//
//  LCPieChart.h
//  iOS_Chart
//
//  Created by KC on 2017/7/19.
//  Copyright © 2017年 KC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCPieChart;
@protocol LCPieChartDataSource <NSObject>
@required
- (NSUInteger)numbersOfPieceInPieChart:(LCPieChart *)pieChart;
- (CGFloat)pieChart:(LCPieChart *)pieChart valueFromPieceIndex:(NSUInteger)index;
@optional
- (NSString *)pieChart:(LCPieChart *)pieChart titleOfPieceAtIndex:(NSUInteger)index;
- (UIColor *)pieChart:(LCPieChart *)pieChart colorOfPieceAtIndex:(NSUInteger)index;

@end

@interface LCPieChart : UIView

@property(nonatomic, weak)id<LCPieChartDataSource>dataSource;
@property(nonatomic, assign)CGFloat pieRadius;
@property(nonatomic, assign)CGPoint pieCenter;
@property(nonatomic, assign)CGFloat animateDuration;

- (instancetype)initWithFrame:(CGRect)frame radius:(CGFloat)redius center:(CGPoint)center;
- (void)reloadData;

@end
