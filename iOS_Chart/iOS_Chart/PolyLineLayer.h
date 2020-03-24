//
//  PolyLineLayer.h
//  iOS_Chart
//
//  Created by KC on 2017/7/25.
//  Copyright © 2017年 KC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, PolyLineType) {
    PolyLineStroke = 0,
    PolyLineFill,
    PolyLinePoint,
};


@class PolyLineLayer;

@protocol PolyLineDataSource <NSObject>
@required
- (NSUInteger)numbersOfPolyLinePoints:(PolyLineLayer *)polyLine;
- (CGPoint)polyLine:(PolyLineLayer *)polyLine pointOfIndex:(NSUInteger)index;
@optional
- (UIColor *)lineColorOfPolyLine:(PolyLineLayer *)polyLine;
- (BOOL)isAnimateShowOfPolyLine:(PolyLineLayer *)polyLine;
- (UIColor *)fillColorOfPolyLine:(PolyLineLayer *)polyLine;
- (BOOL)isGrandShadowShowOfPolyLine:(PolyLineLayer *)polyLine;
@end

@interface PolyLineLayer : CAShapeLayer
@property(nonatomic, weak)id<PolyLineDataSource>dataSource;
@property(nonatomic, assign)PolyLineType type;
@end
