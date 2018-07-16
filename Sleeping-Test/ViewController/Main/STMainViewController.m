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
#import "STUserModel.h"
#import "STUserManager.h"
#import "STOrderModel.h"
#import "XLAlertControllerObject.h"
#import <UIImage+GIF.h>
#import <CloudPushSDK/CloudPushSDK.h>
#import <UIImageView+WebCache.h>

@interface STMainViewController () <STBleManagerCommunicationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *sceneImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIView *viewOfContent;
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rateImageView;
@property (weak, nonatomic) IBOutlet UILabel *sceneNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (nonatomic, strong) YSCWaveView *waveView;
@property (nonatomic, strong) NSMutableArray *heartRateDataArray;
@property (nonatomic, strong) STOrderModel *model;
@end

@implementation STMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    self.viewOfContent.layer.borderColor = STHexRGBColorWithAlpha(0xe6e6e6, 1).CGColor;
    [STBleManager sharedBleManager].communicationDelegate = self;
    [[STBleManager sharedBleManager] readyForStart];
    
    NSString *ratePath = [[NSBundle mainBundle] pathForResource:@"heart_rate" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:ratePath];
    UIImage *rateImage = [UIImage sd_animatedGIFWithData:imageData];
    self.rateImageView.image = rateImage;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageReceived:) name:@"CCPDidReceiveMessageNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleDidDisconnect) name:@"STBleDidDisconnect" object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[STBleManager sharedBleManager] endCommand];
    [[STBleManager sharedBleManager] disconnectPeripheral];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CCPDidReceiveMessageNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"STBleDidDisconnect" object:nil];
}

#pragma mark - Private method
- (void)setupContentData:(STOrderModel *)model {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.sceneImageView sd_setImageWithURL:[NSURL URLWithString:model.sceneImageUrl]];
        self.sceneNameLabel.text = model.sceneName;
        self.nameLabel.text = model.name;
        self.ageLabel.text = [NSString stringWithFormat:@"%@岁", model.age];
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        dateString = [dateString substringToIndex:19];
        self.beginTimeLabel.text = dateString;
    });
}
- (void)localRecordData {
    NSDictionary *localDcitioary = [[STUserManager sharedUserInfo] recordData];
    if (localDcitioary && localDcitioary[@"recordId"]) {
        self.heartRateDataArray = [localDcitioary[@"dataArray"] mutableCopy];
        [self fetchRecordData:localDcitioary];
    }
}
//开始测试
- (void)startRecord:(STOrderModel *)orderModel {
    [[STBleManager sharedBleManager] startCommand:orderModel];
    [self setupContentData:orderModel];
    self.model = orderModel;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewOfContent addSubview:self.waveView];
        [self.waveView showWaveViewWithType:YSCWaveTypePulse];
    });
}
//结束测试
- (void)endRecord:(STOrderModel *)orderModel {
    [[STBleManager sharedBleManager] endCommand];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.waveView removeFromParentView];
        if (self.heartRateDataArray.count > 0) {
            //提交测试数据
            [STOrderModel submitData:orderModel dataArray:self.heartRateDataArray handler:^(id object, NSString *message) {
                [self.heartRateDataArray removeAllObjects];
                self.model = nil;
                [[STUserManager sharedUserInfo] removeRecordData];
                if (object) {
                    STShowHUDTip(YES, @"测试完成");
                } else {
                    STShowHUDTip(NO, message);
                }
            }];
        }
    });
}

#pragma mark - Request
- (void)fetchRecordData:(NSDictionary *)dictionary {
    [STOrderModel fetchPlayingRecordData:dictionary[@"recordId"] handler:^(STOrderModel *object, NSString *message) {
        if (object) {
            if (object.state.integerValue == 0) {   //测试未结束，继续开始数据记录
                NSInteger second = STCompareDate((NSDate *)dictionary[@"date"]);
                for (NSInteger i = 0; i < second / 6; i ++) {
                    [self.heartRateDataArray addObject:[NSString stringWithFormat:@"%@", @0]];
                }
                [self startRecord:object];
            } else {                                //测试已结束，上传已有数据
                [self endRecord:object];
            }
        }
    }];
}

#pragma mark - Notification
//蓝牙断开连接
- (void)bleDidDisconnect {
    if (self.model.recordId && self.model.sceneId && self.model.patientId) {
        NSDate *currentDate = [NSDate date];
        NSDictionary *temp = @{@"recordId" : self.model.recordId,
                               @"sceneId" : self.model.sceneId,
                               @"patientId" : self.model.patientId,
                               @"dataArray" : self.heartRateDataArray,
                               @"date" : currentDate
                               };
        [[STUserManager sharedUserInfo] saveRecordData:temp];
    }
}

#pragma mark - Ble manager communication delegate
- (void)bleDidReady {
    //给服务器传送初始化完成指令
//    NSData *data = [@"initialcomplete" dataUsingEncoding:NSUTF8StringEncoding];
//    [[STSocketManager sharedXJTSocketManager] writeDataToService:data];
    [self localRecordData];
}
- (void)didReceiveHeartRateData:(NSInteger)rateInt {
    self.heartRateLabel.text = [NSString stringWithFormat:@"%@", @(rateInt)];
//    NSDate *currentDate = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *dateString = [dateFormatter stringFromDate:currentDate];
//    NSString *dataString = [NSString stringWithFormat:@"%@+%@+@%@@%@", @(rateInt), @(rateInt), @(rateInt), dateString];
    [self.heartRateDataArray addObject:[NSString stringWithFormat:@"%@", @(rateInt)]];
}

#pragma mark - Notification
//处理到来推送消息
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:message.body options:NSJSONReadingMutableContainers error:nil];
    STOrderModel *orderModel = [STOrderModel modelWithDictionary:bodyDictionary];
    if (orderModel.type.integerValue == 1) {    //开始指令
        [self.heartRateDataArray removeAllObjects];
        [self startRecord:orderModel];
    } else {                                    //结束指令
        [self endRecord:orderModel];
    }
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
