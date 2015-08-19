//
//  GameDataGlobal.h
//  CoreAnimationLearning
//
//  Created by JFChen on 15/5/31.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//视频播放完成，成功给用户结算后
extern NSString *NotificationShouldRefreshEnergyLabel;

@interface GameDataGlobal : NSObject
@property(nonatomic,assign) BOOL gameVoiceClose;
@property(nonatomic,assign) BOOL gameMusicClose;

+(id)shareInstance;
//播放视频广告
-(void)playVideo;
//展示插屏
-(void)showSpot;

//设置体力值
+(void)setGameEnergy:(int)energy;
//消耗体力值
+(BOOL)reduceGameEnergy:(int)energy;
//增加体力值
+(void)addGameEnergy:(int)energy;
//剩余体力
+(int)getGameRestEnergy;

//音效
+(void)playAudioIsCorrect:(int)statue;
+(void)playAudioVoiceCloseOrOpen;
+(void)playAudioMainMusic;
+(void)playAudioWithStarNum:(int)starNum;
+(void)playAudioNumAdd;
+(void)playAudioFireworkShot;
+(void)playAudioFireworkExplot;
+(void)playAudioSwitch;
+(void)playAudioCheer;
+(void)playAudioTimeUp;
+(void)playAudioLevel;

//增加被破坏的方块数，并且上传GameCenter
+(void)gameResultAddBrockenBlocks:(int)blocks;
//上报过关的关数
+(void)gameResultGuoguan:(int)guanka;
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
+(void)setGameIsNoFirstTimePlay;

//是否购买了去掉广告
+(BOOL)gameIsNoADS;
+(void)gameSetIsNOADS;

//获取在appStore的链接
+(NSString *)gameGetAppStoreURL;
@end
