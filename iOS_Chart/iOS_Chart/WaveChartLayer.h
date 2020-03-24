//
//  WaveChartLayer.h
//  iOS_Chart
//
//  Created by KC on 2017/8/1.
//  Copyright © 2017年 KC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
typedef NS_ENUM(NSUInteger, WaveChartType) {
    WaveChartStroke = 0,
    WaveChartFill,
    WaveChartPoint,
};

@class WaveChartLayer;

@protocol WaveChartLayerDataSource <NSObject>
@required
- (NSUInteger)numbersOfWaveChartPoints:(WaveChartLayer *)waveLayer;
- (CGPoint)waveChartLayer:(WaveChartLayer *)waveLayer pointOfIndex:(NSUInteger)index;

@end

@interface WaveChartLayer : CAShapeLayer
@property(nonatomic, weak)id<WaveChartLayerDataSource>dataSource;
@property(nonatomic, assign)WaveChartType type;
@end
