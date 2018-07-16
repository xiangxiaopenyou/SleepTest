//
//  STUtilities.h
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/5/23.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STUtilities : NSObject
+ (NSString *)hexStringFromString:(NSString *)str;
+ (NSInteger)hexByDecimal:(NSInteger)decimal;
+ (NSInteger)numberWithHexString:(NSString *)hexString;
+ (NSString *)convertDataToHexStr:(NSData *)data;
+ (void)showHUDWithMessage:(NSString *)message;
+ (void)hideHUD;
+ (void)showHUDTip:(BOOL)isSuccess message:(NSString *)message;
+ (BOOL)isNullObject:(id)anObject;
+ (NSInteger)compareDate:(NSDate *)date;
@end
