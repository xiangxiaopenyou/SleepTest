//
//  STBleManager.h
//  Sleeping-Test
//
//  Created by 项小盆友 on 2018/5/22.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@protocol STBleManagerConnectDelegate <NSObject>
- (void)didDiscoverUsefulPeripheral:(NSArray *)peripheralsArray;
- (void)didReceiveConnectResult:(STBleConnectStatus)connectStatus;
@end

@protocol STBleManagerCommunicationDelegate <NSObject>
- (void)bleDidReady;
- (void)didReceiveHeartRateData:(NSInteger)rateInt;
@end


@interface STBleManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) NSMutableArray *blesArray;
@property (nonatomic, weak) id<STBleManagerConnectDelegate> connectDelegate;
@property (nonatomic, weak) id<STBleManagerCommunicationDelegate> communicationDelegate;
@property (nonatomic, copy) void (^centralStatusBlock)(BOOL state);

+ (STBleManager *)sharedBleManager;
- (void)connectPeripheral:(CBPeripheral *)tempPeripheral;
- (void)disconnectPeripheral:(CBPeripheral *)tempPeripheral;
- (void)readyForStart;
- (void)startCommand;
- (void)writeDateToPeripherial:(NSData *)data;

@end
