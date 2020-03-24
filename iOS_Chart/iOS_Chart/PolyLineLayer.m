//
//  PolyLineLayer.m
//  iOS_Chart
//
//  Created by KC on 2017/7/25.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "PolyLineLayer.h"

@implementation PolyLineLayer

- (instancetype)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        
    }
    
    return self;
    
}

- (void)drawInContext:(CGContextRef)ctx
{
    if (_dataSource) {
        NSUInteger pointCount = [_dataSource numbersOfPolyLinePoints:self];
        CGPoint startPoint = [_dataSource polyLine:self pointOfIndex:0];
        switch (_type) {
            case PolyLineStroke:
            {
                UIBezierPath *bezier = [UIBezierPath bezierPath];
                [bezier moveToPoint:startPoint];
                for (NSUInteger index = 1; index<pointCount; index++) {
                    CGPoint point = [_dataSource polyLine:self pointOfIndex:index];
                    [bezier addLineToPoint:point];
                }
                UIGraphicsBeginImageContext(self.frame.size);
                [bezier stroke];
                UIGraphicsEndImageContext();
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                self.path = bezier.CGPath;
                [CATransaction setDisableActions:NO];
                [CATransaction commit];

            }
                break;
            case PolyLineFill:
            {
                UIBezierPath *bezier_fill = [UIBezierPath bezierPath];
                CGPoint startPoint_fill = CGPointMake(startPoint.x, self.frame.size.height);
                [bezier_fill moveToPoint:startPoint_fill];
                
                for (NSUInteger index = 0; index<pointCount; index++) {
                    CGPoint point = [_dataSource polyLine:self pointOfIndex:index];
                    if (index == pointCount -1) {
                        [bezier_fill addLineToPoint:CGPointMake(point.x + self.lineWidth/2.0, point.y)];
                    }
                    else
                    {
                        [bezier_fill addLineToPoint:point];
                    }
                    
                }
                CGPoint endPoint = [_dataSource polyLine:self pointOfIndex:pointCount - 1];
                [bezier_fill addLineToPoint:CGPointMake(endPoint.x + self.lineWidth/2.0, self.frame.size.height)];
                [bezier_fill closePath];
                UIGraphicsBeginImageContext(self.frame.size);
                [bezier_fill fill];
                UIGraphicsEndImageContext();
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                self.path = bezier_fill.CGPath;
                [CATransaction setDisableActions:NO];
                [CATransaction commit];
            }
                break;
            case PolyLinePoint:
            {
                UIBezierPath *bezier = [UIBezierPath bezierPath];
                for (NSUInteger index = 0; index<pointCount; index++) {
                    CGPoint point = [_dataSource polyLine:self pointOfIndex:index];
                    [bezier moveToPoint:point];
                    [bezier addArcWithCenter:point radius:2.5f startAngle:0 endAngle:M_PI*2 clockwise:YES];
                }
                UIGraphicsBeginImageContext(self.frame.size);
                [bezier fill];
                UIGraphicsEndImageContext();
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                self.path = bezier.CGPath;
                [CATransaction setDisableActions:NO];
                [CATransaction commit];

            }
                break;
                
            default:
                break;
        }
        
        
    }
    
}


@end
