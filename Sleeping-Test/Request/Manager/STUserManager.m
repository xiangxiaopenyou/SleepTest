//
//  XJSUserManager.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/28.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "STUserManager.h"

@implementation STUserManager
+ (STUserManager *)sharedUserInfo {
    static STUserManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[STUserManager alloc] init];
    });
    return instance;
}
- (BOOL)isLogined {
    if ([[NSUserDefaults standardUserDefaults] stringForKey:USERTOKEN]) {
        return YES;
    } else {
        return NO;
    }
}
- (void)saveUserInfo:(STUserModel *)userModel {
    if (userModel.token) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.token forKey:USERTOKEN];
    }
    if (userModel.userId) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.userId forKey:USERID];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)removeUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERTOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)saveRecordData:(NSDictionary *)dictionary {
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:STRecordDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSDictionary *)recordData {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:STRecordDataKey]) {
        NSDictionary *dictionay = [[NSUserDefaults standardUserDefaults] dictionaryForKey:STRecordDataKey];
        return dictionay;
    }
    return nil;
}
- (void)removeRecordData {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:STRecordDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
