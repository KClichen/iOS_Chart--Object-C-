//
//  WaveChart.m
//  iOS_Chart
//
//  Created by KC on 2017/7/26.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "WaveChart.h"
#import "WaveChartLayer.h"
#import "MyTools.h"
#import "FullScreenShowController.h"

@interface WaveChart()<UIGestureRecognizerDelegate,WaveChartLayerDataSource,CAAnimationDelegate>
@property(nonatomic, assign)CGFloat yAxisWidth;
@property(nonatomic, assign)CGFloat xAxisWidth;
@property(nonatomic, strong)CAShapeLayer *yAxisLayer;
@property(nonatomic, strong)CAShapeLayer *xAxisLayer;
@property(nonatomic, strong)UIColor *axisColor;
@property(nonatomic, strong)NSMutableArray *valueTitles;
@property(nonatomic, strong)NSMutableArray *values;
@property(nonatomic, strong)NSMutableArray *points;
@property(nonatomic, strong)UIPanGestureRecognizer *panGes;
@property(nonatomic, strong)UIPinchGestureRecognizer *pinGes;
@property(nonatomic, strong)UITapGestureRecognizer *doubleTapGes;
@property(nonatomic, assign)CGPoint pinchPos;//记录pinch手势的位置
@property(nonatomic, assign)CGFloat currentScale;//记录pinch手势开始时的scale
@property(nonatomic, assign)CGFloat xSectionWidth;//x轴方向点之间的距离
@property(nonatomic, assign)CGFloat pinchScale;//记录捏合手势当前的scale
@property(nonatomic, assign)CGFloat prevPosX;//记录上一次拖动手势的位置
@property(nonatomic, assign)CGFloat panDistanceX;//拖动手势X轴方向的移动距离
@property(nonatomic, assign)CGPoint fingerLoc;//记录手指在图表上的位置
@property(nonatomic, assign)BOOL isMove;//判断手指是否在图表上移动
@property(nonatomic, strong)CAShapeLayer *crossLineLayer;//十字线图层

@property(nonatomic, assign)CGFloat yAxisLineWidth;//y轴的粗细设置
@property(nonatomic, assign)CGFloat xAxisLineWidth;//x轴的粗细设置

@property(nonatomic, assign)CGFloat chartTopPadding;//表格距离顶端的间距
@property(nonatomic, assign)CGFloat chartLeftPadding;//表格距离左端的间距
@property(nonatomic, assign)CGFloat chartRightPadding;//表格距离右端的间距
@property(nonatomic, assign)CGFloat chartBottomPadding;//表格距离底端的间距

@property(nonatomic, assign)BOOL hasArrow;//是否有箭头
@property(nonatomic, assign)CGFloat arrowYOffset;//箭头y方向的间距
@property(nonatomic, assign)CGFloat arrowXOffset;//箭头x方向的间距

@property(nonatomic, assign)NSUInteger sectionCount;//纵坐标分段数，默认为5
@property(nonatomic, assign)CGFloat xAxisStrFontSize;//X轴上的文字字号
@property(nonatomic, assign)CGFloat yAxisStrFontSize;//y轴上的文字字号
@property(nonatomic, assign)CGFloat chartTitleFontSize;//表头文字字号

@property(nonatomic, strong)UIColor *crossLineColor;//十字架颜色
@property(nonatomic, assign)CGFloat floatShowTextFontSize;//悬浮展示文字的字体大小

/** 填充层动画时间 */
@property(nonatomic, assign)CGFloat fillAnimateTime;//填充层动画时间
/** 外围线条动画时间 */
@property(nonatomic, assign)CGFloat strokeAnimateTime;//外围线条动画时间
/** 点显示动画时间  */
@property(nonatomic, assign)CGFloat pointAnimateTime;//点显示动画时间

/** 是否要填充层 */
@property(nonatomic, assign)BOOL hasFill;
/** 是否要颜色渐变层 */
@property(nonatomic, assign)BOOL hasGradiant;
/** 是否要外围线条展示 */
@property(nonatomic, assign)BOOL hasStroke;
/** 是否要点描绘 */
@property(nonatomic, assign)BOOL hasPoint;
/** 是否支持缩放 */
@property(nonatomic, assign)BOOL supportPinchGes;




@end

@implementation WaveChart

@synthesize yAxisWidth,xAxisWidth;
@synthesize yAxisLayer,xAxisLayer;
@synthesize axisColor;
@synthesize valueTitles,values;
@synthesize points;
@synthesize panGes,pinGes,doubleTapGes;
@synthesize pinchPos,currentScale;
@synthesize xSectionWidth;
@synthesize pinchScale;
@synthesize prevPosX,panDistanceX;
@synthesize fingerLoc,isMove;
@synthesize yAxisLineWidth,xAxisLineWidth;
@synthesize chartTopPadding,chartLeftPadding,chartRightPadding,chartBottomPadding;
@synthesize hasArrow,arrowYOffset,arrowXOffset;
@synthesize sectionCount;
@synthesize xAxisStrFontSize,yAxisStrFontSize,chartTitleFontSize;
@synthesize crossLineColor,floatShowTextFontSize;
@synthesize fillAnimateTime,strokeAnimateTime,pointAnimateTime;
@synthesize hasFill,hasStroke,hasPoint,hasGradiant,supportPinchGes;



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
    yAxisWidth = 50;
    currentScale = 1;
    xAxisWidth = self.width - yAxisWidth - 50;
    axisColor = [UIColor colorWithRed:218/255.0 green:173/255.0 blue:24/255.0 alpha:1];
    values = @[].mutableCopy;
    valueTitles = @[].mutableCopy;
    points = @[].mutableCopy;
    yAxisLineWidth = 2.f;
    xAxisLineWidth = 2.f;
    
    hasArrow = YES;
    arrowYOffset = 3.f;
    arrowXOffset = 5.f;
    
    chartTopPadding = 50.f;
    chartBottomPadding = 50.f;
    chartLeftPadding = 50.f;
    chartRightPadding = 20.f;
    
    yAxisStrFontSize = 13.f;
    xAxisStrFontSize = 13.f;
    chartTitleFontSize = 18.f;
    
    floatShowTextFontSize = 16.f;
    
    crossLineColor = UIColor.greenColor;
    
    fillAnimateTime = 2.f;
    strokeAnimateTime = 2.f;
    pointAnimateTime = 1.f;
    
    hasFill = YES;
    hasGradiant = YES;
    hasStroke = YES;
    hasPoint = YES;
    supportPinchGes = YES;
    
}

- (void)setUpView
{
    //画X轴
    [self drawXAxis];
    //画Y轴
    [self drawYAxis];
    
    pinGes = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGesAction:)];
    pinGes.delegate = self;
    [self addGestureRecognizer:pinGes];
    
    panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesAction:)];
    pinGes.delegate = self;
    [self addGestureRecognizer:panGes];
    
    doubleTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    [doubleTapGes setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTapGes];
}

- (void)drawYAxis
{
    yAxisLayer = [CAShapeLayer layer];
    yAxisLayer.frame = CGRectMake(0, 0, yAxisWidth, self.height - chartBottomPadding + xAxisLineWidth/2.0);
    yAxisLayer.lineWidth = yAxisLineWidth;
    yAxisLayer.fillColor = [UIColor clearColor].CGColor;
    yAxisLayer.strokeColor = axisColor.CGColor;
    yAxisLayer.lineCap = kCALineCapButt;
    yAxisLayer.backgroundColor = UIColor.whiteColor.CGColor;
    
    UIBezierPath *yAxisBezier = [UIBezierPath bezierPath];
    [yAxisBezier moveToPoint:CGPointMake(yAxisWidth, self.height - chartBottomPadding + yAxisLayer.lineWidth/2.0)];
    [yAxisBezier addLineToPoint:CGPointMake(yAxisWidth, chartTopPadding)];
    
    if (hasArrow) {
        [yAxisBezier moveToPoint:CGPointMake(yAxisWidth - arrowYOffset, yAxisWidth + arrowXOffset)];
        [yAxisBezier addLineToPoint:CGPointMake(yAxisWidth, chartTopPadding)];
        [yAxisBezier addLineToPoint:CGPointMake(yAxisWidth + arrowYOffset, chartTopPadding + arrowXOffset)];
        [yAxisBezier closePath];
    }
    
    UIGraphicsBeginImageContext(yAxisLayer.frame.size);
    [yAxisBezier stroke];
    UIGraphicsEndImageContext();
    yAxisLayer.path = yAxisBezier.CGPath;
    [self.layer addSublayer:yAxisLayer];
}

- (void)drawXAxis
{
    xAxisLayer = [CAShapeLayer layer];
    xAxisLayer.frame = CGRectMake(0, 0, self.width, self.height);
    xAxisLayer.lineWidth = yAxisLineWidth;
    xAxisLayer.masksToBounds = YES;
    xAxisLayer.strokeColor = axisColor.CGColor;
    xAxisLayer.fillColor = [UIColor clearColor].CGColor;
    xAxisLayer.lineCap = kCALineCapButt;
    
    UIBezierPath *xAxisBezier = [UIBezierPath bezierPath];
    [xAxisBezier moveToPoint:CGPointMake(chartLeftPadding, self.height - chartBottomPadding)];
    [xAxisBezier addLineToPoint:CGPointMake(self.width - xAxisLayer.lineWidth/2.0, self.height - yAxisWidth)];
    
    if (hasArrow) {
        [xAxisBezier moveToPoint:CGPointMake(self.width - xAxisLayer.lineWidth/2.0 - arrowXOffset, self.height - yAxisWidth - arrowYOffset)];
        [xAxisBezier addLineToPoint:CGPointMake(self.width - xAxisLayer.lineWidth/2.0, self.height - chartTopPadding)];
        [xAxisBezier addLineToPoint:CGPointMake(self.width - xAxisLayer.lineWidth/2.0 - arrowXOffset, self.height - yAxisWidth + arrowYOffset)];
    }
   
    [xAxisBezier closePath];
    
    UIGraphicsBeginImageContext(xAxisLayer.frame.size);
    [xAxisBezier stroke];
    UIGraphicsEndImageContext();
    xAxisLayer.path = xAxisBezier.CGPath;
    [self.layer addSublayer:xAxisLayer];
}

- (void)reloadData
{
    @autoreleasepool {
        if (_dataSource) {
            
            if ([_dataSource respondsToSelector:@selector(axisColorOfWaveChart:)]) {
                axisColor = [_dataSource axisColorOfWaveChart:self];
                xAxisLayer.strokeColor = axisColor.CGColor;
                yAxisLayer.strokeColor = axisColor.CGColor;
            }
            
            NSUInteger pointCount = [_dataSource numbersOfWaveChart:self];
            
            for (NSUInteger index = 0; index<pointCount; index++) {
                CGFloat value = [_dataSource waveChart:self valueOfIndex:index];
                [values addObject:[NSNumber numberWithFloat:value]];
            }
            
            //计算最大值、最小值， 并留出0.1的范围
            CGFloat minValue = [MyTools getMinValueFromArray:values];
            CGFloat maxValue = [MyTools getMaxValueFromArray:values];
            minValue -= (maxValue - minValue) * 0.1;
            maxValue += (maxValue - minValue) * 0.1;
            
            //计算图表区域的高度
            CGFloat valueMaxHeight = self.height - chartTopPadding - chartBottomPadding - chartTopPadding *0.5;
            //计算value每份对应的高度
            CGFloat valuePerHeight =  valueMaxHeight/(maxValue - minValue == 0?1:(maxValue - minValue));
            //设置Y轴分段线数量
            sectionCount = 5;//默认设为5
            if ([_dataSource respondsToSelector: @selector(numbersOfYAxisSection:)]) {
                sectionCount = [_dataSource numbersOfYAxisSection:self];
            }
            //画Y轴上的分段值以及单位、格栅线
            CGPoint startPoint = CGPointMake(yAxisLayer.lineWidth/2.0 + chartLeftPadding, self.height - chartBottomPadding - yAxisLayer.lineWidth/2.0);
            [self drawYAxisGridAndUnitWithStartPoint:startPoint maxHeight:valueMaxHeight maxValue:maxValue minValue:minValue];
            
            //确定X轴上的区段宽度
            xSectionWidth = (xAxisLayer.frame.size.width - chartLeftPadding  - chartRightPadding - chartRightPadding/2.0)/(pointCount -1);
            
            for (NSUInteger index = 0; index<pointCount; index++) {
                //计算折线上的点
                CGPoint point = CGPointMake(xSectionWidth*index + chartLeftPadding,self.height - chartBottomPadding - valuePerHeight*([values[index]floatValue] - minValue));
                [points addObject:[NSValue valueWithCGPoint:point]];
                
                NSString *text = @"";
                if ([_dataSource respondsToSelector:@selector(waveChart:titleOfValuesOfIndex:)]) {
                    text = [_dataSource waveChart:self titleOfValuesOfIndex:index];
                    [valueTitles addObject:text];
                }
            }
            
            //画X轴上的区段文字
            [self drawXAxisTitleWithPoints:points titles:valueTitles];
            
            // 布置图表图层以及对应的动画
            [self settingChartLayerAndAnimate];
            
            //设置图表标题
            [self settingChartTitle];
        }
    }
}


/// 设置表格标题
- (void)settingChartTitle {
    CATextLayer *xUnitTextLayer = [CATextLayer layer];
    xUnitTextLayer.contentsScale = [UIScreen mainScreen].scale;
    xUnitTextLayer.font = CGFontCreateWithFontName((__bridge CFStringRef)[[UIFont systemFontOfSize:xAxisStrFontSize]fontName]);
    xUnitTextLayer.alignmentMode = kCAAlignmentCenter;
    xUnitTextLayer.backgroundColor = [UIColor clearColor].CGColor;
    NSString *xUnitText = @"";
    if ([_dataSource respondsToSelector:@selector(xAxisUnitOfWaveChart:)]) {
       xUnitText = [_dataSource xAxisUnitOfWaveChart:self];
    }
    CGFloat unitTextWith = [MyTools getAttributedStringWidthWithText:xUnitText andHeight:30 andFont:[UIFont systemFontOfSize:xAxisStrFontSize]];
    xUnitTextLayer.frame = CGRectMake(0, 0, unitTextWith, 30);
    xUnitTextLayer.position = CGPointMake(self.width - chartRightPadding - unitTextWith/2.0 , self.height);
    NSMutableAttributedString *xUnitAttri = [[NSMutableAttributedString alloc]initWithString:xUnitText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:xAxisStrFontSize],NSForegroundColorAttributeName:axisColor}];
    xUnitTextLayer.string = xUnitAttri;
    [self.layer addSublayer:xUnitTextLayer];
}

/// 布置图表图层以及对应的动画
- (void)settingChartLayerAndAnimate {
    UIColor *fillColor = [UIColor colorWithRed:0.507 green:0.445 blue:0.956 alpha:0.8];
    if ([_dataSource respondsToSelector:@selector(fillColorOfWaveChart:)]) {
        fillColor = [_dataSource fillColorOfWaveChart:self];
    }
    
    WaveChartLayer *WaveChartLayer_fill = [WaveChartLayer layer];
    WaveChartLayer_fill.type = WaveChartFill;
    WaveChartLayer_fill.lineCap = kCALineCapRound;
    WaveChartLayer_fill.lineWidth = 2.f;
    WaveChartLayer_fill.fillColor = fillColor.CGColor;
    WaveChartLayer_fill.strokeColor = [UIColor clearColor].CGColor;
    WaveChartLayer_fill.lineJoin = kCALineJoinRound;
    WaveChartLayer_fill.frame = CGRectMake(0, 0, xAxisLayer.frame.size.width, self.height - chartBottomPadding);
    WaveChartLayer_fill.dataSource = self;
    if (hasFill) {
        [xAxisLayer addSublayer:WaveChartLayer_fill];
    }
    [WaveChartLayer_fill setNeedsDisplay];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, xAxisLayer.frame.size.width, self.height);
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    if (hasGradiant) {
        gradient.mask = WaveChartLayer_fill;
    }
    gradient.colors = @[(__bridge id)fillColor.CGColor,(__bridge id)[UIColor colorWithRed:0.507 green:0.445 blue:0.956 alpha:0.].CGColor];
    if (hasGradiant) {
        [xAxisLayer addSublayer:gradient];
    }
    
    UIBezierPath *beizer_animate = [UIBezierPath bezierPath];
    CGPoint firstPoint = [[points firstObject] CGPointValue];
    CGPoint endPoint = [[points lastObject] CGPointValue];
    CGPoint animateStartPoint = CGPointMake(firstPoint.x, self.height - chartBottomPadding);
    [beizer_animate moveToPoint:animateStartPoint];
    [beizer_animate addLineToPoint:firstPoint];
    for (NSNumber *oject in points) {
        CGPoint point = [oject CGPointValue];
        [beizer_animate addLineToPoint:CGPointMake(point.x, self.height  - chartBottomPadding - xAxisLineWidth)];
    }
    
    CGPoint animateEndPoint = CGPointMake(endPoint.x - WaveChartLayer_fill.lineWidth/2.0, self.height - chartBottomPadding);
    [beizer_animate addLineToPoint:animateEndPoint];
    UIGraphicsBeginImageContext(WaveChartLayer_fill.frame.size);
    [beizer_animate fill];
    UIGraphicsEndImageContext();
    
    UIColor *lineColor = [UIColor orangeColor];
    if ([_dataSource respondsToSelector:@selector(lineColorOfWaveChart:)]) {
        lineColor = [_dataSource lineColorOfWaveChart:self];
    }
    
    WaveChartLayer *WaveChartLayer_stroke = [WaveChartLayer layer];
    WaveChartLayer_stroke.type = WaveChartStroke;
    WaveChartLayer_stroke.lineCap = kCALineCapRound;
    WaveChartLayer_stroke.lineWidth = 2.f;
    if ([_dataSource respondsToSelector:@selector(strokeLineWidthOfWaveChart:)]) {
        WaveChartLayer_stroke.lineWidth = [_dataSource strokeLineWidthOfWaveChart:self];
    }
    WaveChartLayer_stroke.fillColor = [UIColor clearColor].CGColor;
    WaveChartLayer_stroke.strokeColor = lineColor.CGColor;
    WaveChartLayer_stroke.lineJoin = kCALineJoinRound;
    WaveChartLayer_stroke.frame = CGRectMake(0, 0, xAxisLayer.frame.size.width - chartRightPadding - chartRightPadding/2.0, self.height - chartBottomPadding);
    WaveChartLayer_stroke.dataSource = self;
    if ([_dataSource respondsToSelector:@selector(showWithAnimateOfWaveChart:)]) {
        if([_dataSource showWithAnimateOfWaveChart:self]) {
            WaveChartLayer_stroke.strokeEnd = 0.f;
        } else {
            WaveChartLayer_stroke.strokeEnd = 1.f;
        }
    }
    if (hasStroke) {
        [xAxisLayer addSublayer:WaveChartLayer_stroke];
    }
    [WaveChartLayer_stroke setNeedsDisplay];
    
    
    WaveChartLayer *WaveChartLayer_point = [WaveChartLayer layer];
    WaveChartLayer_point.type = WaveChartPoint;
    WaveChartLayer_point.lineCap = kCALineCapRound;
    WaveChartLayer_point.lineWidth = 2.f;
    WaveChartLayer_point.fillColor = lineColor.CGColor;
    WaveChartLayer_point.strokeColor = [UIColor clearColor].CGColor;
    WaveChartLayer_point.lineJoin = kCALineJoinRound;
    WaveChartLayer_point.frame = CGRectMake(0, 0, xAxisLayer.frame.size.width - chartRightPadding - chartRightPadding/2.0, self.height - chartBottomPadding);
    if ([_dataSource respondsToSelector:@selector(showWithAnimateOfWaveChart:)]) {
        if([_dataSource showWithAnimateOfWaveChart:self]) {
            WaveChartLayer_point.opacity = 0.f;
        } else {
            WaveChartLayer_point.opacity = 1.f;
        }
    }
    WaveChartLayer_point.dataSource = self;
    if (hasPoint) {
        [xAxisLayer addSublayer:WaveChartLayer_point];
    }
    
    [WaveChartLayer_point setNeedsDisplay];
    
    CABasicAnimation *animate_opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animate_opacity.fromValue = @(0.f);
    animate_opacity.toValue = @(1.f);
    animate_opacity.duration = pointAnimateTime;
    animate_opacity.fillMode = kCAFillModeForwards;
    animate_opacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animate_opacity.removedOnCompletion = NO;
    animate_opacity.delegate = self;
    [animate_opacity setValue:@"animate_opacity" forKey:@"animateName"];
    
    
    CABasicAnimation *animate_stroke = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animate_stroke.fromValue = @(0.0);
    animate_stroke.toValue = @(1.0);
    animate_stroke.duration = strokeAnimateTime;
    animate_stroke.removedOnCompletion = NO;
    animate_stroke.fillMode = kCAFillModeForwards;
    animate_stroke.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animate_stroke.delegate = self;
    [animate_stroke setValue:@"animate_stroke" forKey:@"animateName"];
    [animate_stroke setValue:animate_opacity forKey:@"nextAnimate"];
    [animate_stroke setValue:WaveChartLayer_point forKey:@"animateLayer"];
    
    
    CABasicAnimation *animate_path = [CABasicAnimation animationWithKeyPath:@"path"];
    animate_path.fromValue = (id)beizer_animate.CGPath;
    animate_path.toValue  = (id)WaveChartLayer_fill.path;
    animate_path.duration = fillAnimateTime;
    animate_path.fillMode = kCAFillModeForwards;
    animate_path.removedOnCompletion = NO;
    animate_path.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animate_path.delegate = self;
    [animate_path setValue:@"animate_path" forKey:@"animateName"];
    [animate_path setValue:animate_stroke forKey:@"nextAnimate"];
    [animate_path setValue:WaveChartLayer_stroke forKey:@"animateLayer"];
    
    BOOL isAnimate = YES;
    if ([_dataSource respondsToSelector:@selector(showWithAnimateOfWaveChart:)]) {
        isAnimate = [_dataSource showWithAnimateOfWaveChart:self];
    }
    if (isAnimate) [WaveChartLayer_fill addAnimation:animate_path forKey:@"path"];
}


/// 画Y轴上的格栅线、单位、分段数值
/// @param startPoint 起始点
/// @param valueMaxHeight 最大值分的的对应高度
/// @param maxValue 最大值
/// @param minValue 最小值
- (void)drawYAxisGridAndUnitWithStartPoint:(CGPoint)startPoint
                                 maxHeight:(CGFloat)valueMaxHeight
                                  maxValue:(CGFloat)maxValue
                                  minValue:(CGFloat)minValue {
    CGFloat sectionHeight = valueMaxHeight/sectionCount;
    CGFloat ySectionValue = (maxValue - minValue)/sectionCount;
    NSLog(@"minValue: %.2f, maxValue: %.2f ySectionValue: %.2f",minValue, maxValue, ySectionValue);
    for (NSUInteger index = 1; index <= sectionCount; index++) {
        
        UIBezierPath *gridBezier = [UIBezierPath bezierPath];
        [gridBezier moveToPoint:CGPointMake(startPoint.x, startPoint.y - sectionHeight * index)];
        [gridBezier addLineToPoint:CGPointMake(xAxisLayer.frame.size.width - chartRightPadding - chartRightPadding/2.0, startPoint.y - sectionHeight * index)];
        CAShapeLayer *gridLayer = [CAShapeLayer layer];
        gridLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        gridLayer.fillColor = [UIColor clearColor].CGColor;
        gridLayer.lineWidth = 0.3;
        UIGraphicsBeginImageContext(xAxisLayer.frame.size);
        [gridBezier stroke];
        UIGraphicsEndImageContext();
        gridLayer.path = gridBezier.CGPath;
        [xAxisLayer addSublayer:gridLayer];
        
    }
    
    for (NSUInteger index = 0; index<= sectionCount; index++) {
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.font = CGFontCreateWithFontName((__bridge CFStringRef)[[UIFont systemFontOfSize:yAxisStrFontSize]fontName]);
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.backgroundColor = [UIColor clearColor].CGColor;
        textLayer.frame = CGRectMake(0, 0, yAxisWidth, 20);
        textLayer.position = CGPointMake(yAxisWidth/2.0, self.height - chartBottomPadding - sectionHeight*(index));
        NSString *text = [NSString stringWithFormat:@"%.00f",minValue + ySectionValue*index];
        UIColor *ySectionDataColor = [UIColor redColor];
        NSMutableAttributedString *textAttri = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:yAxisStrFontSize],NSForegroundColorAttributeName:ySectionDataColor}];
        textLayer.string = textAttri;
        [yAxisLayer addSublayer:textLayer];
    }
    //画Y轴上的单位
    CATextLayer *unitTextLayer = [CATextLayer layer];
    unitTextLayer.contentsScale = [UIScreen mainScreen].scale;
    unitTextLayer.font = CGFontCreateWithFontName((__bridge CFStringRef)[[UIFont systemFontOfSize:yAxisStrFontSize]fontName]);
    unitTextLayer.alignmentMode = kCAAlignmentCenter;
    unitTextLayer.backgroundColor = [UIColor clearColor].CGColor;

    NSString *unitText = @"";
    if ([_dataSource respondsToSelector:@selector(yAxisUnitOfWaveChart:)]) {
        unitText = [_dataSource yAxisUnitOfWaveChart:self];
    }
    CGFloat unitWidth = [MyTools getAttributedStringWidthWithText:unitText andHeight:30 andFont:[UIFont systemFontOfSize:yAxisStrFontSize]];
    CGFloat suitSize = yAxisStrFontSize;
    if (unitWidth > chartLeftPadding) {
       suitSize = [MyTools getStringSuitableSizeWithMaxWidth:chartLeftPadding fixHeight:30 str:unitText beginSize:suitSize];
    }
    unitTextLayer.frame = CGRectMake(0, 0, chartLeftPadding, 30);
    unitTextLayer.position = CGPointMake(chartLeftPadding/2.0, chartLeftPadding/2.0);
    NSMutableAttributedString *unitTextAttri = [[NSMutableAttributedString alloc]initWithString:unitText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:suitSize],NSForegroundColorAttributeName:axisColor}];
    unitTextLayer.string = unitTextAttri;
    [yAxisLayer addSublayer:unitTextLayer];
}

/**
 当捏合手势作用的时候刷新折线图上点的位置
 */
- (void) refreshPolyLinePointsPosition
{
    @autoreleasepool {
        NSMutableArray *tempArray = points.mutableCopy;
        [points removeAllObjects];
        CGPoint pinchInChartPoint = CGPointMake(pinchPos.x - xAxisLayer.frame.origin.x, pinchPos.y - xAxisLayer.frame.origin.y);
        CGPoint firsPoint = [[tempArray firstObject] CGPointValue];
        CGPoint endPoint = [[tempArray lastObject] CGPointValue];
        CGFloat xDistanceLeftMax = (pinchInChartPoint.x - firsPoint.x)*pinchScale;
        CGFloat xDistanceRightMax = (endPoint.x - pinchInChartPoint.x)*pinchScale;
        
        CGPoint zeroPoint = pinchInChartPoint;
        
        BOOL isLeftBeyond = NO;
        BOOL isRightBeyond = NO;
        //判断左边是否会越界
        if (xDistanceLeftMax< pinchInChartPoint.x - chartLeftPadding) {
            isLeftBeyond = YES;
        } else {
            isLeftBeyond = NO;
        }
        //判断右边是否会越界
        if(xDistanceRightMax< xAxisLayer.frame.size.width - chartRightPadding/2.0 - chartRightPadding - pinchInChartPoint.x)
        {
            isRightBeyond = YES;
        }else {
            isRightBeyond = NO;
        }
        
        if (!isLeftBeyond && !isRightBeyond) {
            zeroPoint = pinchInChartPoint;
        }else if (isLeftBeyond && !isRightBeyond) {
            zeroPoint = CGPointMake(chartLeftPadding, firsPoint.y);
        }else if (!isLeftBeyond && isRightBeyond){
            zeroPoint = CGPointMake(self.xAxisLayer.frame.size.width -chartRightPadding - chartRightPadding/2.0, endPoint.y);
        }else {
            zeroPoint = pinchInChartPoint;
        }
        
        
        for (NSUInteger index = 0; index<tempArray.count; index ++) {
            CGPoint point = [[tempArray objectAtIndex:index] CGPointValue];
            
            if (point.x<zeroPoint.x) {
                CGFloat pointDistanceX = zeroPoint.x - point.x;
                if (zeroPoint.x - pointDistanceX * pinchScale >=  index * xSectionWidth + chartLeftPadding) {
                    point.x = index * xSectionWidth + chartLeftPadding;
                }else{
                    point.x = zeroPoint.x - pointDistanceX * pinchScale;
                }
            } else {
                CGFloat pointDitanceX = point.x - zeroPoint.x;
                if (zeroPoint.x + pointDitanceX * pinchScale <= index * xSectionWidth + chartLeftPadding) {
                    point.x = index * xSectionWidth + chartLeftPadding;
                } else {
                    point.x = zeroPoint.x + pointDitanceX * pinchScale;
                }
            }
            [points addObject:[NSValue valueWithCGPoint:point]];
        }
        
        for (id layer in xAxisLayer.sublayers) {
            if ([layer isKindOfClass:[WaveChartLayer class]]) {
                [layer setNeedsDisplay];
            }
            else if ([layer isKindOfClass:[CAGradientLayer class]]) {
                CAGradientLayer *grad = (CAGradientLayer *)layer;
                [grad.mask setNeedsDisplay];
            }
        }
        [self drawXAxisTitleWithPoints:points titles:valueTitles];
    }
}


/**
 当拖动手势作用的时候刷新折线图上点的位置
 */
- (void)refreshPolyLinePointPositionWithPanGes
{
    @autoreleasepool {
        NSMutableArray *tempArray = points.mutableCopy;
    //    [points removeAllObjects];
        CGPoint firsPoint = [[tempArray firstObject] CGPointValue];
        CGPoint endPoint = [[tempArray lastObject] CGPointValue];
        //先判断是否能移动
        if ((firsPoint.x == chartLeftPadding || firsPoint.x == chartLeftPadding + yAxisLineWidth/2.0) &&(endPoint.x == self.width - chartRightPadding - chartRightPadding/2.0) ) {
            return;
        }
        
        [points removeAllObjects];
        CGFloat moveDistance = panDistanceX;

        if (panDistanceX > 0) {//向右拖动
            if(firsPoint.x + panDistanceX>=chartLeftPadding)
            {
                moveDistance = chartLeftPadding - firsPoint.x;
            }
            else
            {
                moveDistance = panDistanceX;
            }
        }
        else//向左拖动
        {
            if (endPoint.x + panDistanceX <= (tempArray.count -1)* xSectionWidth + chartLeftPadding) {
                moveDistance = (tempArray.count -1) * xSectionWidth + chartLeftPadding - endPoint.x;
            }
            else
            {
                moveDistance = panDistanceX;
            }
        }
        
        for (NSUInteger index = 0; index< tempArray.count; index ++) {
            CGPoint point = [[tempArray objectAtIndex:index] CGPointValue];
            point.x += moveDistance;
            [points addObject:[NSValue valueWithCGPoint:point]];
        }
        
        for (id layer in xAxisLayer.sublayers) {
            if ([layer isKindOfClass:[WaveChartLayer class]]) {
                [layer setNeedsDisplay];
            }
            else if ([layer isKindOfClass:[CAGradientLayer class]]) {
                CAGradientLayer *grad = (CAGradientLayer *)layer;
                [grad.mask setNeedsDisplay];
            }
        }
        
        [self drawXAxisTitleWithPoints:points titles:valueTitles];
    }

}

- (void)drawXAxisTitleWithPoints:(NSArray *)pointArray titles:(NSArray *)titleArray
{
    NSMutableArray *ctextLayers = @[].mutableCopy;
    for (id layer in xAxisLayer.sublayers) {
        if ([layer isKindOfClass:[CATextLayer class]]) {
            [ctextLayers addObject:layer];
        }
    }
    
    for (CATextLayer * layer in ctextLayers) {
        [layer removeFromSuperlayer];
    }
    
    CGPoint p0 = [[pointArray objectAtIndex:0] CGPointValue];
    CGPoint p1 = [[pointArray objectAtIndex:1] CGPointValue];
    CGFloat pointsGap = p1.x - p0.x;
    
    CGFloat sectionWidth = [MyTools getMaxTitleWidthFromArray:titleArray withFontSize:xAxisStrFontSize] + 16;
    CGFloat temp_f = sectionWidth/pointsGap;
    
    NSUInteger temp = (NSUInteger)sectionWidth/pointsGap;
    if (temp_f>temp) {
        temp += 1;
    }
    __block NSMutableArray *drawPoints = @[].mutableCopy;
    __block NSMutableArray *drawTitles = @[].mutableCopy;
    [points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx%temp == 0) {
            [drawPoints addObject:obj];
            [drawTitles addObject:[titleArray objectAtIndex:idx]];
        }
    }];
    
    //重绘X轴
    CGPoint firstPoint = [[points firstObject] CGPointValue];
    CGPoint lastPoint = [[points lastObject] CGPointValue];
    
    UIBezierPath *xAxisBezier = [UIBezierPath bezierPath];
    [xAxisBezier moveToPoint:CGPointMake(firstPoint.x, self.height - chartBottomPadding)];
    [xAxisBezier addLineToPoint:CGPointMake(lastPoint.x + chartRightPadding/2- xAxisLayer.lineWidth/2.0, self.height - chartBottomPadding)];
    if (hasArrow) {
        [xAxisBezier moveToPoint:CGPointMake(lastPoint.x + chartRightPadding/2- xAxisLayer.lineWidth/2.0 - arrowXOffset, self.height - chartBottomPadding - arrowYOffset)];
        [xAxisBezier addLineToPoint:CGPointMake(lastPoint.x + chartRightPadding/2- xAxisLayer.lineWidth/2.0, self.height - chartBottomPadding)];
        [xAxisBezier addLineToPoint:CGPointMake(lastPoint.x + chartRightPadding/2- xAxisLayer.lineWidth/2.0 - arrowXOffset, self.height - chartBottomPadding + arrowYOffset)];
    }
    [xAxisBezier closePath];
    
    UIGraphicsBeginImageContext(xAxisLayer.frame.size);
    [xAxisBezier stroke];
    UIGraphicsEndImageContext();
    xAxisLayer.path = xAxisBezier.CGPath;
    
    UIColor *xTitleColor = [UIColor redColor];
    if ([_dataSource respondsToSelector:@selector(xAxisTextColorOfWaveChart:)]) {
        xTitleColor = [_dataSource xAxisTextColorOfWaveChart:self];
    }
    //计算合适的字号
    CGFloat xTextMaxWidth = [MyTools getMaxTitleWidthFromArray:drawTitles withFont:[UIFont systemFontOfSize:xAxisStrFontSize] fixHeight:30];
    CGFloat suitFontSize = xAxisStrFontSize;
    if (xTextMaxWidth > sectionWidth) {
        suitFontSize = [MyTools getStringSuitableSizeWithMaxWidth:sectionWidth fixHeight:30 str:[MyTools getMaxStringWidthFromArray:drawTitles] beginSize:suitFontSize];
    }
    
    for (NSUInteger index = 0; index<drawPoints.count; index ++) {
        CGPoint point = [[drawPoints objectAtIndex:index] CGPointValue];
        
        //画X轴上的区段文字
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        CFStringRef strRef  = (__bridge CFStringRef)[[UIFont systemFontOfSize:xAxisStrFontSize]fontName];
        CGFontRef fontRef = CGFontCreateWithFontName(strRef);
        textLayer.font = fontRef;
        CFRelease(strRef);
        CGFontRelease(fontRef);
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.backgroundColor = [UIColor clearColor].CGColor;
        textLayer.frame = CGRectMake(0, 0, sectionWidth, 30);
        textLayer.position = CGPointMake(point.x, self.height - chartBottomPadding/2.0);
       
        NSMutableAttributedString *textAttri = [[NSMutableAttributedString alloc]initWithString:drawTitles[index] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:suitFontSize],NSForegroundColorAttributeName:xTitleColor}];
        textLayer.string = textAttri;
        [xAxisLayer addSublayer:textLayer];
    }
}

- (void)pinchGesAction:(UIPinchGestureRecognizer *)pinch
{
    if (!supportPinchGes) {
        return;
    }
    CGPoint p = [pinch locationInView:self];
    pinchPos = p;
    CGFloat scale = pinch.scale/self.currentScale;
    pinchScale = scale;
    switch (pinch.state) {
        case UIGestureRecognizerStateBegan:
        {
            currentScale = pinch.scale;
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            currentScale = pinch.scale;
            if (pinchScale != 1) [self refreshPolyLinePointsPosition];
            isMove = NO;
            [self.crossLineLayer setNeedsDisplay];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            isMove = NO;
            [self.crossLineLayer setNeedsDisplay];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            isMove = NO;
            [self.crossLineLayer setNeedsDisplay];
            
        }
            break;
            
        default:
            isMove = NO;
            [self.crossLineLayer setNeedsDisplay];
            break;
    }
    
}

- (void)panGesAction:(UIPanGestureRecognizer *)pan
{
    CGPoint p =[pan locationInView:self];
    if (!CGRectContainsPoint(CGRectMake(chartLeftPadding, chartTopPadding, self.width - chartRightPadding, self.height - chartTopPadding - chartBottomPadding), p)) {
        isMove = NO;
        [self.crossLineLayer setNeedsDisplay];
        return;
    }
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            isMove = YES;
            [self changeFingerPositionFromSelfViewToChartLayerWithLoction:p];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            panDistanceX = p.x - prevPosX;
            [self refreshPolyLinePointPositionWithPanGes];
            isMove = YES;
            [self changeFingerPositionFromSelfViewToChartLayerWithLoction:p];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            isMove = NO;
            [self changeFingerPositionFromSelfViewToChartLayerWithLoction:p];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            isMove = NO;
            [self changeFingerPositionFromSelfViewToChartLayerWithLoction:p];
        }
            break;
            
        default:
            isMove = NO;
            break;
    }
    
    [self.crossLineLayer setNeedsDisplay];
    
    prevPosX = p.x;
    
}

- (void)doubleTapAction:(UITapGestureRecognizer *)tap {
    if (!([_dataSource respondsToSelector:@selector(supportFullScreenShowOfWaveChart:)] && [_dataSource supportFullScreenShowOfWaveChart:self])) {
        return;
    }
    FullScreenShowController *fullScreenVC = [FullScreenShowController new];
    fullScreenVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    fullScreenVC.hasBack = YES;
    [self.viewController presentViewController:fullScreenVC animated:NO completion:nil];
//    [self.viewController viewWillTransitionToSize:CGSizeMake(ScreenHeight, ScreenWidth) withTransitionCoordinator:fullScreenVC.transitionCoordinator];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint p = [[touches anyObject]locationInView:self];
    [self changeFingerPositionFromSelfViewToChartLayerWithLoction:p];
    if (!CGRectContainsPoint(CGRectMake(yAxisWidth, chartTopPadding, self.width - yAxisWidth, self.height - chartTopPadding - chartBottomPadding), p)) {
        isMove = NO;
        [self.crossLineLayer setNeedsDisplay];
        return;
    }
    isMove = YES;
    [self.crossLineLayer setNeedsDisplay];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    CGPoint p = [[touches anyObject]locationInView:self];
    [self changeFingerPositionFromSelfViewToChartLayerWithLoction:p];
    if (!CGRectContainsPoint(CGRectMake(yAxisWidth, chartTopPadding, self.width - yAxisWidth, self.height - chartTopPadding - chartBottomPadding), p)) {
        isMove = NO;
        [self.crossLineLayer setNeedsDisplay];
        return;
    }
    [self.crossLineLayer setNeedsDisplay];
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    CGPoint p = [[touches anyObject]locationInView:self];
    [self changeFingerPositionFromSelfViewToChartLayerWithLoction:p];
    if (!CGRectContainsPoint(CGRectMake(yAxisWidth, chartTopPadding, self.width - yAxisWidth, self.height - chartTopPadding - chartBottomPadding), p)) {
        isMove = NO;
        [self.crossLineLayer setNeedsDisplay];
        return;
    }
    isMove = NO;
    [self.crossLineLayer setNeedsDisplay];
    
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    CGPoint p = [[touches anyObject]locationInView:self];
    [self changeFingerPositionFromSelfViewToChartLayerWithLoction:p];
    if (!CGRectContainsPoint(CGRectMake(yAxisWidth, chartTopPadding, self.width - yAxisWidth, self.height - chartTopPadding - chartBottomPadding), p)) {
        isMove = NO;
        [self.crossLineLayer setNeedsDisplay];
        return;
    }
    isMove = NO;
    [self.crossLineLayer setNeedsDisplay];
}


#pragma mark - WaveChartLayerDataSource
- (NSUInteger)numbersOfWaveChartPoints:(WaveChartLayer *)waveLayer
{
    return points.count;
}
- (CGPoint)waveChartLayer:(WaveChartLayer *)waveLayer pointOfIndex:(NSUInteger)index
{
    return [points[index] CGPointValue];
}

#pragma mark -CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim valueForKey:@"animateLayer"]) {
        WaveChartLayer *shape = (WaveChartLayer *)[anim valueForKey:@"animateLayer"];
        if ([anim valueForKey:@"nextAnimate"]) {
            CABasicAnimation *animate = [anim valueForKey:@"nextAnimate"];
            if ([anim valueForKey:@"animateName"]) {
                NSString *animateName = [anim valueForKey:@"animateName"];
                [shape addAnimation:animate forKey:animateName];
            }
            
        }
    }
    
}

- (CAShapeLayer *)crossLineLayer
{
    if (!_crossLineLayer) {
        _crossLineLayer = [CAShapeLayer layer];
        _crossLineLayer.frame = CGRectMake(0, chartTopPadding, xAxisLayer.frame.size.width, xAxisLayer.frame.size.height - chartBottomPadding - chartTopPadding);
        _crossLineLayer.fillColor = [UIColor clearColor].CGColor;
        _crossLineLayer.strokeColor = crossLineColor.CGColor;
        _crossLineLayer.lineWidth = 1.f;
        _crossLineLayer.lineDashPattern = @[@(6),@(5)];
        _crossLineLayer.lineDashPhase = 0;
        
        NSDictionary *dic = [self getPointNearThefingerLocation];
        CGPoint crossPoint = [dic[@"point"]CGPointValue];
        NSUInteger index = [dic[@"index"]unsignedIntegerValue];
        
        UIBezierPath *crossBezier = [UIBezierPath bezierPath];
        [crossBezier moveToPoint:CGPointMake(0, crossPoint.y)];
        [crossBezier addLineToPoint:CGPointMake(xAxisLayer.frame.size.width, crossPoint.y)];
        [crossBezier moveToPoint:CGPointMake(crossPoint.x, 0)];
        [crossBezier addLineToPoint:CGPointMake(crossPoint.x, xAxisLayer.frame.size.height - chartBottomPadding - chartTopPadding)];
        UIGraphicsBeginImageContext(_crossLineLayer.frame.size);
        [crossBezier stroke];
        UIGraphicsEndImageContext();
        _crossLineLayer.path = crossBezier.CGPath;
        [xAxisLayer addSublayer:_crossLineLayer];
        
        CAShapeLayer *circleShape = [CAShapeLayer layer];
        circleShape.frame = _crossLineLayer.bounds;
        circleShape.fillColor = crossLineColor.CGColor;
        circleShape.strokeColor = [UIColor clearColor].CGColor;
        
        UIBezierPath *circleBezier = [UIBezierPath bezierPath];
        [circleBezier moveToPoint:crossPoint];
        [circleBezier addArcWithCenter:crossPoint radius:2.5f startAngle:0 endAngle:M_PI*2 clockwise:YES];
        UIGraphicsBeginImageContext(_crossLineLayer.frame.size);
        [circleBezier fill];
        UIGraphicsEndImageContext();
        circleShape.path = circleBezier.CGPath;
        [_crossLineLayer addSublayer:circleShape];
        _crossLineLayer.hidden = !isMove;
        
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        CFStringRef strRef  = (__bridge CFStringRef)[[UIFont systemFontOfSize:13]fontName];
        CGFontRef fontRef = CGFontCreateWithFontName(strRef);
        textLayer.font = fontRef;
        CFRelease(strRef);
        CGFontRelease(fontRef);
        textLayer.alignmentMode = kCAAlignmentLeft;
        
        NSString *text = [NSString stringWithFormat:@"%@: %@\n%@: %.2f",[_dataSource xAxisUnitOfWaveChart:self],[_dataSource waveChart:self titleOfValuesOfIndex:index],[_dataSource yAxisUnitOfWaveChart:self],[_dataSource waveChart:self valueOfIndex:index]];
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
        //计算悬浮展示框的position
        CGPoint point = CGPointZero;
        if (fingerLoc.x  < xAxisLayer.frame.size.width/2.0) {
            point.x = fingerLoc.x + size.width/2.0 + 30;
        }
        else
        {
            point.x = fingerLoc.x - size.width/2.0 - 30;
        }
        if (fingerLoc.y > self.height/2.0 ) {
            point.y = fingerLoc.y - size.height/2.0 - 30;
        }
        else
        {
            point.y = fingerLoc.y + size.height/2.0 + 30;
        }
        
        textLayer.backgroundColor = [UIColor clearColor].CGColor;
        textLayer.frame = CGRectMake(0, 0, size.width, size.height);
        textLayer.position = point;
        UIColor *xTitleColor = [UIColor redColor];
        
        NSMutableAttributedString *textAttri = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0],NSForegroundColorAttributeName:xTitleColor}];
        textLayer.string = textAttri;
        [_crossLineLayer addSublayer:textLayer];
    }
    else
    {
        
        NSDictionary *dic = [self getPointNearThefingerLocation];
        CGPoint crossPoint = [dic[@"point"]CGPointValue];
        NSUInteger index = [dic[@"index"]unsignedIntegerValue];
        
        UIBezierPath *crossBezier = [UIBezierPath bezierPath];
        [crossBezier moveToPoint:CGPointMake(0, crossPoint.y)];
        [crossBezier addLineToPoint:CGPointMake(xAxisLayer.frame.size.width, crossPoint.y)];
        [crossBezier moveToPoint:CGPointMake(crossPoint.x, 0)];
        [crossBezier addLineToPoint:CGPointMake(crossPoint.x, xAxisLayer.frame.size.height - chartBottomPadding - chartTopPadding)];
        UIGraphicsBeginImageContext(_crossLineLayer.frame.size);
        [crossBezier stroke];
        UIGraphicsEndImageContext();
        _crossLineLayer.path = crossBezier.CGPath;
        
        CAShapeLayer *circleShape = nil;
        CATextLayer *textLayer = nil;
        for (id objc in _crossLineLayer.sublayers) {
            if ([objc isKindOfClass:[CAShapeLayer class]]) {
                circleShape = objc;
            }
            if ([objc isKindOfClass:[CATextLayer class]]) {
                textLayer = objc;
            }
        }
        
        UIBezierPath *circleBezier = [UIBezierPath bezierPath];
        [circleBezier moveToPoint:crossPoint];
        [circleBezier addArcWithCenter:crossPoint radius:2.5f startAngle:0 endAngle:M_PI*2 clockwise:YES];
        UIGraphicsBeginImageContext(_crossLineLayer.frame.size);
        [circleBezier fill];
        UIGraphicsEndImageContext();
        circleShape.path = circleBezier.CGPath;
        
        NSString *text = [NSString stringWithFormat:@"%@: %@\n%@: %.2f",[_dataSource xAxisUnitOfWaveChart:self],[_dataSource waveChart:self titleOfValuesOfIndex:index],[_dataSource yAxisUnitOfWaveChart:self],[_dataSource waveChart:self valueOfIndex:index]];
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:floatShowTextFontSize]}];
        
        //计算悬浮展示框的position
        CGPoint point = CGPointZero;
        if (fingerLoc.x  < xAxisLayer.frame.size.width/2.0) {
            point.x = fingerLoc.x + size.width/2.0 + 50;
        }
        else
        {
            point.x = fingerLoc.x - size.width/2.0 - 50;
        }
        if (fingerLoc.y > self.height/2.0 ) {
            point.y = fingerLoc.y - size.height/2.0 - 30;
        }
        else
        {
            point.y = fingerLoc.y + size.height/2.0 + 30;
        }
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setAnimationDuration:0.01];
        textLayer.frame = CGRectMake(0, 0, size.width, size.height);
        textLayer.position = point;
        UIColor *xTitleColor = [UIColor redColor];
        NSMutableAttributedString *textAttri = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:floatShowTextFontSize],NSForegroundColorAttributeName:xTitleColor}];
        textLayer.string = textAttri;
        
        
        _crossLineLayer.hidden = !isMove;
        [CATransaction setDisableActions:NO];
        [CATransaction commit];
        
        
    }
    return _crossLineLayer;
}


- (void)changeFingerPositionFromSelfViewToChartLayerWithLoction:(CGPoint)location
{
    fingerLoc = CGPointMake(location.x, location.y - chartBottomPadding);
}


- (NSDictionary *)getPointNearThefingerLocation
{
    
    CGPoint indexPoint = CGPointZero;
    NSUInteger index_point = 0;
    for (NSUInteger index=0; index < points.count-1; index++) {
        CGPoint point = [[points objectAtIndex:index] CGPointValue];
        CGPoint nextP = [[points objectAtIndex:index + 1] CGPointValue];
        if (fabs(fingerLoc.x - point.x) < nextP.x - point.x) {
            if (fabs(fingerLoc.x - point.x)<fabs(fingerLoc.x - nextP.x)) {
                indexPoint = CGPointMake(point.x, point.y - chartBottomPadding);
                index_point = index;
            }
            else if (fabs(fingerLoc.x - point.x)>fabs(fingerLoc.x - nextP.x))
            {
                indexPoint = CGPointMake(nextP.x, nextP.y - chartBottomPadding);
                index_point = index+1;
            }
            break;
        }
    }
    NSDictionary *dic = @{@"point":[NSValue valueWithCGPoint:indexPoint],@"index":@(index_point)};
    
    return dic;
}



@end
