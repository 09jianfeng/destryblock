//
//  GameResultData.h
//  CoreAnimationLearning
//
//  Created by JFChen on 15/5/31.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GameResultData : NSObject
+(void)gameResultAddBrockenBlocks:(int)blocks;
+(int)getAllBlockenBlocks;

+(UIColor *)getMainScreenBackgroundColor;

+(UIColor *)getLockColor;
+(UIColor *)getUnLockColor;
+(UIColor *)getColorInColorType:(int)blockcolorType;
@end
