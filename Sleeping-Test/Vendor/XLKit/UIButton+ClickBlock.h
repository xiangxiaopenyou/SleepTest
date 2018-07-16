//
//  UIButton+ClickBlock.h
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/5/30.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickBlock)(id sender);

@interface UIButton (ClickBlock)
- (void)clickWithBlock:(ClickBlock)block;

@end
