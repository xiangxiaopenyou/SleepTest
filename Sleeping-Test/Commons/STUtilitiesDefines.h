//
//  STUtilitiesDefines.h
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/5/23.
//  Copyright © 2018年 项小盆友. All rights reserved.
//
#import "STUtilities.h"
//系统字体
#define STSystemFont(x) [UIFont systemFontOfSize:x]
#define STBoldSystemFont(x) [UIFont boldSystemFontOfSize:x]

/**
 *  RGB颜色
 */
#define STRGBColor(r,g,b,a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/**
 *  Hex颜色转RGB颜色
 */
#define STHexRGBColorWithAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
//主界面
#define STKeyWindow [UIApplication sharedApplication].keyWindow

//string转换成十六进制字符串
#define STHexStringFromString(aString) [STUtilities hexStringFromString:aString]

//十进制转十六进制
#define STHexByDecimal(aDecimal) [STUtilities hexByDecimal:aDecimal]

//十六进制字符串转数字
#define STNumberWithHexString(aString) [STUtilities numberWithHexString:aString]

//NSData转换成十六进制字符串
#define STConvertDataToHexStr(aData) [STUtilities convertDataToHexStr:aData]

//加载提示
#define STShowHUDWithMessage(aString) [STUtilities showHUDWithMessage:aString]

//隐藏HUD
#define STHideHUD [STUtilities hideHUD]

//成功失败提示
#define STShowHUDTip(aSuccess, aMessage) [STUtilities showHUDTip:aSuccess message:aMessage]

//判断空值
#define STIsNullObject(aObject) [STUtilities isNullObject:aObject]

//计算相差多少秒
#define STCompareDate(aDate) [STUtilities compareDate:aDate]
