//
//  STOrderModel.h
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/5/28.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "STBaseModel.h"

@interface STOrderModel : STBaseModel
@property (copy, nonatomic) NSString *recordId;
@property (strong, nonatomic) NSNumber *type;
@property (copy, nonatomic) NSString *patientId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *sceneId;
@property (copy, nonatomic) NSString *sceneName;
@property (copy, nonatomic) NSString *sceneImageUrl;
@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSNumber *state;

+ (void)fetchPlayingRecordData:(NSString *)recordId handler:(RequestResultHandler)handler;
+ (void)submitData:(STOrderModel *)model dataArray:(NSArray *)array handler:(RequestResultHandler)handler;
@end
