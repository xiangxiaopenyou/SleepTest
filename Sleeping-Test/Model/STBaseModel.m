//
//  IMBaseModel.m
//  IMTest
//
//  Created by 项小盆友 on 2018/4/26.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "STBaseModel.h"

@implementation STBaseModel
/// 将 JSON (NSData,NSString,NSDictionary) 转换为 Model
+ (instancetype)modelWithJSON:(id)json { return [self yy_modelWithJSON:json]; }

/// json-array 转 模型-数组
+ (NSArray *)modelArrayWithJSON:(id)json {
    return [NSArray yy_modelArrayWithClass:[self class] json:json];
}

/// 字典转模型
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary{
    return [self yy_modelWithDictionary:dictionary];
}

- (id)toJSONObject {
    return [self yy_modelToJSONObject];
}
- (NSData *)toJSONData {
    return [self yy_modelToJSONData];
}
- (NSString *)toJSONString {
    return [self yy_modelToJSONString];
}

@end
