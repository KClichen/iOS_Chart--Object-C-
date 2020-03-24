//
//  LaunchAnimate.m
//  iOS_Chart
//
//  Created by KC on 2017/8/4.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "LaunchAnimate.h"

@interface LaunchAnimate()<CAAnimationDelegate>
@property(nonatomic, strong)CAAnimationGroup *stepAnimate;
@property(nonatomic, strong)UIImageView *image_l;
@property(nonatomic, strong)UIImageView *image_x;
@property(nonatomic, strong)UIImageView *love;
@property(nonatomic, strong)CATextLayer *textLayer1;
@property(nonatomic, strong)CATextLayer *textLayer2;
@property(nonatomic, strong)CATextLayer *textLayer3;
@property(nonatomic, strong)CATextLayer *textLayer4;
@property(nonatomic, strong)CAAnimationGroup *endAnimate_l;
@property(nonatomic, strong)CAAnimationGroup *endAnimate_x;
@property(nonatomic, strong)CAAnimationGroup *loveAnimate;
@property(nonatomic, assign)CGFloat fontSize;
@property(nonatomic, strong)NSDictionary *dic;
@property(nonatomic, assign)CGFloat adjustHeight;//调整高度 以防text出框
@property(nonatomic, assign)CGPoint endPoint_x;
@property(nonatomic, assign)CGPoint endPoint_l;

@end

@implementation LaunchAnimate
@synthesize image_l,image_x,love;
@synthesize textLayer1,textLayer2,textLayer3,textLayer4;
@synthesize fontSize,dic;
@synthesize adjustHeight;
@synthesize endPoint_x,endPoint_l;
@synthesize loveAnimate;

+ (instancetype)initLauchView
{
    return [[self alloc]initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        fontSize = 30;
        adjustHeight = 15;
        dic = @{NSFontAttributeName:[UIFont fontWithName:@"ArialHebrew-Bold" size:fontSize],NSForegroundColorAttributeName:[UIColor orangeColor]};
        
        [self setUpView];
        
    }
    
    return self;
}

- (void)setUpView
{
    image_l = [UIImageView new];
    image_l.width = 60;
    image_l.height = 60;
    image_l.right = 0;
    image_l.bottom = self.height;
    UIImage *image_ll = [UIImage imageNamed:@"luoli.JPG"];
    UIImage *image_pz = [UIImage imageNamed:@"pangzi.JPG"];
    NSLog(@"image_ll.imageOrientation: %ld image_pz.imageOrientation: %ld",image_ll.imageOrientation,image_pz.imageOrientation);
    
    
    
    UIImage *cutImage_ll = [self cutImageInRect:CGRectMake(0, 0, image_ll.size.width, image_ll.size.width) imageName:@"luoli.JPG"];
    UIImage *cutImage_pz = [self cutImageInRect:CGRectMake(1430, 840, 700, 700) imageName:@"pangzi.JPG"];
    
    
    image_l.image = [self cirCleImageWithImage:cutImage_pz cutSize:CGSizeMake(image_pz.size.width/3.0, image_pz.size.width/3.0) borderWith:20 borderColor:[UIColor colorWithRed:0.123 green:0.987 blue:0.987 alpha:0.8]];
//    image_l.image = cutImage_pz;
    image_l.transform = CGAffineTransformRotate(image_l.transform, M_PI_2);
    [self addSubview:image_l];
    
    image_x = [UIImageView new];
    image_x.width = 60;
    image_x.height = 60;
    image_x.left = self.width;
    image_x.top = 0;
    image_x.image = [self cirCleImageWithImage:cutImage_ll cutSize:CGSizeMake(image_ll.size.width, image_ll.size.width) borderWith:30 borderColor:[UIColor colorWithRed:0.987 green:0.123 blue:0.987 alpha:0.8]];
//    image_x.image = cutImage_ll;

    [self addSubview:image_x];
    
}
- (void)startAnimation
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormat stringFromDate:currentDate];
    
    NSInteger year = [[dateStr substringToIndex:4] integerValue];
    NSInteger month = [[dateStr substringWithRange:NSMakeRange(5, 2)] integerValue];
    NSInteger day = [[dateStr substringWithRange:NSMakeRange(8, 2)] integerValue];

    NSLog(@"year:%ld, month:%ld, day:%ld",(long)year,(long)month,(long)day);
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    self.backgroundColor = [UIColor whiteColor];
    NSString *text1 = @"萝";
    NSString *text2 = @"莉";
    NSString *text3 = @"账本";
    NSString *text4 = @"⚒";
    
    CGSize size1 = [text1 sizeWithAttributes:dic];
    CGSize size2 = [text2 sizeWithAttributes:dic];
    CGSize size3 = [text3 sizeWithAttributes:dic];
    CGSize size4 = [text4 sizeWithAttributes:dic];
    
    size1 = CGSizeMake(size1.width, size1.height + adjustHeight);
    size2 = CGSizeMake(size2.width, size2.height + adjustHeight);
    size3 = CGSizeMake(size3.width, size3.height + adjustHeight);
    size4 = CGSizeMake(size4.width, size4.height + adjustHeight);
    

    NSString *allText = @"萝莉账本⚒";
    
    textLayer1 = [CATextLayer layer];
    textLayer1.contentsScale = [UIScreen mainScreen].scale;
//    CFStringRef strRef  = (__bridge CFStringRef)[[UIFont systemFontOfSize:13]fontName];
//    CGFontRef fontRef = CGFontCreateWithFontName(strRef);
//    textLayer.font = fontRef;
//    CFRelease(strRef);
//    CGFontRelease(fontRef);
    textLayer1.alignmentMode = kCAAlignmentCenter;
    textLayer1.bounds = CGRectMake(0, 0, size1.width, size1.height);
    textLayer1.position = CGPointMake(self.width + size1.width/2.0, self.height* 2/3.0);
    NSMutableAttributedString *textAttri1 = [[NSMutableAttributedString alloc]initWithString:text1 attributes:dic];
    textLayer1.string = textAttri1;
    [self.layer  addSublayer:textLayer1];
    
    textLayer2 = [CATextLayer layer];
    textLayer2.contentsScale = [UIScreen mainScreen].scale;
    textLayer2.alignmentMode = kCAAlignmentCenter;
    textLayer2.bounds = CGRectMake(0, 0, size2.width, size2.height);
    textLayer2.position = CGPointMake(self.width + size2.width/2.0, self.height* 2/3.0);
    NSMutableAttributedString *textAttri2 = [[NSMutableAttributedString alloc]initWithString:@"莉" attributes:dic];
    textLayer2.string = textAttri2;
    [self.layer  addSublayer:textLayer2];
    
    textLayer3 = [CATextLayer layer];
    textLayer3.contentsScale = [UIScreen mainScreen].scale;
    textLayer3.alignmentMode = kCAAlignmentCenter;
    textLayer3.bounds = CGRectMake(0, 0, size3.width, size3.height);
    textLayer3.position = CGPointMake(self.width + size3.width/2.0, self.height* 2/3.0);
    NSMutableAttributedString *textAttri3 = [[NSMutableAttributedString alloc]initWithString:@"账本" attributes:dic];
    textLayer3.string = textAttri3;
    [self.layer  addSublayer:textLayer3];
    
    textLayer4 = [CATextLayer layer];
    textLayer4.contentsScale = [UIScreen mainScreen].scale;
    textLayer4.alignmentMode = kCAAlignmentCenter;
    textLayer4.bounds = CGRectMake(0, 0, size4.width, size4.height);
    textLayer4.position = CGPointMake(self.width + size4.width/2.0, self.height* 2/3.0);
    NSMutableAttributedString *textAttri4 = [[NSMutableAttributedString alloc]initWithString:@"⚒" attributes:dic];
    textLayer4.string = textAttri4;
    [self.layer  addSublayer:textLayer4];
    
    

    //萝的动画
    //计算萝最后应该在的位置
    CGFloat all_width = [allText sizeWithAttributes:dic].width;
    CGFloat with_luo = [[allText substringWithRange:NSMakeRange(0, 1)] sizeWithAttributes:dic].width;
    
    
    CABasicAnimation *xAnimate = [CABasicAnimation animationWithKeyPath:@"position.x"];
    xAnimate.fromValue = [NSNumber numberWithFloat:self.width];
    xAnimate.toValue = [NSNumber numberWithFloat:self.width/2.0 - all_width/2.0 + with_luo/2.0];
    xAnimate.duration = 3.f;
//    xAnimate.delegate = self;
    xAnimate.fillMode = kCAFillModeForwards;
    xAnimate.removedOnCompletion = NO;
    
    CABasicAnimation *yAnimate = [CABasicAnimation animationWithKeyPath:@"position.y"];
    yAnimate.fromValue = [NSNumber numberWithFloat:self.height/2.0];
    yAnimate.toValue = [NSNumber numberWithFloat:self.height/2.0 - 60];
    yAnimate.duration = .5f;
    yAnimate.fillMode = kCAFillModeForwards;
    yAnimate.removedOnCompletion = NO;
    yAnimate.autoreverses = YES;
    yAnimate.repeatCount = 3;
    
    CAAnimationGroup *stepAnimate_luo = [CAAnimationGroup animation];
    stepAnimate_luo.animations = @[xAnimate, yAnimate];
    stepAnimate_luo.duration = 3.0;
    stepAnimate_luo.delegate = self;
    stepAnimate_luo.removedOnCompletion = NO;
    stepAnimate_luo.fillMode = kCAFillModeForwards;
    [textLayer1 addAnimation:stepAnimate_luo forKey:@"stepAnimate"];
    
    //莉的动画
    CGFloat width_li = [[allText substringWithRange:NSMakeRange(1, 1)] sizeWithAttributes:dic].width;
    CGFloat preWidth_1 = [[allText substringToIndex:1] sizeWithAttributes:dic].width;
    CABasicAnimation *xAnimate_li = [CABasicAnimation animationWithKeyPath:@"position.x"];
    xAnimate_li.fromValue = [NSNumber numberWithFloat:self.width];
    NSLog(@"one word.with: %.2f",preWidth_1);
    xAnimate_li.toValue = [NSNumber numberWithFloat:self.width/2.0 - all_width/2.0 + preWidth_1 + width_li/2.0];
    xAnimate_li.duration = 3.f;
    xAnimate_li.fillMode = kCAFillModeForwards;
    xAnimate_li.removedOnCompletion = NO;
    
    CABasicAnimation *yAnimate_li = [CABasicAnimation animationWithKeyPath:@"position.y"];
    yAnimate_li.fromValue = [NSNumber numberWithFloat:self.height/2.0];
    yAnimate_li.toValue = [NSNumber numberWithFloat:self.height/2.0 - 60];
    yAnimate_li.duration = .5f;
    yAnimate_li.fillMode = kCAFillModeForwards;
    yAnimate_li.removedOnCompletion = NO;
    yAnimate_li.autoreverses = YES;
    yAnimate_li.repeatCount = 3;
    
    CAAnimationGroup *stepAnimate_li = [CAAnimationGroup animation];
    stepAnimate_li.animations = @[xAnimate_li, yAnimate_li];
    stepAnimate_li.duration = 3.0;
    stepAnimate_li.delegate = self;
    stepAnimate_li.removedOnCompletion = NO;
    stepAnimate_li.fillMode = kCAFillModeForwards;
    [stepAnimate_li setValue:@"stepAnimate" forKey:@"animateName"];
    stepAnimate_li.beginTime = CACurrentMediaTime() + 0.5;

    
    
    
//    [textLayer addAnimation:xAnimate forKey:@"xAnimate"];
//    [textLayer addAnimation:yAnimate forKey:@"yAnimate"];
    
    CGFloat width_zb = [[allText substringWithRange:NSMakeRange(2, 2)] sizeWithAttributes:dic].width;
    CGFloat preWidth_zb = [[allText substringWithRange:NSMakeRange(0, 2)] sizeWithAttributes:dic].width;
    CABasicAnimation *translateAnimate = [CABasicAnimation animationWithKeyPath:@"position"];
    translateAnimate.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.width + size1.width + size2.width + size3.width/2.0, self.height/2.0)];
    translateAnimate.toValue = [NSValue valueWithCGPoint:CGPointMake(self.width/2.0 - all_width/2.0 +  preWidth_zb + width_zb/2.0, self.height/2.0)];
    translateAnimate.fillMode = kCAFillModeForwards;
    translateAnimate.removedOnCompletion = NO;
    translateAnimate.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.77 :0.77 :0.77 :0.2];
    translateAnimate.duration = 3.5;
    [textLayer3 addAnimation:translateAnimate forKey:@"translate"];
    
    
    CGFloat width_z = [[allText substringWithRange:NSMakeRange(4, 1)] sizeWithAttributes:dic].width;
    CGFloat preWidth_z = [[allText substringWithRange:NSMakeRange(0, 4)] sizeWithAttributes:dic].width;
    CGPoint point_z = CGPointMake(self.width/2.0 - all_width/2.0 + preWidth_z + width_z/2.0, self.height/2.0);
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.calculationMode = kCAAnimationPaced;
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.fillMode = kCAFillModeForwards;
    [keyAnimation setValue:@"keyAnimate" forKey:@"animateName"];
    keyAnimation.duration = 1.5;
    
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    CGPoint firstP = CGPointMake(self.width, self.height/2.0);
    [bezier moveToPoint:firstP];
    CGPoint nextP1 = CGPointMake(self.width/2.0, self.height*4/5.0);

    CGPoint cp1 = CGPointMake(firstP.x, nextP1.y);
    [bezier addQuadCurveToPoint:nextP1 controlPoint:cp1];

    CGPoint nextP2 = CGPointMake(self.width/4.0, self.height/2.0);
    CGPoint cp2 = CGPointMake(nextP2.x, nextP1.y);
    [bezier addQuadCurveToPoint:nextP2 controlPoint:cp2];

    CGPoint nextP3 = CGPointMake(point_z.x, self.height/3.0);
    CGPoint cp3 = CGPointMake(nextP2.x, nextP3.y);
    [bezier addQuadCurveToPoint:nextP3 controlPoint:cp3];

    CGPoint nextP4 = CGPointMake(point_z.x + (self.width - point_z.x)/2.0, self.height/2.0);
    CGPoint cp4 = CGPointMake(nextP4.x, nextP3.y);
    [bezier addQuadCurveToPoint:nextP4 controlPoint:cp4];

    CGPoint nextP5 = CGPointMake(point_z.x + (nextP4.x - point_z.x)/2.0, self.height/2.0 + self.height/10.0);
    CGPoint cp5 = CGPointMake(nextP4.x, nextP5.y);
    [bezier addQuadCurveToPoint:nextP5 controlPoint:cp5];

  
    CGPoint cp6 = CGPointMake(point_z.x, nextP5.y);
    [bezier addQuadCurveToPoint:point_z controlPoint:cp6];

    keyAnimation.path = bezier.CGPath;
    keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *keyScaleAnimate = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    keyScaleAnimate.fromValue = @(1.0);
    keyScaleAnimate.toValue = @(2.0);
    keyScaleAnimate.autoreverses = YES;
    keyScaleAnimate.removedOnCompletion = NO;
    keyScaleAnimate.fillMode = kCAFillModeForwards;
    keyScaleAnimate.duration = 1.5/2.0;
    
    CAAnimationGroup *keyAnimateGroup = [CAAnimationGroup animation];
    keyAnimateGroup.animations = @[keyScaleAnimate, keyAnimation];
    keyAnimateGroup.delegate = self;
    keyAnimateGroup.removedOnCompletion = NO;
    keyAnimateGroup.fillMode = kCAFillModeForwards;
    [keyAnimateGroup setValue:@"keyAnimate" forKey:@"animateName"];
    keyAnimateGroup.duration = 1.5;
    
    [stepAnimate_li setValue:textLayer4 forKey:@"KcLayer"];
    [stepAnimate_li setValue:keyAnimateGroup forKey:@"nextAnimate"];
    [textLayer2 addAnimation:stepAnimate_li forKey:@"stepAnimate"];
    
    
    //计算"萝莉" 占用的长度
    NSString *luoli = @"萝莉";
    CGFloat luoliWidth = [luoli sizeWithAttributes:dic].width;
    CGFloat right_luoli = self.width/2.0 - all_width/2.0 + luoliWidth;
    CABasicAnimation *positionAnimate_l = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimate_l.fromValue = [NSValue valueWithCGPoint:CGPointMake(-image_l.width, self.height+ image_l.height)];
    positionAnimate_l.toValue = [NSValue valueWithCGPoint:CGPointMake(right_luoli - image_l.width/2.0, self.height/2.0 + image_l.height/2.0)];
    endPoint_l = CGPointMake(right_luoli - image_l.width/2.0, self.height/2.0 + image_l.height/2.0);
    positionAnimate_l.duration = 1.5;
    positionAnimate_l.removedOnCompletion = NO;
    positionAnimate_l.fillMode = kCAFillModeForwards;
    
    
    CABasicAnimation *scaleAnimate_l = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimate_l.fromValue = @(1.0);
    scaleAnimate_l.toValue = @(2.0);
    scaleAnimate_l.autoreverses = YES;
    scaleAnimate_l.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    scaleAnimate_l.duration = 1.5/2.0;
    
    _endAnimate_l = [CAAnimationGroup animation];
    _endAnimate_l.animations = @[scaleAnimate_l, positionAnimate_l];
    _endAnimate_l.removedOnCompletion = NO;
    _endAnimate_l.fillMode = kCAFillModeForwards;
    [_endAnimate_l setValue:@"endAnimate_l" forKey:@"animateName"];
    _endAnimate_l.delegate = self;
    _endAnimate_l.duration = 1.5;
    
    
    CABasicAnimation *positionAnimate_x = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimate_x.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.width + image_x.width, - image_x.height)];
    positionAnimate_x.toValue = [NSValue valueWithCGPoint:CGPointMake(right_luoli + image_x.width/2.0, self.height/2.0 - image_x.height/2.0)];
    endPoint_x = CGPointMake(right_luoli + image_x.width/2.0, self.height/2.0 - image_x.height/2.0);
    positionAnimate_x.duration = 1.5;
    positionAnimate_x.fillMode = kCAFillModeForwards;
    positionAnimate_x.removedOnCompletion = NO;
    
    CABasicAnimation *scaleAnimate_x = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimate_x.fromValue = @(1.0);
    scaleAnimate_x.toValue = @(2.0);
    scaleAnimate_x.autoreverses = YES;
    scaleAnimate_x.duration = 1.5/2.0;
    scaleAnimate_x.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    _endAnimate_x = [CAAnimationGroup animation];
    [_endAnimate_x setValue:@"endAnimate_x" forKey:@"animateName"];
    _endAnimate_x.duration = 1.5f;
    _endAnimate_x.delegate = self;
    _endAnimate_x.fillMode = kCAFillModeForwards;
    _endAnimate_x.removedOnCompletion = NO;
    _endAnimate_x.animations = @[scaleAnimate_x, positionAnimate_x];
    
    
    
    CABasicAnimation *scaleAnimate_love = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimate_love.fromValue = @(1.0);
    scaleAnimate_love.toValue = @(2.0);
    scaleAnimate_love.autoreverses = YES;
    scaleAnimate_love.fillMode = kCAFillModeForwards;
    scaleAnimate_love.removedOnCompletion = NO;
    scaleAnimate_love.duration = 0.5/2.0;
    
    CABasicAnimation *positionAnimate_love = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimate_love.fromValue = [NSValue valueWithCGPoint:endPoint_l];
    positionAnimate_love.toValue = [NSValue valueWithCGPoint:endPoint_x];
    positionAnimate_love.fillMode = kCAFillModeForwards;
    positionAnimate_love.removedOnCompletion = NO;
    positionAnimate_love.duration = 0.5;
    
    loveAnimate = [CAAnimationGroup animation];
    loveAnimate.animations = @[scaleAnimate_love,positionAnimate_love];
    loveAnimate.delegate = self;
    loveAnimate.duration = 0.5;
    [loveAnimate setValue:@"loveAnimate" forKey:@"animateName"];
    loveAnimate.repeatCount = 3;
    
    
    love = [UIImageView new];
    love.width = 35;
    love.height = 35;
    love.center = endPoint_l;
    love.image = [UIImage imageNamed:@"love.png"];
    love.hidden = YES;
    [self addSubview:love];
    

}

- (void)startLaunchAnimateWithCompletionBlock:(void (^)(LaunchAnimate *))completionHandler
{
    completionHandler(self);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    NSString *name = [anim valueForKey:@"animateName"];
    if ([name isEqualToString:@"stepAnimate"]) {
        CATextLayer *layer = (CATextLayer *)[anim valueForKey:@"KcLayer"];
        CAAnimation *animate = (CAAnimation *)[anim valueForKey:@"nextAnimate"];
        [layer addAnimation:animate forKey:@"keyAnimate"];
        
    }
    else if ([name isEqualToString:@"keyAnimate"] ) {
        
        NSString *str = @"萝";
        NSString *str1 = @"莉";
        NSString *preStr = @"萝";
        NSString *allText = @"萝莉账本⚒";
        
        CGPoint position1 = CGPointMake(self.width/2.0 - [allText sizeWithAttributes:dic].width/2.0 + [str sizeWithAttributes:dic].width/2.0, self.height/2.0);
        CGPoint position2 = CGPointMake(self.width/2.0 - [allText sizeWithAttributes:dic].width/2.0 + [preStr sizeWithAttributes:dic].width + [str1 sizeWithAttributes:dic].width/2.0, self.height/2.0);
        [textLayer1 removeAllAnimations];
        [textLayer2 removeAllAnimations];
        textLayer1.position = position1;
        textLayer2.position = position2;

        [image_l.layer addAnimation:_endAnimate_l forKey:@"animate_l"];
        NSTimer *timer = [NSTimer timerWithTimeInterval:1/60.0 target:self selector:@selector(responsedToLTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        
        


    }
    else if ([name isEqualToString:@"endAnimate_l"]) {
        [image_l.layer removeAllAnimations];
        image_l.center = endPoint_l;
        [image_x.layer addAnimation:_endAnimate_x forKey:@"animate_x"];
        NSTimer *timer = [NSTimer timerWithTimeInterval:1/60.0 target:self selector:@selector(responsedToXTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    }
    else if ([name isEqualToString:@"endAnimate_x"]) {
        
        [image_x.layer removeAllAnimations];
        image_x.center = endPoint_x;
        
        NSString *str = @"账本";
        NSString *str1 = @"⚒";
        NSString *preStr = @"萝莉";
        NSString *preStr1 = @"萝莉账本";
        NSString *allText = @"萝莉账本⚒";
        CGPoint position3 = CGPointMake(self.width/2.0 - [allText sizeWithAttributes:dic].width/2.0 + [preStr sizeWithAttributes:dic].width + [str sizeWithAttributes:dic].width/2.0, self.height/2.0 + image_x.height/2.0);
        CGPoint position4 = CGPointMake(self.width/2.0 - [allText sizeWithAttributes:dic].width/2.0 + [preStr1 sizeWithAttributes:dic].width + [str1 sizeWithAttributes:dic].width/2.0, self.height/2.0 + image_x.height/2.0);

        [textLayer3 removeAllAnimations];
        [textLayer4 removeAllAnimations];
        textLayer3.position = position3;
        textLayer4.position = position4;
        love.hidden = NO;
        [love.layer addAnimation:loveAnimate forKey:@"loveAnimate"];
    }
    else if ([name isEqualToString:@"loveAnimate"])
    {
        [love.layer removeAllAnimations];
        [love removeFromSuperview];
        
//        CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
//        keyAnimaion.keyPath = @"transform.rotation";
//        keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI)];//度数转弧度
//        keyAnimaion.removedOnCompletion = NO;
//        keyAnimaion.fillMode = kCAFillModeForwards;
//        keyAnimaion.duration = 0.3;
//        keyAnimaion.repeatCount = 3;
//        keyAnimaion.delegate = self;
//        [keyAnimaion setValue:@"keyAnimation" forKey:@"animateName"];
//        [image_x.layer addAnimation:keyAnimaion forKey:@"keyAnimation"];
        
        
        CABasicAnimation *shakeAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        shakeAnimate.fromValue = @( - M_PI_4/5.0);
        shakeAnimate.toValue = @( M_PI_4/5.0);
//        shakeAnimate.fillMode = kCAFillModeForwards;
//        shakeAnimate.removedOnCompletion = NO;
        shakeAnimate.autoreverses = YES;
        shakeAnimate.duration = 0.3/2.0;
        shakeAnimate.repeatCount = 3;
        shakeAnimate.delegate = self;
        [shakeAnimate setValue:@"shakeAnimate" forKey:@"animateName"];
        [image_x.layer addAnimation:shakeAnimate forKey:@"shakeAnimate"];
    }
    else if ([name isEqualToString:@"shakeAnimate"])
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }

}


- (UIImage *)cirCleImageWithImage:(UIImage *)oldImage cutSize:(CGSize)cutSize borderWith:(CGFloat)borderWith borderColor:(UIColor *)borderColor
{
    UIImage *originalImage = oldImage;
    CGFloat imageW = originalImage.size.width + 2*borderWith;
    CGSize imageSize = CGSizeMake(imageW, imageW);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, originalImage.scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI*2, 0);
    CGContextFillPath(ctx);
    
    CGFloat smallRadius = bigRadius - borderWith;
    CGContextAddArc(ctx, centerX,centerY, smallRadius, 0, M_PI*2, 0);
    CGContextClip(ctx);
    
    [originalImage drawInRect:CGRectMake(borderWith, borderWith, imageSize.width, imageSize.width)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)cutImageInRect:(CGRect)cutRect imageName:(NSString *)name
{
    UIImage *oldImage = [self fixOrientation: [UIImage imageNamed:name]];
    
    NSLog(@"oldImage.orientation : %ld",oldImage.imageOrientation);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(oldImage.CGImage, cutRect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    CGImageGetHeight(subImageRef);
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];

    UIGraphicsEndImageContext();
//    if ([name isEqualToString:@"pangzi.JPG"]) {
//        CGAffineTransform transform = CGAffineTransformIdentity;
//        transform = CGAffineTransformTranslate(transform, smallImage.size.width, smallImage.size.height);
//        transform = CGAffineTransformRotate(transform, M_PI_2);
//        CGContextConcatCTM(context, transform);
//        
//        
//    }
    CGImageRelease(subImageRef);
    

    
    NSLog(@"smallImage.orientation : %ld",smallImage.imageOrientation);

    
    return smallImage;
}


- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (void)responsedToXTimer:(NSTimer *)timer
{
    
    //计算与账本的相交处的y值
    NSString *str = @"账本";
    CGFloat contact_x = self.height/2.0 - ([str sizeWithAttributes:dic].height+adjustHeight)/2.0;
    //计算超越相交点的值
    CGFloat contact_x_y = image_x.layer.presentationLayer.position.y + image_x.height/2.0 - contact_x;
    if (image_x.layer.presentationLayer.position.y >= 337.99) {
        
            [timer invalidate];
            timer = nil;
      
        return;
    }
    
    if (image_x.layer.presentationLayer.position.y+image_x.height/2.0 > contact_x ) {


        textLayer3.position = CGPointMake(textLayer3.position.x, self.height/2.0 + contact_x_y);
        textLayer4.position = CGPointMake(textLayer4.position.x, self.height/2.0 + contact_x_y);
        
    }

    
}

- (void)responsedToLTimer:(NSTimer *)timer
{
    //计算与萝莉的相交处的y值
    NSString *str = @"萝";
    CGFloat contact_l = self.height/2.0 + ([str sizeWithAttributes:dic].height + adjustHeight)/2.0;
    //计算超越相交点的值
    CGFloat contact_l_y = -image_l.layer.presentationLayer.position.y+image_l.height/2.0 + contact_l;
    if (image_l.layer.presentationLayer.position.y <= self.height/2.0 + image_l.height/2.0 + 0.1) {

        [timer invalidate];
        timer = nil;

        return;
    }
    if (image_l.layer.presentationLayer.position.y - image_l.height/2.0 < contact_l ) {
        textLayer1.position = CGPointMake(textLayer1.position.x, self.height/2.0 -  contact_l_y);
        textLayer2.position = CGPointMake(textLayer2.position.x, self.height/2.0 -  contact_l_y);
    }

}



@end
