//
//  STHttpManager.h
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/5/21.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface STHttpManager : AFHTTPSessionManager
+ (instancetype)sharedManager;

@end
