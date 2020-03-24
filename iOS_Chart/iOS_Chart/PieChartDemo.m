//
//  PieChartDemo.m
//  iOS_Chart
//
//  Created by KC on 2017/7/18.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "PieChartDemo.h"
#import "UIBezierPath+YYAdd.h"

@interface SliceLayer : CAShapeLayer
@property (nonatomic, assign) CGFloat   value;
@property (nonatomic, assign) CGFloat   percentage;
@property (nonatomic, assign) double    startAngle;
@property (nonatomic, assign) double    endAngle;
@property (nonatomic, assign) BOOL      isSelected;
@property (nonatomic, strong) NSString  *text;
- (void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate;
@end

@implementation SliceLayer
@synthesize text = _text;
@synthesize value = _value;
@synthesize percentage = _percentage;
@synthesize startAngle = _startAngle;
@synthesize endAngle = _endAngle;
@synthesize isSelected = _isSelected;
//- (NSString*)description
//{
//    return [NSString stringWithFormat:@"value:%f, percentage:%0.0f, start:%f, end:%f", _value, _percentage, _startAngle/M_PI*180, _endAngle/M_PI*180];
//}
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"startAngle"] || [key isEqualToString:@"endAngle"]) {
        return YES;
    }
    else {
        return [super needsDisplayForKey:key];
    }
}
- (id)initWithLayer:(id)layer
{
    if (self = [super initWithLayer:layer])
    {
        if ([layer isKindOfClass:[SliceLayer class]]) {
            self.startAngle = [(SliceLayer *)layer startAngle];
            self.endAngle = [(SliceLayer *)layer endAngle];
        }
    }
    return self;
}
- (void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate
{
    //动画效果
    CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:key];
    NSNumber *currentAngle = [[self presentationLayer] valueForKey:key];
    if(!currentAngle) currentAngle = from;
    [arcAnimation setFromValue:currentAngle];
    [arcAnimation setToValue:to];
    [arcAnimation setDelegate:delegate];
    [arcAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self addAnimation:arcAnimation forKey:key];
    [self setValue:to forKey:key];
}
@end

#import "LCPieChart.h"

@interface PieChartDemo ()<CAAnimationDelegate,LCPieChartDataSource>
@property(nonatomic, strong)NSTimer *myTimer;
@property(nonatomic, strong)CAShapeLayer *shapeLayer;
@property(nonatomic, strong)CAShapeLayer *shapeLayer0;
@property(nonatomic, assign)CGFloat startAngle0;
@property(nonatomic, assign)CGFloat endAngle0,endAngle1;
@property(nonatomic, strong)NSMutableArray *animations;
@property(nonatomic, strong)NSMutableArray *colors;
@property(nonatomic, strong)NSMutableArray *values;
@property(nonatomic, strong)NSMutableArray *titles;
@end

@implementation PieChartDemo
@synthesize shapeLayer,startAngle0,endAngle0,shapeLayer0,endAngle1,animations;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _colors = @[].mutableCopy;
    _values = @[].mutableCopy;
    _titles = @[].mutableCopy;
    
    [_titles addObject:@"数据一"];
    [_titles addObject:@"数据二"];
    [_titles addObject:@"数据三"];
    [_titles addObject:@"数据四"];
    
    for (NSInteger index = 0; index<4; index ++) {
        CGFloat red = arc4random()/(CGFloat)INT_MAX;
        CGFloat green = arc4random()/(CGFloat)INT_MAX;
        CGFloat blue = arc4random()/(CGFloat)INT_MAX;
        
//        NSInteger temp = arc4random();
//        NSLog(@"temp : %d",temp);
        NSLog(@"red: %.2f, green: %.2f, blue: %.2f",red, green, blue);
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        [_colors addObject:color];
        [_values addObject:[NSNumber numberWithFloat:(index+1) * 10]];
    }
    
    animations = [NSMutableArray array];
    
    startAngle0 = M_PI_2*3;
    endAngle0 = M_PI_2*3;
    endAngle1 = 0;
    
    LCPieChart *pieChart = [[LCPieChart alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) radius:100 center:CGPointMake(self.view.width/2.0, (self.view.height  - XGDeviceManager.navigationBarHeight - (XGDeviceManager.tabbarHeight - 49))/2.0)];
    pieChart.dataSource = self;
    pieChart.animateDuration = 3.0;
    [self.view addSubview:pieChart];
    
    [pieChart reloadData];
    
    
    CAShapeLayer *textShape = [CAShapeLayer layer];
    textShape.frame = CGRectMake(0, self.view.height - XGDeviceManager.navigationBarHeight - 100 - (XGDeviceManager.tabbarHeight - 49), self.view.width, 100);
    textShape.lineWidth = 1.0;
    textShape.fillColor = [UIColor clearColor].CGColor;
    UIBezierPath *textPath = [UIBezierPath bezierPathWithText:@"hello everyone !" font:[UIFont systemFontOfSize:18.f]];
    UIGraphicsBeginImageContext(textShape.bounds.size);
    [textPath fill];
    UIGraphicsEndImageContext();
    textShape.strokeColor = [UIColor orangeColor].CGColor;
    textShape.path = textPath.CGPath;
    textShape.strokeStart = 0.0f;
    [self.view.layer addSublayer:textShape];
    
    CABasicAnimation *strokeAnimate = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimate.fromValue = [NSNumber numberWithFloat:0.0];
    strokeAnimate.toValue = [NSNumber numberWithFloat:1.0f];
    strokeAnimate.duration = 10.0;
    strokeAnimate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [textShape addAnimation:strokeAnimate forKey:@"strokeEnd"];
    
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
    textLayer.frame = CGRectMake(0, self.view.height - 50, self.view.width, 50);
    textLayer.string = @"";
    [self.view.layer addSublayer:textLayer];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:5.0];
    textLayer.foregroundColor = [UIColor redColor].CGColor;
    NSMutableAttributedString *label = [[NSMutableAttributedString alloc]initWithString:@"looking this sprise" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0],NSForegroundColorAttributeName:[UIColor redColor]}];
    textLayer.string = label;
    [CATransaction commit];
    
    
    
}



- (NSUInteger)numbersOfPieceInPieChart:(LCPieChart *)pieChart
{
    return _values.count;
}
- (CGFloat)pieChart:(LCPieChart *)pieChart valueFromPieceIndex:(NSUInteger)index
{
    
    return [_values[index] floatValue];
}

- (UIColor *)pieChart:(LCPieChart *)pieChart colorOfPieceAtIndex:(NSUInteger)index
{
    return _colors[index];
}

- (NSString *)pieChart:(LCPieChart *)pieChart titleOfPieceAtIndex:(NSUInteger)index
{
    return _titles[index];
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
