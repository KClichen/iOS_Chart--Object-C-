//
//  XGDeviceManager.h
//  xglc
//
//  Created by sengoln huang on 2018/3/19.
//  Copyright © 2018年 深圳市温馨港湾网络技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//平台类型
typedef enum : NSUInteger {
    XGUIDeviceUnknown,
    
    XGUIDeviceSimulator,
    XGUIDeviceSimulatoriPhone,
    XGUIDeviceSimulatoriPad,
    XGUIDeviceSimulatorAppleTV,
    
    XGUIDevice_iPhone1G,
    XGUIDevice_iPhone3G,
    XGUIDevice_iPhone3GS,
    XGUIDevice_iPhone4,
    XGUIDevice_iPhone4S,
    XGUIDevice_iPhone5,
    XGUIDevice_iPhone5C,
    XGUIDevice_iPhone5S,
    XGUIDevice_iPhone6,
    XGUIDevice_iPhone6Plus,
    XGUIDevice_iPhone6S,
    XGUIDevice_iPhone6SPlus,
    XGUIDevice_iPhoneSE,
    XGUIDevice_iPhone7,
    XGUIDevice_iPhone7Plus,
    XGUIDevice_iPhone8,
    XGUIDevice_iPhone8Plus,
    XGUIDevice_iPhoneX,
    XGUIDevice_iPhoneXS,
    XGUIDevice_iPhoneXSMax,
    XGUIDevice_iPhoneXR,
    
    XGUIDevice_iPod1G,
    XGUIDevice_iPod2G,
    XGUIDevice_iPod3G,
    XGUIDevice_iPod4G,
    XGUIDevice_iPod5G,
    XGUIDevice_iPod6G,
    XGUIDevice_iPod7G,
    XGUIDevice_iPod8G,
    XGUIDevice_iPod9G,
    
    XGUIDevice_iPad1G,
    XGUIDevice_iPad2G,
    XGUIDevice_iPad3G,
    XGUIDevice_iPad4G,
    XGUIDevice_iPad5G,
    XGUIDevice_iPad6G,
    XGUIDevice_iPad7G,
    XGUIDevice_iPad8G,
    XGUIDevice_iPad9G,
    
    XGUIDeviceAppleTV2,
    XGUIDeviceAppleTV3,
    XGUIDeviceAppleTV4,
    
    XGUIDeviceUnknowniPhone,
    XGUIDeviceUnknowniPod,
    XGUIDeviceUnknowniPad,
    XGUIDeviceUnknownAppleTV,
    XGUIDeviceIFPGA,
    
} XGUIDevicePlatform;


//#if UIKIT_DEFINE_AS_PROPERTIES
//@property(class, nonatomic, readonly) UIColor *blackColor;      // 0.0 white
//@property(class, nonatomic, readonly) UIColor *clearColor;      // 0.0 white, 0.0 alpha
//#else
//+ (UIColor *)blackColor;      // 0.0 white
//+ (UIColor *)clearColor;      // 0.0 white, 0.0 alpha
//#endif


//解锁类型
typedef enum : NSUInteger {
    XGDeviceSecurityTypeTouchID = 8,
    XGDeviceSecurityTypeFaceID,
    XGDeviceSecurityTypeUnknown,
} XGDeviceSecurityType;

//网络类型
typedef NS_ENUM(NSUInteger, XGNetWorkStatus) {
    XGNetWorkStatusNotReachable = 0,
    XGNetWorkStatusUnknown = 1,
    XGNetWorkStatusWWAN2G = 2,
    XGNetWorkStatusWWAN3G = 3,
    XGNetWorkStatusWWAN4G = 4,
    
    XGNetWorkStatusWiFi = 9,
};

typedef enum : NSUInteger {
    XGDeviceScreenSize3_5 = 9,  //3.5英寸640_960   @2x 320x480   //iPhone 2G/3G/3GS/4/4s
    XGDeviceScreenSize4,        //4英寸640_1136    @2x 320x568   //iPhone 5/5s/5c/SE
    XGDeviceScreenSize4_7,      //4.7英寸750_1334  @2x 375x667   //iPhone 6/6s/7/8
    XGDeviceScreenSize5_5,      //5.5英寸1242_2208 @3x 414x736   //iPhone 6 Plus/6s Plus/7 Plus/8 Plus
    XGDeviceScreenSize5_8,      //5.8英寸1125_2436 @3x 375x812   //iPhone X/XS
    XGDeviceScreenSize6_1,      //6.1英寸828_1792  @2x 414x896   //iPhone XR
    XGDeviceScreenSize6_5,      //6.5英寸1242_2688 @3x 414x896   //iPhone XS Max
} XGDeviceScreenSize;


/** 屏幕像素 和 点 的比例 */
typedef enum : NSUInteger {
    XGDeviceScreenPixelScale1X = 5,//@1x
    XGDeviceScreenPixelScale2X,//@2x
    XGDeviceScreenPixelScale3X,//@3x
} XGDeviceScreenPixelScale;


@interface XGDeviceManager : NSObject
/**
 *  获取平台类型
 *
 *  @return 获取平台类型
 */
//+ (XGUIDevicePlatform)getDevicePlatformType;
@property(class, nonatomic, readonly)XGUIDevicePlatform devicePlatformType;
///获取平台类型的字符串
//+ (NSString *)getDevicePlatformTypeString;
@property(class, nonatomic, readonly)NSString *devicePlatformTypeString;

/** 获取屏幕尺寸类型 */
//+ (XGDeviceScreenSize)getDeviceScreenSize;
@property(class, nonatomic, readonly)XGDeviceScreenSize deviceScreenSize;
//获取当前网络类型
+ (XGNetWorkStatus)getCurrentNetworkStatusWithHostName:(NSString *)hostName;

//获取手机拥有的安全方式
//+ (XGDeviceSecurityType)getDeviceSecurityType;
@property(class, nonatomic, readonly)XGDeviceSecurityType deviceSecurityType;
/** 获取手机屏幕对应的 像素点比例  @2x,@3x */
//+ (XGDeviceScreenPixelScale)getDeviceScreenPixelScale;
@property(class, nonatomic, readonly)XGDeviceScreenPixelScale deviceScreenPixelScale;

//+ (UIEdgeInsets)getSafeAreaInsets;
@property(class, nonatomic, readonly)UIEdgeInsets safeAreaInsets;

// 正则判断手机号码地址格式
+ (BOOL)isAvailableMobileNumber:(NSString *)mobileNum;

//字符串是否只包含字母和数字
+ (BOOL)onlyWordsAndNumbers:(NSString *)text;

/** 获取导航栏的高度 */
//+ (CGFloat)getNavigationBarHeight;
@property(class, nonatomic, readonly)CGFloat navigationBarHeight;
/** 状态栏的高度  */
//+ (CGFloat)getStatusBarHeight;
@property(class, nonatomic, readonly)CGFloat statusBarHeight;
/** 获取tabbar的高度 */
//+ (CGFloat)getTabbarHeight;
@property(class, nonatomic, readonly)CGFloat tabbarHeight;
/** documents文件夹路径  */
//+ (NSString *)documentsFilePath;
@property(class, nonatomic, readonly)NSString *documentsFilePath;
/** ================================================  */

/** 获取build版本号 */
+ (NSString *)buildVersion;

/** 获取bundleId  */
//+ (NSString *)bundleIdentifier;
@property(class, nonatomic, readonly)NSString *bundleIdentifier;
//系统版本
//+ (NSString *)systemVersion;
@property(class, nonatomic, readonly)NSString *systemVersion;
//App版本号
//+ (NSString *)shortVersionString;
@property(class, nonatomic, readonly)NSString *shortVersionString;
/** 屏幕宽度与 375.0的比例  */
@property(class, nonatomic, readonly)CGFloat screenWidthRate;

/** 屏幕宽度 */
@property(class, nonatomic, readonly)CGFloat screenWidth;
/** 屏幕高度 */
@property(class, nonatomic, readonly)CGFloat screenHeight;

@end
