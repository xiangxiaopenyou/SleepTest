//
//  UIButton+ClickBlock.m
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/5/30.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "UIButton+ClickBlock.h"
#import <objc/runtime.h>
static NSString * const XLButtonClickKey = @"XLButtonClick";


@implementation UIButton (ClickBlock)
- (void)clickWithBlock:(ClickBlock)block
{
    if (block) {
        objc_setAssociatedObject(self, &XLButtonClickKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)clickAction:(id)sender
{
    ClickBlock block = objc_getAssociatedObject(self, &XLButtonClickKey);
    if (block) {
        block(sender);
    }
}

@end
