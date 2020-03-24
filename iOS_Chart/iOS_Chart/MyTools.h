//
//  MyTools.h
//  iOS_Chart
//
//  Created by KC on 2017/7/21.
//  Copyright © 2017年 KC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTools : NSObject

/**
 获取数组中的最小值（仅限于数值数据类型）

 @param dataArray 数据源数组
 @return 返回最小值
 */
+ (CGFloat)getMinValueFromArray:(NSArray *)dataArray;


/**
 获取数组中的最大值（仅限于数值数据类型）

 @param dataArray 数据源数组
 @return 返回最大值
 */
+ (CGFloat)getMaxValueFromArray:(NSArray *)dataArray;

/// 从字符串数组中获取最长的字符串
/// @param dataArray 传入字符串数组
+ (NSString *)getMaxStringWidthFromArray:(NSArray *)dataArray;

/**
 获取文字数组中文字最多的一项的长度

 @param dataArray 字符串数组
 @param fontSize 文字字号
 @return 返回最长字符串长度
 */
+ (CGFloat)getMaxTitleWidthFromArray:(NSArray *)dataArray withFontSize:(CGFloat)fontSize;

/// 获取文字数组中文字最多的字符串的长度
/// @param dataArray 传入字符串数组
/// @param font 传入字体
/// @param fixHeight 传入已知的高度
+ (CGFloat)getMaxTitleWidthFromArray:(NSArray *)dataArray withFont:(UIFont *)font fixHeight:(CGFloat)fixHeight;


/// 已知字符串可用高度计算字符串的高度
/// @param text  传入字符串
/// @param width 已知的宽度
/// @param font 显示的字号
+ (CGFloat)getAttributedStringHeightWithText:(NSString *)text andWidth:(CGFloat)width andFont:(UIFont *)font;


/// 已知字符串可用高度计算字符串的宽度
/// @param text 传入字符串
/// @param height 已知的高度
/// @param font 显示的字号
+ (CGFloat)getAttributedStringWidthWithText:(NSString *)text andHeight:(CGFloat)height andFont:(UIFont *)font;


/// 已知固定的高度和最大的宽度给字符串计算合适的字号， 条件是根据固定高度和字号计算出的宽度超出了限制最大宽度
/// @param maxWidth 最大的宽度
/// @param fixHeight 固定的高度
/// @param text 传入字符串
/// @param beginFontSize 开始适配的字号大小
+ (CGFloat)getStringSuitableSizeWithMaxWidth:(CGFloat)maxWidth fixHeight:(CGFloat)fixHeight str:(NSString *)text beginSize:(CGFloat)beginFontSize;
@end
