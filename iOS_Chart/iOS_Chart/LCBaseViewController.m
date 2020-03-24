//
//  LCBaseViewController.m
//  iOS_Chart
//
//  Created by 李郴 on 2020/3/18.
//  Copyright © 2020 KC. All rights reserved.
//

#import "LCBaseViewController.h"
#import "UIImage+Color.h"
#import "UIColor+Hex.h"

@interface LCBaseViewController ()

@end

@implementation LCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (UIStatusBarStyle)preferredStatusBarStyle {
    [super preferredStatusBarStyle];
    if (self.whiteStatusBar) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}
- (BOOL)prefersStatusBarHidden {
    //return YES;
    return self.hideStatusBar;
}


#pragma mark - setting method
- (void)setHasBack:(BOOL)hasBack {
    _hasBack = hasBack;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor  colorWithHexString:@"#414247"];
}
/** 设置状态栏文字颜色为白色，默认为NO */
- (void)setWhiteStatusBar:(BOOL)whiteStatusBar {
    _whiteStatusBar = whiteStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
}
/** 是否隐藏状态栏。默认为NO  */
- (void)setHideStatusBar:(BOOL)hideStatusBar {
    _hideStatusBar = hideStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
}
/** 设置导航栏背景颜色  */
- (void)setNavBarBarTintColor:(UIColor *)navBarBarTintColor {
    _navBarBarTintColor = navBarBarTintColor;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:_navBarBarTintColor] forBarMetrics:UIBarMetricsDefault];
}
/** 导航栏两边按钮颜色  */
- (void)setNavBarTintColor:(UIColor *)navBarTintColor {
    _navBarTintColor = navBarTintColor;
    if (self.navigationItem.leftBarButtonItems.count > 0) {
        for (UIBarButtonItem *item in self.navigationItem.leftBarButtonItems) {
            item.tintColor = navBarTintColor;
        }
    } else {
        self.navigationItem.leftBarButtonItem.tintColor = navBarTintColor;
    }
    if (self.navigationItem.rightBarButtonItems.count > 0) {
        for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            item.tintColor = navBarTintColor;
        }
    } else {
        self.navigationItem.rightBarButtonItem.tintColor = navBarTintColor;
    }
}
/** 导航栏标题颜色  */
- (void)setNavBarTitleColor:(UIColor *)navBarTitleColor {
    _navBarTitleColor = navBarTitleColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:navBarTitleColor}];
}


//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//}

#pragma mark - private
//返回
- (void)backClick {
    if (self.navigationController) {
        if (![self.navigationController popViewControllerAnimated:YES]){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{ }];
    }
}

@end
