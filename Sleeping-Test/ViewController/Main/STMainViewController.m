//
//  STMainViewController.m
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/5/24.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "STMainViewController.h"
#import "YSCWaveView.h"
#import "STBleManager.h"
#import <UIImage+GIF.h>
#import <CloudPushSDK/CloudPushSDK.h>

@interface STMainViewController () <STBleManagerCommunicationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UIView *viewOfContent;
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rateImageView;
@property (nonatomic, strong) YSCWaveView *waveView;
@property (nonatomic, strong) NSMutableArray *heartRateDataArray;
@end

@implementation STMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewOfContent.layer.borderColor = STHexRGBColorWithAlpha(0xe6e6e6, 1).CGColor;
    [STBleManager sharedBleManager].communicationDelegate = self;
    [[STBleManager sharedBleManager] readyForStart];
    
    NSString *ratePath = [[NSBundle mainBundle] pathForResource:@"heart_rate" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:ratePath];
    UIImage *rateImage = [UIImage sd_animatedGIFWithData:imageData];
    
    self.rateImageView.image = rateImage;
    
    [self.viewOfContent addSubview:self.waveView];
    [self.waveView showWaveViewWithType:YSCWaveTypePulse];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageReceived:) name:@"CCPDidReceiveMessageNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Ble manager communication delegate
- (void)bleDidReady {
    //给服务器传送初始化完成指令
//    NSData *data = [@"initialcomplete" dataUsingEncoding:NSUTF8StringEncoding];
//    [[STSocketManager sharedXJTSocketManager] writeDataToService:data];
}
- (void)didReceiveHeartRateData:(NSInteger)rateInt {
    self.heartRateLabel.text = [NSString stringWithFormat:@"%@", @(rateInt)];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *dataString = [NSString stringWithFormat:@"%@+%@+@%@@%@", @(rateInt), @(rateInt), @(rateInt), dateString];
    [self.heartRateDataArray addObject:dataString];
}

//处理到来推送消息
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Getters
- (YSCWaveView *)waveView {
    if (!_waveView) {
        _waveView = [[YSCWaveView alloc] initWithFrame:CGRectMake(- 120, 120, CGRectGetWidth(self.viewOfContent.frame) + 120, CGRectGetHeight(self.viewOfContent.frame) - 120)];
        _waveView.backgroundColor = [UIColor whiteColor];
    }
    return _waveView;
}
- (NSMutableArray *)heartRateDataArray {
    if (!_heartRateDataArray) {
        _heartRateDataArray = [[NSMutableArray alloc] init];
    }
    return _heartRateDataArray;
}

@end
