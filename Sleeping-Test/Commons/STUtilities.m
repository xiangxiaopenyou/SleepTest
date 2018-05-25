//
//  STUtilities.m
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/5/23.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "STUtilities.h"
#import <MBProgressHUD.h>

@implementation STUtilities
+ (NSString *)hexStringFromString:(NSString *)str {
    if (!str || [str length] == 0) {
        return @"";
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    NSString *tempString = [string copy];
    NSInteger cha = 30 - tempString.length;
    for (NSInteger i = 0; i < cha; i ++) {
        tempString = [tempString stringByAppendingString:@"0"];
    }
    return tempString;
}
+ (NSInteger)hexByDecimal:(NSInteger)decimal {
    NSString *hex = @"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i < 9; i++) {
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    return hex.integerValue;
}
+ (NSInteger)numberWithHexString:(NSString *)hexString {
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}
+ (void)showHUDWithMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:STKeyWindow animated:YES];
    hud.square = YES;
    hud.label.text = message;
}
+ (void)hideHUD {
    [MBProgressHUD hideHUDForView:STKeyWindow animated:YES];
}
+ (void)showHUDTip:(BOOL)isSuccess message:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:STKeyWindow animated:YES];
    hud.detailsLabel.text = message;
    UIImageView *customImage = [[UIImageView alloc] init];
    customImage.image = isSuccess ? [UIImage imageNamed:@"success_tip"] : [UIImage imageNamed:@"error_tip"];
    hud.customView = customImage;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.f];
}

+ (BOOL)isNullObject:(id)anObject {
    if (!anObject || [anObject isEqual:@""] || [anObject isEqual:[NSNull null]] || [anObject isKindOfClass:[NSNull class]]) {
        return YES;
    } else {
        return NO;
    }
}

@end
