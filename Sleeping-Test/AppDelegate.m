//
//  AppDelegate.m
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/5/21.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "AppDelegate.h"
#import <CloudPushSDK/CloudPushSDK.h>

static NSString * const kSTAliCloudPushKey = @"24899704";
static NSString * const kSTAliCloudPushSecret = @"bb59f853ea543e892d24de2a478163c8";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initCloudPush];
    [self registerAPNS:application];
    //[CloudPushSDK sendNotificationAck:launchOptions];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器

 @param application application
 @param deviceToken deviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"deviceToken注册成功");
            NSLog(@"deviceId:%@", [CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"deviceToken注册失败");
        }
    }];
}

/**
 苹果推送注册失败回调

 @param application application
 @param error 错误信息
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}

/**
 初始化阿里云推送SDK
 */
- (void)initCloudPush {
    [CloudPushSDK asyncInit:kSTAliCloudPushKey appSecret:kSTAliCloudPushSecret callback:^(CloudPushCallbackResult *res) {
    }];
}

/**
 注册苹果推送，获取deviceToken用于推送

 @param application application
 */
- (void)registerAPNS:(UIApplication *)application {
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [application registerForRemoteNotifications];
}

- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
}


@end
