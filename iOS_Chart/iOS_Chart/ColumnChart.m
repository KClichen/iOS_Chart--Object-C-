//
//  ColumnChart.m
//  iOS_Chart
//
//  Created by KC on 2017/7/20.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "ColumnChart.h"
#import "MyTools.h"

@interface ColumnChart()
@property(nonatomic, strong)UIColor *AxisColor;
@property(nonatomic, assign)CGFloat gapToBound;
@property(nonatomic, assign)CGFloat gapBetweenXSection;
@property(nonatomic, strong)CAShapeLayer *XAxisLayer;
@property(nonatomic, strong)CAShapeLayer *YAxisLayer;
@property(nonatomic, strong)CALayer *contentLayer;


@end

@implementation ColumnChart
@synthesize AxisColor;
@synthesize gapToBound;
@synthesize gapBetweenXSection;
@synthesize XAxisLayer,YAxisLayer,contentLayer;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBasicObjects];
        [self setUpView];
    }
    
    return self;
}

- (void)initBasicObjects
{
    AxisColor = [UIColor colorWithRed:218/255.0 green:173/255.0 blue:24/255.0 alpha:1];
    gapToBound = 50;
    gapBetweenXSection = 20;
}

- (void)setUpView
{
    //画坐标轴
    [self drawAxis];
    
//    NSArray *temps = @[@(5),@(1.2),@(9),@(3.0),@(4.5),@(0.0),@(14),@(9)];
//    NSLog(@"minValue :%.2f  maxValue :%.2f",[MyTools getMinValueFromArray:temps],[MyTools getMaxValueFromArray:temps]);
    
    /*
     1、根据获取到的数据计算最大高度，并确定Y轴上分几段
     2、确定X轴上分几段，画出坐标轴。
     3、计算各数据的柱形图的相关属性
     
     */
    
}

- (void)reloadData
{
    if (_dataSource) {
        
        if ([_dataSource respondsToSelector:@selector(axisColorOfColumnChart:)]) {
            AxisColor = [_dataSource axisColorOfColumnChart:self];
            XAxisLayer.strokeColor = AxisColor.CGColor;
            YAxisLayer.strokeColor = AxisColor.CGColor;
        }
        
        NSUInteger columnCount = [_dataSource numbersOfColumnCharts:self];
        NSMutableArray *values = @[].mutableCopy;
        
        for (NSUInteger index = 0; index<columnCount; index++) {
            [values addObject:[NSNumber numberWithFloat:[_dataSource columnChart:self YAxisValueOfIndex:index]]];
//            values[index] = [_dataSource columnChart:self YAxisValueOfIndex:index];
        }
        CGFloat minYAxisValue = [MyTools getMinValueFromArray:values];
        CGFloat maxYAxisValue = [MyTools getMaxValueFromArray:values];
        
        minYAxisValue -= maxYAxisValue * 0.1;
        maxYAxisValue *= 1.1;
    
        NSUInteger yAxisSection = 5;
        if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfYAxisSectionOfColumnChart:)]) {
            yAxisSection = [_dataSource numberOfYAxisSectionOfColumnChart:self];
        }

        CGFloat ySectionValue = (maxYAxisValue - minYAxisValue)/yAxisSection;
        
        //画y轴上的栅格线
        CGFloat sectionHeight = (self.height - gapToBound*3)/yAxisSection;
        CGPoint zeroPoint_LC = CGPointMake(0, contentLayer.frame.size.height);
        CGFloat valueToHeight = sectionHeight/ySectionValue;
        for (NSInteger i = 1; i<=yAxisSection; i++) {
            
        	//添加坐标轴上的说明
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            CFStringRef strRef  = (__bridge CFStringRef)[[UIFont systemFontOfSize:13]fontName];
            CGFontRef fontRef = CGFontCreateWithFontName(strRef);
            textLayer.font = fontRef;
            CFRelease(strRef);
            CGFontRelease(fontRef);
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.backgroundColor = [UIColor clearColor].CGColor;
            textLayer.frame = CGRectMake(0, 0, gapToBound, 30);
            textLayer.position = CGPointMake(gapToBound/2.0, YAxisLayer.frame.size.height - sectionHeight*i);
            NSString *text = [NSString stringWithFormat:@"%.00f",minYAxisValue + ySectionValue*i];
            UIColor *ySectionDataColor = [UIColor redColor];
            if ([_dataSource respondsToSelector:@selector(yAxisDataTitleColorOfColumnChart:)]) {
                ySectionDataColor = [_dataSource yAxisDataTitleColorOfColumnChart:self];
            }
            NSMutableAttributedString *textAttri = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0],NSForegroundColorAttributeName:ySectionDataColor}];
            textLayer.string = textAttri;
            [YAxisLayer addSublayer:textLayer];
            
            UIBezierPath *gridBezier = [UIBezierPath bezierPath];
            [gridBezier moveToPoint:CGPointMake(zeroPoint_LC.x, zeroPoint_LC.y - sectionHeight*i)];
            [gridBezier addLineToPoint:CGPointMake(contentLayer.frame.size.width, zeroPoint_LC.y - sectionHeight * i)];
            
            CAShapeLayer *gridLayer = [CAShapeLayer layer];
            gridLayer.strokeColor = [UIColor lightGrayColor].CGColor;
            gridLayer.fillColor = [UIColor clearColor].CGColor;
            gridLayer.lineWidth = 0.3;
            UIGraphicsBeginImageContext(contentLayer.frame.size);
            [gridBezier stroke];
            UIGraphicsEndImageContext();
            gridLayer.path = gridBezier.CGPath;
            [contentLayer addSublayer:gridLayer];
        }
        //画Y轴上的单位
        CATextLayer *unitTextLayer = [CATextLayer layer];
        unitTextLayer.contentsScale = [UIScreen mainScreen].scale;
        CFStringRef strRef  = (__bridge CFStringRef)[[UIFont systemFontOfSize:13]fontName];
        CGFontRef fontRef = CGFontCreateWithFontName(strRef);
        unitTextLayer.font = fontRef;
        CFRelease(strRef);
        CGFontRelease(fontRef);
        unitTextLayer.alignmentMode = kCAAlignmentCenter;
        unitTextLayer.backgroundColor = [UIColor clearColor].CGColor;
        unitTextLayer.frame = CGRectMake(0, 0, gapToBound, 30);
        unitTextLayer.position = CGPointMake(gapToBound/2.0, gapToBound/2.0);
        NSString *unitText = @"";
        if ([_dataSource respondsToSelector:@selector(YAxisUnitOfColumnChart:)]) {
            unitText = [_dataSource YAxisUnitOfColumnChart:self];
        }
        NSMutableAttributedString *unitTextAttri = [[NSMutableAttributedString alloc]initWithString:unitText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:AxisColor}];
        unitTextLayer.string = unitTextAttri;
        [YAxisLayer addSublayer:unitTextLayer];
        
        //画X轴上的说明文字
        
        //x轴上分区间隔暂定为区间的一半
        CGFloat xAxisGap = contentLayer.frame.size.width/(columnCount*3.0+1);
        CGFloat xSctionWidth = xAxisGap *2;
        //确定X轴上分段的参数
        for (NSInteger index = 0; index<columnCount; index++) {
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            CFStringRef strRef  = (__bridge CFStringRef)[[UIFont systemFontOfSize:13]fontName];
            CGFontRef fontRef = CGFontCreateWithFontName(strRef);
            textLayer.font = fontRef;
            CFRelease(strRef);
            CGFontRelease(fontRef);
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.backgroundColor = [UIColor clearColor].CGColor;
            textLayer.frame = CGRectMake(0, 0, gapToBound, 30);
            textLayer.position = CGPointMake(gapToBound + xAxisGap*(index + 1) + xSctionWidth*index + xSctionWidth/2.0, gapToBound/2.0);
            NSString *text = @"";
            if ([_dataSource respondsToSelector:@selector(columnChart:XAxisTitleOfIndex:)]) {
                text = [_dataSource columnChart:self XAxisTitleOfIndex:index];
            }
            UIColor *xTitleColor = [UIColor redColor];
            if ([_dataSource respondsToSelector:@selector(xAxisDataTitleColorOfColumnChart:)]) {
                xTitleColor = [_dataSource xAxisDataTitleColorOfColumnChart:self];
            }
            NSMutableAttributedString *textAttri = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0],NSForegroundColorAttributeName:xTitleColor}];
            textLayer.string = textAttri;
            [XAxisLayer addSublayer:textLayer];
        }
        //画X轴上的类型说明文字
        //画Y轴上的单位
        CATextLayer *xSctionTextLayer = [CATextLayer layer];
        xSctionTextLayer.contentsScale = [UIScreen mainScreen].scale;
        CFStringRef xSctionStrRef  = (__bridge CFStringRef)[[UIFont systemFontOfSize:13]fontName];
        CGFontRef xSectionFontRef = CGFontCreateWithFontName(xSctionStrRef);
        xSctionTextLayer.font = xSectionFontRef;
        CFRelease(xSctionStrRef);
        CGFontRelease(xSectionFontRef);
        xSctionTextLayer.alignmentMode = kCAAlignmentCenter;
        xSctionTextLayer.backgroundColor = [UIColor clearColor].CGColor;
        xSctionTextLayer.frame = CGRectMake(0, 0, gapToBound, 30);
        xSctionTextLayer.position = CGPointMake(self.width - gapToBound/2.0, gapToBound/2.0);
        NSString *xSctiontitle = @"";
        if ([_dataSource respondsToSelector:@selector(XAxisUnitOfColumnChart:)]) {
            xSctiontitle = [_dataSource XAxisUnitOfColumnChart:self];
        }
        NSMutableAttributedString *xSctiontitleAttri = [[NSMutableAttributedString alloc]initWithString:xSctiontitle attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:AxisColor}];
        xSctionTextLayer.string = xSctiontitleAttri;
        [XAxisLayer addSublayer:xSctionTextLayer];
        
        //画柱状图形
        UIColor *columnColor = [UIColor greenColor];
        for (NSInteger index = 0; index<columnCount; index++) {
            CAShapeLayer *columnLayer = [CAShapeLayer layer];
            columnLayer.lineWidth = 1.0;
            columnLayer.fillColor = columnColor.CGColor;
            columnLayer.strokeColor = [UIColor clearColor].CGColor;
            if ([_dataSource respondsToSelector:@selector(columnChart:colorOfIndex:)]) {
                columnLayer.fillColor = [_dataSource columnChart:self colorOfIndex:index].CGColor;
            }
            UIBezierPath *columnBezier = [UIBezierPath bezierPathWithRect:CGRectMake(xAxisGap*(index + 1) + xSctionWidth*index, contentLayer.frame.size.height - XAxisLayer.lineWidth/2.0, xSctionWidth, 0)];
            
            UIBezierPath *columnBezier_0 = [UIBezierPath bezierPathWithRect:CGRectMake(xAxisGap*(index + 1) + xSctionWidth*index, contentLayer.frame.size.height - XAxisLayer.lineWidth/2.0, xSctionWidth, -[values[index] floatValue]*valueToHeight)];
            
            UIGraphicsBeginImageContext(contentLayer.frame.size);
            [columnBezier fill];
            UIGraphicsEndImageContext();
//        	columnLayer.path = columnBezier.CGPath;
            [contentLayer addSublayer:columnLayer];
            
            if ([_dataSource respondsToSelector:@selector(showChartWithAnimation:)]) {
                if ([_dataSource showChartWithAnimation:self]) {
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
                    animation.duration = 2.0;
                    animation.fromValue = (id)columnBezier.CGPath;
                    animation.toValue = (id)columnBezier_0.CGPath;
                    animation.removedOnCompletion = NO;
                    animation.fillMode = kCAFillModeForwards;
                    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    [columnLayer addAnimation:animation forKey:@"path"];

                }
                else
                {
                    columnLayer.path = columnBezier_0.CGPath;
                }
            }
            else
            {
                columnLayer.path = columnBezier_0.CGPath;
            }
        }
    }
}


- (void)drawAxis
{
    UIBezierPath *xAxisBezier = [UIBezierPath bezierPath];
    [xAxisBezier moveToPoint:CGPointMake(gapToBound, 0)];
    [xAxisBezier addLineToPoint:CGPointMake(self.width - gapToBound, 0)];
    [xAxisBezier moveToPoint:CGPointMake(self.width - gapToBound - 5, -3)];
    [xAxisBezier addLineToPoint:CGPointMake(self.width - gapToBound, 0)];
    [xAxisBezier addLineToPoint:CGPointMake(self.width - gapToBound - 5, 3)];
    [xAxisBezier closePath];
    
    XAxisLayer = [CAShapeLayer layer];
    XAxisLayer.strokeColor = AxisColor.CGColor;
    XAxisLayer.fillColor = [UIColor clearColor].CGColor;
    XAxisLayer.lineWidth = 2;
    XAxisLayer.lineCap = kCALineCapButt;
    XAxisLayer.frame = CGRectMake(0, self.height - gapToBound, self.width, gapToBound);
    UIGraphicsBeginImageContext(XAxisLayer.frame.size);
    [xAxisBezier stroke];
    UIGraphicsEndImageContext();
    XAxisLayer.path = xAxisBezier.CGPath;
    [self.layer addSublayer:XAxisLayer];
    
    YAxisLayer = [CAShapeLayer layer];
    YAxisLayer.strokeColor = AxisColor.CGColor;
    YAxisLayer.fillColor = [UIColor clearColor].CGColor;
    YAxisLayer.lineWidth = 2;
    YAxisLayer.lineCap = kCALineCapButt;
    YAxisLayer.frame = CGRectMake(0, 0, gapToBound, self.height - gapToBound);
    
    UIBezierPath *yAxisBezier = [UIBezierPath bezierPath];
    [yAxisBezier moveToPoint:CGPointMake(gapToBound, self.height - gapToBound + YAxisLayer.lineWidth/2.0)];
    [yAxisBezier addLineToPoint:CGPointMake(gapToBound, gapToBound)];
    [yAxisBezier moveToPoint:CGPointMake(gapToBound - 3, gapToBound + 5)];
    [yAxisBezier addLineToPoint:CGPointMake(gapToBound, gapToBound)];
    [yAxisBezier addLineToPoint:CGPointMake(gapToBound + 3, gapToBound + 5)];
    [yAxisBezier closePath];
    UIGraphicsBeginImageContext(YAxisLayer.frame.size);
    [yAxisBezier stroke];
    UIGraphicsEndImageContext();
    YAxisLayer.path = yAxisBezier.CGPath;
    [self.layer addSublayer:YAxisLayer];
    
    contentLayer = [CALayer layer];
    contentLayer.frame = CGRectMake(gapToBound, gapToBound, self.width - gapToBound*2, self.height - gapToBound*2);
    [self.layer addSublayer:contentLayer];
}

@end
