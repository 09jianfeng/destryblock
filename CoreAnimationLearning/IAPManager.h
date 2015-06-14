//
//  IAPManager.h
//  storyBoardBook
//
//  Created by 陈建峰 on 14-8-22.
//  Copyright (c) 2014年 陈建峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/SKProductsRequest.h>
#import <StoreKit/SKPaymentQueue.h>

@interface IAPManager : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>

+(IAPManager *)shareInstance;
-(void)buy;
-(void)restore;
@end
