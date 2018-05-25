//
//  STBaseRequest.h
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/5/21.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^RequestResultHandler)(id object, NSString *message);
typedef BOOL (^ParamsBlock)(id request);

@interface STBaseRequest : NSObject
@property (strong, nonatomic) NSMutableDictionary *params;
- (void)postRequest:(NSDictionary *)params requestURL:(NSString *)urlString result:(RequestResultHandler)handler;

@end
