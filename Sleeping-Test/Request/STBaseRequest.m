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
- (instancetype)init {
    self = [super init];
    if (self) {
        self.params = [[NSMutableDictionary alloc] init];
        if ([[NSUserDefaults standardUserDefaults] stringForKey:USERTOKEN]) {
            NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:USERTOKEN];
            [self.params setObject:token forKey:@"token"];
        }
    }
    return self;
}
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
