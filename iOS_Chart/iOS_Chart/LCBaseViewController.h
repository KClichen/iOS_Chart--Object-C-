//
//  LCBaseViewController.h
//  iOS_Chart
//
//  Created by 李郴 on 2020/3/18.
//  Copyright © 2020 KC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCBaseViewController : UIViewController

/** 设置状态栏文字颜色为白色，默认为NO */
@property (nonatomic,assign)BOOL whiteStatusBar;
/** 是否隐藏状态栏。默认为NO  */
@property (nonatomic,assign)BOOL hideStatusBar;

@property (assign, nonatomic) BOOL hasBack;

@property (nonatomic, strong)UIColor *navBarBarTintColor;
/** 导航栏两边按钮颜色  */
@property (nonatomic, strong)UIColor *navBarTintColor;
/** 导航栏标题颜色  */
@property (nonatomic, strong)UIColor *navBarTitleColor;

/** 返回上一界面 */
- (void)backClick;

@end

NS_ASSUME_NONNULL_END
