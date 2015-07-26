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
@property(nonatomic,assign) BOOL gameVoiceClose;
@property(nonatomic,assign) BOOL gameMusicClose;

+(id)shareInstance;

//播放音效
+(void)playAudioIsCorrect:(int)statue;
+(void)playAudioMainMusic;
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

//获取图片
+(UIImage *)getImageForindex:(int)imageIndex;

//判断是否是第一次安装
+(BOOL)gameIsFirstTimePlay;

//是否购买了去掉广告
+(BOOL)gameIsNoADS;
+(void)gameSetIsNOADS;
@end
