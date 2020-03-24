//
//  LCPieChart.m
//  iOS_Chart
//
//  Created by KC on 2017/7/19.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "LCPieChart.h"

@interface PieceLayer : CAShapeLayer
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) CGFloat percentage;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy) NSString *text;

- (void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate;
@end


@implementation PieceLayer

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"startAngle"] || [key isEqualToString:@"endAngle"]) {
        return YES;
    }
    else {
        return [super needsDisplayForKey:key];
    }
}


- (instancetype)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        if ([layer isKindOfClass:[PieceLayer class]]) {
            self.startAngle = [(PieceLayer *)layer startAngle];
            self.endAngle = [(PieceLayer *)layer endAngle];
        }
        
    }
    return self;
}

- (void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate
{
    CABasicAnimation *arcAnimate = [CABasicAnimation animationWithKeyPath:key];
    arcAnimate.fromValue = from;
    arcAnimate.toValue = to;
    arcAnimate.delegate = delegate;
    arcAnimate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [self addAnimation:arcAnimate forKey:key];
    [self setValue:to forKey:key];
}

@end


@interface LCPieChart()<CAAnimationDelegate>
@property(nonatomic, strong)NSMutableArray *pielayers;
@property(nonatomic, strong)NSTimer *myTimer;

@end

@implementation LCPieChart



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame radius:(CGFloat)redius center:(CGPoint)center
{
    self = [self initWithFrame:frame];
    if (self) {
        self.pieCenter = center;
        self.pieRadius = redius;
    }
    return self;
}

- (void)setUpView
{
    _pielayers = [NSMutableArray array];
}


- (void)reloadData
{
    if (self.pielayers.count) {
        [_pielayers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PieceLayer *layer = (PieceLayer *)obj;
            [layer removeFromSuperlayer];
        }];
        [self.pielayers removeAllObjects];
    }
    if (_dataSource) {
        
		//获取饼要分成几份
        NSUInteger pieCount = [_dataSource numbersOfPieceInPieChart:self];
        
        //初始化保存value总值和具体值的数组
        double sum = 0;
        double values[pieCount];
        for (NSInteger index = 0; index < pieCount; index ++) {
            values[index] = [_dataSource pieChart:self valueFromPieceIndex:index];
            sum += values[index];
        }
        
        //计算各饼块分得的角度
        double angles[pieCount];
        for (NSInteger index = 0; index<pieCount; index ++) {
            double div;
            if (sum == 0) {
                div = 0;
            }
            else
            {
                div = values[index]/sum;
            }
            angles[index] = M_PI *2 * div;
        }
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:_animateDuration];
        [CATransaction setDisableActions:YES];
        
        CGFloat startFromAngle = M_PI_2 *3;
        CGFloat startToAngle = 0.0;
        CGFloat endToAngel = 0.0;
        
        if (sum == 0) {
            PieceLayer *layer = [PieceLayer layer];
            [layer createArcAnimationForKey:@"startAngle" fromValue:[NSNumber numberWithFloat:startFromAngle] toValue:[NSNumber numberWithFloat:M_PI_2*3 + M_PI *2] Delegate:self];
            [self.pielayers addObject:layer];
            return;
        }
        else
        {
            for (NSInteger index = 0; index<pieCount; index++) {
                startToAngle = startFromAngle + endToAngel;
                endToAngel += angles[index];
                CGFloat endAngle = startFromAngle + endToAngel;
                PieceLayer *layer = [PieceLayer layer];
                UIColor *color = nil;
                if (_dataSource && [_dataSource respondsToSelector:@selector(pieChart:colorOfPieceAtIndex:)]) {
                    color = [_dataSource pieChart:self colorOfPieceAtIndex:index];
                }
                else color = [UIColor colorWithHue:((index/8)%20)/20.0+0.02 saturation:(index%8+3)/10.0 brightness:91/100.0 alpha:1];
                if (_dataSource && [_dataSource respondsToSelector:@selector(pieChart:titleOfPieceAtIndex:)]) {
                    layer.text = [_dataSource pieChart:self titleOfPieceAtIndex:index];
                }

                layer.fillColor = color.CGColor;
                layer.strokeColor = [UIColor clearColor].CGColor;
                layer.color = color;
                layer.percentage = values[index]/sum * 100;
                
                [layer createArcAnimationForKey:@"startAngle" fromValue:[NSNumber numberWithFloat:startFromAngle] toValue:[NSNumber numberWithFloat:startToAngle] Delegate:self];
                [layer createArcAnimationForKey:@"endAngle" fromValue:[NSNumber numberWithFloat:startFromAngle] toValue:[NSNumber numberWithFloat:endAngle] Delegate:self];
                [self.layer addSublayer:layer];
                [self.pielayers addObject:layer];
                
            }
            
            
        }
        [CATransaction setDisableActions:NO];
        [CATransaction commit];
        
        
    }
}

- (void)updateTimerFire:(NSTimer *)timer
{
    
    [_pielayers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PieceLayer *layer = (PieceLayer *)obj;
        NSNumber *presentLayerStartAngle = [[layer presentationLayer]valueForKey:@"startAngle"];
        CGFloat startAngle = [presentLayerStartAngle doubleValue];
        
        NSNumber *presentLayerEndleAngle = [[layer presentationLayer]valueForKey:@"endAngle"];
        CGFloat endAngle = [presentLayerEndleAngle doubleValue];
        
        CGPathRef path = CGPathCreateArc(self.pieCenter, self.pieRadius, startAngle, endAngle);
        layer.path = path;
        CFRelease(path);


        
    }];
}


- (void)animationDidStart:(CAAnimation *)anim
{
    if (!_myTimer) {
        _myTimer = [NSTimer timerWithTimeInterval:1.0/60.0 target:self selector:@selector(updateTimerFire:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_myTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_myTimer) {
        [_myTimer invalidate];
        _myTimer = nil;
    }
    if (_pielayers.count) {
        [self addTextShow];
    }
}

- (void)addTextShow
{
	[_pielayers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PieceLayer *pieLayer = (PieceLayer *)obj;
        NSString *text = [NSString stringWithFormat:@"%@：%.2f%@",pieLayer.text,pieLayer.percentage,@"%"];
        CATextLayer *textLayer = [self createTextLayerWithText:text font:[UIFont systemFontOfSize:13.f] frame:CGRectMake(0, self.pieCenter.y + self.pieRadius + 40 + 30*idx, self.width, 30) color:pieLayer.color];
        [self.layer addSublayer:textLayer];
    }];
}

- (CATextLayer *)createTextLayerWithText:(NSString *)text font:(UIFont *)font frame:(CGRect)frame color:(UIColor *)color
{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef strRef  = (__bridge CFStringRef)[[UIFont systemFontOfSize:13]fontName];
    CGFontRef fontRef = CGFontCreateWithFontName(strRef);
    textLayer.font = fontRef;
    CFRelease(strRef);
    CGFontRelease(fontRef);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.foregroundColor = [UIColor purpleColor].CGColor;
    textLayer.frame = frame;
    NSMutableAttributedString *label = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]}];
    [label setAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} range:NSMakeRange(4, text.length - 4)];
    textLayer.string = label;
    
    return textLayer;

}


static CGPathRef CGPathCreateArc(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle)
{
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, center.x, center.y);
    
    CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, 0);
    CGPathCloseSubpath(path);
    
    return path;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
