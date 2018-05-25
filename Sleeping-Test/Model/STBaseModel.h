//
//  IMBaseModel.h
//  IMTest
//
//  Created by 项小盆友 on 2018/4/26.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

#import "STBaseRequest.h"

@interface STBaseModel : NSObject <YYModel>
/// 将 Json (NSData，NSString，NSDictionary) 转换为 Model
+ (instancetype)modelWithJSON:(id)json;
/// 字典转模型
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
/// json-array 转换为 模型数组
+ (NSArray *)modelArrayWithJSON:(id)json;


/// 将 Model 转换为 JSON 对象
- (id)toJSONObject;
/// 将 Model 转换为 NSData
- (NSData *)toJSONData;
/// 将 Model 转换为 JSONString
- (NSString *)toJSONString;

@end
