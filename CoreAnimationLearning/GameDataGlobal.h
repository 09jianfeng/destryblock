//
//  GameDataGlobal.h
//  CoreAnimationLearning
//
//  Created by JFChen on 15/5/31.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GameDataGlobal : NSObject
//播放音效
+(void)playAudioIsCorrect:(int)statue;
//增加被破坏的方块数
+(void)gameResultAddBrockenBlocks:(int)blocks;
//获得被破坏的方块总数
+(int)getAllBlockenBlocks;
//发送完美爆破成就
+(void)sendPerfectAchivement;

//颜色
+(UIColor *)getMainScreenBackgroundColor;
+(UIColor *)getLockColor;
+(UIColor *)getUnLockColor;
+(UIColor *)getColorInColorType:(int)blockcolorType;

+(UIImage *)getImageForindex:(int)imageIndex;
@end
