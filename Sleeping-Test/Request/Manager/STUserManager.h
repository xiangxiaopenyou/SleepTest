//
//  XJSUserManager.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/28.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STUserModel.h"
@interface STUserManager : NSObject

+ (STUserManager *)sharedUserInfo;
- (BOOL)isLogined;
- (void)saveUserInfo:(STUserModel *)userModel;
- (void)removeUserInfo;

@end
