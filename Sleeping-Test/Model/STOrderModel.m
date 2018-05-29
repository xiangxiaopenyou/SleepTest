//
//  STOrderModel.m
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/5/28.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "STOrderModel.h"

@implementation STOrderModel
+ (void)submitData:(STOrderModel *)model dataArray:(NSArray *)array handler:(RequestResultHandler)handler {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:model.recordId forKey:@"recordId"];
    [params setObject:model.sceneId forKey:@"sceneId"];
    [params setObject:model.patientId forKey:@"patientId"];
    NSString *dataString = [array componentsJoinedByString:@","];
    [params setObject:dataString forKey:@"xldata"];
    [[STBaseRequest new] postRequest:params requestURL:@"submitData" result:^(id object, NSString *message) {
        if (object) {
            !handler ?: handler(object, nil);
        } else {
            !handler ?: handler(nil, message);
        }
    }];
}

@end
