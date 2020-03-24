//
//  UIColor+Hex.h
//  SweepCode
//
//  Created by 爱阅读 on 2018/12/18.
//  Copyright © 2018年 chen.li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (NSString *) hexFromUIColor: (UIColor*) color;

#ifndef UIHexColor
#define UIHexColor(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif

+(NSString*)toStrByUIColor:(UIColor*)color;
- (UIColor *)colorByAddColor:(UIColor *)add blendMode:(CGBlendMode)blendMode;

@end

NS_ASSUME_NONNULL_END
