//
//  WaveChartLayer.m
//  iOS_Chart
//
//  Created by KC on 2017/8/1.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "WaveChartLayer.h"


@implementation WaveChartLayer

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
        NSUInteger pointCount = [_dataSource numbersOfWaveChartPoints:self];
        CGPoint startPoint = [_dataSource waveChartLayer:self pointOfIndex:0];
        switch (_type) {
            case WaveChartStroke:
            {
                UIBezierPath *bezier = [UIBezierPath bezierPath];
                [bezier moveToPoint:startPoint];
                CGPoint prevPoint = startPoint;
                for (NSUInteger index = 1; index<pointCount; index++) {
                    CGPoint currentP = [_dataSource waveChartLayer:self pointOfIndex:index];
                    
                    CGPoint mindPoint =  midPointForPoints(prevPoint, currentP);
                    CGPoint cp1 = controlPointForPoints(mindPoint, prevPoint);
                    [bezier addQuadCurveToPoint:mindPoint controlPoint:cp1];
                    CGPoint cp2 = controlPointForPoints(mindPoint, currentP);
                    [bezier addQuadCurveToPoint:currentP controlPoint:cp2];
                    
                    prevPoint = currentP;
                }
                UIGraphicsBeginImageContext(self.frame.size);
                [bezier stroke];
                UIGraphicsEndImageContext();
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                self.path = bezier.CGPath;
                [CATransaction commit];
                
            }
                break;
            case WaveChartFill:
            {
                UIBezierPath *bezier_fill = [UIBezierPath bezierPath];
                CGPoint startPoint_fill = CGPointMake(startPoint.x, self.frame.size.height);
                [bezier_fill moveToPoint:startPoint_fill];
                CGPoint firstPoint = [_dataSource waveChartLayer:self pointOfIndex:0];
                [bezier_fill addLineToPoint:firstPoint];
                CGPoint prevPoint = firstPoint;
                for (NSUInteger index = 1; index<pointCount; index++) {
//                    CGPoint point = [_dataSource waveChartLayer:self pointOfIndex:index];
                    
                    CGPoint currentP = [_dataSource waveChartLayer:self pointOfIndex:index];
                    if (index == pointCount - 1) {
                        currentP.x += self.lineWidth/2.0;
                    }
                    CGPoint mindPoint =  midPointForPoints(prevPoint, currentP);
                    CGPoint cp1 = controlPointForPoints(mindPoint, prevPoint);
                    [bezier_fill addQuadCurveToPoint:mindPoint controlPoint:cp1];
                    CGPoint cp2 = controlPointForPoints(mindPoint, currentP);
                    [bezier_fill addQuadCurveToPoint:currentP controlPoint:cp2];
                    
                    prevPoint = currentP;
                    
                }
                CGPoint endPoint = [_dataSource waveChartLayer:self pointOfIndex:pointCount - 1];
                [bezier_fill addLineToPoint:CGPointMake(endPoint.x + self.lineWidth/2.0, self.frame.size.height)];
                [bezier_fill closePath];
                UIGraphicsBeginImageContext(self.frame.size);
                [bezier_fill fill];
                UIGraphicsEndImageContext();
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                self.path = bezier_fill.CGPath;
                [CATransaction commit];
            }
                break;
            case WaveChartPoint:
            {
                UIBezierPath *bezier = [UIBezierPath bezierPath];
                for (NSUInteger index = 0; index<pointCount; index++) {
                    CGPoint point = [_dataSource waveChartLayer:self pointOfIndex:index];
                    [bezier moveToPoint:point];
                    [bezier addArcWithCenter:point radius:2.5f startAngle:0 endAngle:M_PI*2 clockwise:YES];
                }
                UIGraphicsBeginImageContext(self.frame.size);
                [bezier fill];
                UIGraphicsEndImageContext();
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                self.path = bezier.CGPath;
                [CATransaction commit];
            }
                break;
                
            default:
                break;
        }
        
        
    }

}



static CGPoint midPointForPoints(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

static CGPoint controlPointForPoints(CGPoint p1, CGPoint p2) {
    CGPoint controlPoint = midPointForPoints(p1, p2);
    CGFloat diffY = fabs(p2.y - controlPoint.y);
    
    if (p1.y < p2.y)
        controlPoint.y += diffY;
    else if (p1.y > p2.y)
        controlPoint.y -= diffY;
    
    return controlPoint;
}


@end
