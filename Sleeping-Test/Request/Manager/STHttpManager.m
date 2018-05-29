//
//  STHttpManager.m
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/5/21.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "STHttpManager.h"
static NSString * const BASEURL = @"http://10.12.254.34:8080/api/v1/appDevelopmentControllerSm/";

@implementation STHttpManager
+ (instancetype)sharedManager {
    static STHttpManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[STHttpManager alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [requestSerializer setHTTPShouldHandleCookies:YES];
        AFJSONResponseSerializer *responceSerializer = [AFJSONResponseSerializer serializer];
        NSMutableSet *types = [[responceSerializer acceptableContentTypes] mutableCopy];
        [types addObjectsFromArray:@[@"text/plain", @"text/html"]];
        responceSerializer.acceptableContentTypes = types;
        instance.requestSerializer = requestSerializer;
        instance.responseSerializer = responceSerializer;
        [NSURLSessionConfiguration defaultSessionConfiguration].HTTPMaximumConnectionsPerHost = 1;
    });
    return instance;
}

@end
