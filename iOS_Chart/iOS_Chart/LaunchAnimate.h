//
//  LaunchAnimate.h
//  iOS_Chart
//
//  Created by KC on 2017/8/4.
//  Copyright © 2017年 KC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchAnimate : UIView

+ (instancetype)initLauchView;

- (void)startLaunchAnimateWithCompletionBlock:(void(^)(LaunchAnimate *lauchAnimateView))completionHandler;
- (void)startAnimation;

@end
