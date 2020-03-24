//
//  MyTools.m
//  iOS_Chart
//
//  Created by KC on 2017/7/21.
//  Copyright © 2017年 KC. All rights reserved.
//

#import "MyTools.h"

@implementation MyTools
+ (CGFloat)getMinValueFromArray:(NSArray *)dataArray
{
    CGFloat minValue = [[dataArray firstObject] floatValue];
    for (id obj in dataArray) {
        CGFloat value = [obj floatValue];
        if (value < minValue) {
            minValue = value;
        }
    }
    return minValue;
}

+ (CGFloat)getMaxValueFromArray:(NSArray *)dataArray
{
    CGFloat maxValue = [[dataArray firstObject] floatValue];
    for (id obj in dataArray) {
        CGFloat value = [obj floatValue];
        if (value > maxValue) {
            maxValue = value;
        }
    }
    return maxValue;
}

+ (NSString *)getMaxStringWidthFromArray:(NSArray *)dataArray
{
    NSString *maxTitle = [dataArray firstObject];
    for (NSString *obj in dataArray) {
        if (obj.length > maxTitle.length) {
            maxTitle = obj;
        }
    }
    return maxTitle;
}

+ (CGFloat)getMaxTitleWidthFromArray:(NSArray *)dataArray withFontSize:(CGFloat)fontSize
{
    NSString *maxTitle = [dataArray firstObject];
    for (NSString *obj in dataArray) {
        if (obj.length > maxTitle.length) {
            maxTitle = obj;
        }
    }
    CGSize size = [maxTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
    return size.width;
}

+ (CGFloat)getMaxTitleWidthFromArray:(NSArray *)dataArray withFont:(UIFont *)font fixHeight:(CGFloat)fixHeight
{
    NSString *maxTitle = [dataArray firstObject];
    for (NSString *obj in dataArray) {
        if (obj.length > maxTitle.length) {
            maxTitle = obj;
        }
    }
    return [MyTools getAttributedStringWidthWithText:maxTitle andHeight:fixHeight andFont:font];
}

+ (CGFloat)getAttributedStringHeightWithText:(NSString *)text andWidth:(CGFloat)width andFont:(UIFont *)font
{
    static UILabel *stringLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stringLabel = [[UILabel alloc] init];
        stringLabel.numberOfLines = 0;
    });
    
    stringLabel.font = font;
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:font}];
    stringLabel.attributedText = attrStr;
    return [stringLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}

+ (CGFloat)getAttributedStringWidthWithText:(NSString *)text andHeight:(CGFloat)height andFont:(UIFont *)font
{
    static UILabel *stringLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stringLabel = [[UILabel alloc] init];
        stringLabel.numberOfLines = 0;
    });
    
    stringLabel.font = font;
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:font}];
    stringLabel.attributedText = attrStr;
    return [stringLabel sizeThatFits:CGSizeMake(MAXFLOAT, height)].width;
}

+ (CGFloat)getStringSuitableSizeWithMaxWidth:(CGFloat)maxWidth fixHeight:(CGFloat)fixHeight str:(NSString *)text beginSize:(CGFloat)beginFontSize {
    CGFloat suitSize = beginFontSize;
    CGFloat currentWidth = [MyTools getAttributedStringWidthWithText:text andHeight:fixHeight andFont:[UIFont systemFontOfSize:suitSize - 1]];
    do {
        suitSize --;
        currentWidth  = [MyTools getAttributedStringWidthWithText:text andHeight:fixHeight andFont:[UIFont systemFontOfSize:suitSize]];
    } while (currentWidth > maxWidth);
    
    return suitSize;
}

@end
