//
//  LaunchScreenView.m
//  iOS_Chart
//
//  Created by KC on 2017/8/3.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "LaunchScreenView.h"

@interface LaunchScreenView()

@property(nonatomic, strong)NSTimer *myTimer;
@property(nonatomic, strong)UILabel *showLabel;
@property(nonatomic, assign)NSUInteger textCount;
@property(nonatomic, strong)NSString *animateText;


@end

@implementation LaunchScreenView
@synthesize showLabel;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    
    return self;
}

- (void)setUpView
{
    self.backgroundColor = [UIColor colorWithRed:0.986 green:0.986 blue:0.986 alpha:1.0];
    showLabel = [UILabel new];
    showLabel.width = 200;
    showLabel.height = 50;
    showLabel.left = 50;
    showLabel.top = 100;
    showLabel.text = @"welcome to ios_Chart !";
    [self addSubview:showLabel];
    _animateText = @"welcome to ios_Chart !";
    _textCount = 0;
    
    
    _myTimer = [NSTimer timerWithTimeInterval:1/20.0 target:self selector:@selector(responsedToTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
    
}

- (void)responsedToTimer:(NSTimer *)timer
{
    if (_textCount >= _animateText.length) {
        [_myTimer invalidate];
        _myTimer = nil;
        return;
    }
    NSString *text = [_animateText substringWithRange:NSMakeRange(_textCount, 1)];
    
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef strRef  = (__bridge CFStringRef)[[UIFont systemFontOfSize:13]fontName];
    CGFontRef fontRef = CGFontCreateWithFontName(strRef);
    textLayer.font = fontRef;
    CFRelease(strRef);
    CGFontRelease(fontRef);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.bounds = CGRectMake(0, 0, 50, 30);
    textLayer.position = CGPointMake(self.width + 25, self.height* 2/3.0);
    NSMutableAttributedString *textAttri = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0],NSForegroundColorAttributeName:[UIColor orangeColor]}];
    textLayer.string = textAttri;
    [self.layer  addSublayer:textLayer];
    
    //计算所有文字的宽度
    CGFloat allWordWidth = [_animateText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0]}].width;
    //单个字母的宽度
    CGFloat alphabetWith = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0]}].width;
    //文字的起始点
    CGPoint startPoint = CGPointMake(self.width/2.0 - allWordWidth/2.0, self.height * 2/3.0);
    //计算已经出现的字符串长度
    CGFloat showedLegth = [[_animateText substringWithRange:NSMakeRange(0, _textCount)] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0]}].width;

    
    CABasicAnimation *positionAnimate = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimate.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.width + 25, self.height* 2/3.0)];
    positionAnimate.toValue = [NSValue valueWithCGPoint:CGPointMake(startPoint.x + showedLegth + alphabetWith/2.0 , self.height*2/3.0)];

    positionAnimate.duration = 0.65;
    positionAnimate.delegate = self;
    positionAnimate.fillMode = kCAFillModeForwards;
    positionAnimate.removedOnCompletion = NO;
    [positionAnimate setValue:@"positionAnimate" forKey:@"animateName"];
    [positionAnimate setValue:@(_textCount) forKey:@"textPos"];
    [textLayer addAnimation:positionAnimate forKey:@"position"];
    

    _textCount ++;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
