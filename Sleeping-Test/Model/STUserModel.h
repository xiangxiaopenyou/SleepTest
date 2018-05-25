//
//  XJSUserModel.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/27.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "STBaseModel.h"

@interface STUserModel : STBaseModel
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *userId;

+ (void)login:(NSDictionary *)params handler:(RequestResultHandler)handler;
+ (void)logout:(RequestResultHandler)handler;
@end
