//
//  XJSUserModel.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/27.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "STUserModel.h"

@implementation STUserModel
+ (void)login:(NSDictionary *)params handler:(RequestResultHandler)handler {
    [[STBaseRequest new] postRequest:params requestURL:@"login" result:^(id object, NSString *message) {
        if (object) {
            STUserModel *userModel = [STUserModel modelWithDictionary:(NSDictionary *)object];
            !handler ?: handler(userModel, nil);
        } else {
            !handler ?: handler(nil, message);
        }
    }];
}
+ (void)logout:(RequestResultHandler)handler {
    [[STBaseRequest new] postRequest:nil requestURL:@"logout" result:^(id object, NSString *message) {
        if (object) {
            !handler ?: handler(object, nil);
        } else {
            !handler ?: handler(nil, message);
        }
    }];
}

@end
