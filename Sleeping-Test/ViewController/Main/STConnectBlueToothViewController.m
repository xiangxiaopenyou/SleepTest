//
//  XJTConnectBlueToothViewController.m
//  InHeart-Training
//
//  Created by 项小盆友 on 2018/2/27.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import "STConnectBlueToothViewController.h"
#import "STMainViewController.h"
#import "STLoginViewController.h"
#import "STBlueToothCell.h"
#import "XLAlertControllerObject.h"
#import "STBleManager.h"
#import "STUserManager.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface STConnectBlueToothViewController ()<UITableViewDataSource, UITableViewDelegate, CBPeripheralDelegate, STBleManagerConnectDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewOfBlueTooth;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic, strong) CBCentralManager *manager;
//@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) NSMutableArray *bleArray;

@end

@implementation STConnectBlueToothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewOfBlueTooth.layer.borderColor = STHexRGBColorWithAlpha(0xe6e6e6, 1).CGColor;
    [STBleManager sharedBleManager].connectDelegate = self;
    [STBleManager sharedBleManager].centralStatusBlock = ^(BOOL state) {
        if (!state) {
            STShowHUDTip(NO, @"请连接蓝牙");
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    };
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[STBleManager sharedBleManager].manager scanForPeripheralsWithServices:nil options:nil];
    if (self.bleArray.count == 0) {
        self.bleArray = [[STBleManager sharedBleManager].blesArray mutableCopy];
    }
    if (![[STUserManager sharedUserInfo] isLogined]) {
        STLoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"STLogin"];
        [self presentViewController:loginController animated:NO completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Ble manager connect delegate
- (void)didDiscoverUsefulPeripheral:(NSArray *)peripheralsArray {
    self.bleArray = [peripheralsArray mutableCopy];
    [self.tableView reloadData];
}
- (void)didReceiveConnectResult:(STBleConnectStatus)connectStatus {
    if (connectStatus == STBleConnectStatusSuccess) {
        STMainViewController *mainController = [self.storyboard instantiateViewControllerWithIdentifier:@"STMain"];
        [self.navigationController pushViewController:mainController animated:YES];
    }
}


#pragma mark - Peripheral delegate

/**
 扫描服务
 
 @param peripheral 设备
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        NSLog(@"服务:%@", service.UUID.UUIDString);
        if ([service.UUID.UUIDString isEqualToString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

/**
 扫描到对应的特征
 
 @param peripheral 设备
 @param service 特征对应的服务
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"特征值:%@", characteristic.UUID.UUIDString);
        if ([characteristic.UUID.UUIDString isEqualToString:@"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            _writeCharacteristic = characteristic;
        }
        if ([characteristic.UUID.UUIDString isEqualToString:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            // 订阅特征通知
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}
//向peripheral中写入数据后的回调函数
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
}
/**
 根据特征读到数据
 
 @param peripheral 读取到数据对应的设备
 @param characteristic 特征
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSData *data = characteristic.value;
    NSLog(@"%@", data);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STBlueToothCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STBlueToothCell" forIndexPath:indexPath];
    CBPeripheral *tempPeripheral = self.bleArray[indexPath.row];
    cell.nameLabel.text = tempPeripheral.name;
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *tempPeripheral = self.bleArray[indexPath.row];
    [XLAlertControllerObject showWithTitle:[NSString stringWithFormat:@"连接%@吗？", tempPeripheral.name] message:nil cancelTitle:@"取消" ensureTitle:@"连接" ensureBlock:^{
        [[STBleManager sharedBleManager] connectPeripheral:tempPeripheral];
    }];
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
- (NSMutableArray *)bleArray {
    if (!_bleArray) {
        _bleArray = [[NSMutableArray alloc] init];
    }
    return _bleArray;
}

@end
