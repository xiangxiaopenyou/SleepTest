//
//  STMainNavigationController.m
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/6/1.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "STMainNavigationController.h"
#import "STLoginViewController.h"
#import "XLAlertControllerObject.h"
#import "STUserModel.h"
#import "STUserManager.h"

@interface STMainNavigationController () <UINavigationControllerDelegate, UINavigationBarDelegate>

@end

@implementation STMainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logoutAction {
    [XLAlertControllerObject showWithTitle:@"确定要注销吗？" message:nil cancelTitle:@"取消" ensureTitle:@"确定" ensureBlock:^{
        STShowHUDWithMessage(@"正在注销...");
        [STUserModel logout:^(id object, NSString *message) {
            STHideHUD;
            if (object) {
                STShowHUDTip(YES, @"注销成功");
                [[STUserManager sharedUserInfo] removeUserInfo];
                [self popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"STLoginStatusDidChange" object:nil];
            } else {
                STShowHUDTip(NO, message);
            }
        }];
    }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logoutAction)];
    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
