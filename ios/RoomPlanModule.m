//
//  RoomPlanManager.m
//  RoomPlanApp
//
//  Created by Water on 2/4/25.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RoomPlanModule, NSObject)
RCT_EXTERN_METHOD(startScanning:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(stopScanning)
@end

