//
//  XJSLoginViewController.m
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/20.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "STLoginViewController.h"
#import "STUserModel.h"
#import "STUserManager.h"

@interface STLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYConstraintOfContentView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation STLoginViewController
#pragma mark - View controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - IBAction
- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    if (STIsNullObject(self.usernameTextField.text)) {
        STShowHUDTip(NO, @"请输入用户名");
        return;
    }
    if (STIsNullObject(self.passwordTextField.text)) {
        STShowHUDTip(NO, @"请输入密码");
        return;
    }
    STShowHUDWithMessage(nil);
    NSDictionary *params = @{@"username" : self.usernameTextField.text,
                             @"password" : self.passwordTextField.text
                             };
    [STUserModel login:params handler:^(id object, NSString *msg) {
        STHideHUD;
        if (object) {
            STShowHUDTip(YES, @"登录成功");
            STUserModel *model = (STUserModel *)object;
            [[STUserManager sharedUserInfo] saveUserInfo:model];
        } else {
            STShowHUDTip(NO, msg);
        }
    }];
}
#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification *)notification {
    self.centerYConstraintOfContentView.constant = - 150;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    self.centerYConstraintOfContentView.constant = - 80;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
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
