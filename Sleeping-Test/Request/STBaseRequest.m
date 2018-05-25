//
//  STBaseRequest.m
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/5/21.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "STBaseRequest.h"
#import "STHttpManager.h"

@implementation STBaseRequest
- (void)postRequest:(NSDictionary *)params requestURL:(NSString *)urlString result:(RequestResultHandler)handler {
    if (params) {
        [self.params addEntriesFromDictionary:params];
    }
    [[STHttpManager sharedManager] POST:urlString parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !handler ?: handler(responseObject[@"data"], nil);
        } else {
            !handler ?: handler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !handler ?: handler(nil, @"请检查网络");
    }];
}

@end
