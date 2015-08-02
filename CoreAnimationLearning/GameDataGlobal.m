//
//  GameDataGlobal.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/5/31.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "GameDataGlobal.h"
#import "GameKeyValue.h"
#import "GameCenter.h"
#import <AVFoundation/AVFoundation.h>

static NSString *GameDataGlobalKEY = @"GameDataGlobalKEY";
static NSString *GameDataIsFirstInstall = @"GameDataIsFirstInstall";
static NSString *GameDataIsNOADS = @"GameDataIsNOADS";

@interface GameDataGlobal()
@property(nonatomic, retain) AVAudioPlayer *audioplayerCorrect;
@property(nonatomic, retain) AVAudioPlayer *audioMain;
@end

@implementation GameDataGlobal
+(id)shareInstance{
    static GameDataGlobal *game = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        game = [[GameDataGlobal alloc] init];
    });
    return game;
}


#pragma mark - 音效
+(void)playAudioIsCorrect:(int)statue{
    if([[GameDataGlobal shareInstance] gameVoiceClose]){
        return;
    }
    
    NSString *stringCottect = [NSString stringWithFormat:@"music_%d.mp3",statue];
    if (statue == 4) {
        stringCottect = @"music_error.mp3";
    }else if (statue ==5){
        stringCottect = @"music_click.mp3";
    }
    
    //1.音频文件的url路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:stringCottect withExtension:Nil];
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    AVAudioPlayer *audioplayerCorrect=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    //3.缓冲
    [audioplayerCorrect prepareToPlay];
    [audioplayerCorrect play];
    [[GameDataGlobal shareInstance] setAudioplayerCorrect:audioplayerCorrect];
}

+(void)playAudioMainMusic{
    GameDataGlobal *dataGlobal = [GameDataGlobal shareInstance];
    dataGlobal.gameMusicClose = !dataGlobal.gameMusicClose;
    
    if(![[GameDataGlobal shareInstance] gameMusicClose]){
        [[GameDataGlobal shareInstance] setAudioMain:nil];
        return;
    }
    
    NSString *stringCottect = [NSString stringWithFormat:@"music_main.mp3"];
    //1.音频文件的url路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:stringCottect withExtension:Nil];
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    AVAudioPlayer *audioplayerCorrect=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    //3.缓冲
    [audioplayerCorrect prepareToPlay];
    [audioplayerCorrect play];
    audioplayerCorrect.numberOfLoops = 10000;
    [[GameDataGlobal shareInstance] setAudioMain:audioplayerCorrect];
}

+(void)playAudioWithStarNum:(int)starNum{
    NSString *stringCottect = [NSString stringWithFormat:@"music_star_%d.mp3",starNum];
    
    //1.音频文件的url路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:stringCottect withExtension:Nil];
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    AVAudioPlayer *audioplayerCorrect=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    //3.缓冲
    [audioplayerCorrect prepareToPlay];
    [audioplayerCorrect play];
    [[GameDataGlobal shareInstance] setAudioplayerCorrect:audioplayerCorrect];
}

+(void)playAudioNumAdd{
    NSString *stringCottect = [NSString stringWithFormat:@"music_num_add.mp3"];
    
    //1.音频文件的url路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:stringCottect withExtension:Nil];
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    AVAudioPlayer *audioplayerCorrect=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    //3.缓冲
    [audioplayerCorrect prepareToPlay];
    [audioplayerCorrect play];
    [[GameDataGlobal shareInstance] setAudioplayerCorrect:audioplayerCorrect];
}

+(void)playAudioFireworkShot{
    NSString *stringCottect = [NSString stringWithFormat:@"music_firework_shot.mp3"];
    
    //1.音频文件的url路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:stringCottect withExtension:Nil];
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    AVAudioPlayer *audioplayerCorrect=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    //3.缓冲
    [audioplayerCorrect prepareToPlay];
    [audioplayerCorrect play];
    [[GameDataGlobal shareInstance] setAudioplayerCorrect:audioplayerCorrect];
}

+(void)playAudioFireworkExplot{
    NSString *stringCottect = [NSString stringWithFormat:@"music_firework_explot.mp3"];
    
    //1.音频文件的url路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:stringCottect withExtension:Nil];
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    AVAudioPlayer *audioplayerCorrect=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    //3.缓冲
    [audioplayerCorrect prepareToPlay];
    [audioplayerCorrect play];
    [[GameDataGlobal shareInstance] setAudioplayerCorrect:audioplayerCorrect];
}

+(void)playAudioSwitch{
    NSString *stringCottect = [NSString stringWithFormat:@"music_screen_switch.mp3"];
    
    //1.音频文件的url路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:stringCottect withExtension:Nil];
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    AVAudioPlayer *audioplayerCorrect=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    //3.缓冲
    [audioplayerCorrect prepareToPlay];
    [audioplayerCorrect play];
    [[GameDataGlobal shareInstance] setAudioplayerCorrect:audioplayerCorrect];
}

+(void)playAudioCheer{
    NSString *stringCottect = [NSString stringWithFormat:@"music_finish_cheer.mp3"];
    
    //1.音频文件的url路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:stringCottect withExtension:Nil];
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    AVAudioPlayer *audioplayerCorrect=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    //3.缓冲
    [audioplayerCorrect prepareToPlay];
    [audioplayerCorrect play];
    [[GameDataGlobal shareInstance] setAudioplayerCorrect:audioplayerCorrect];
}

#pragma mark - game result
+(void)gameResultAddBrockenBlocks:(int)blocks{
    int allBlocksPre = [GameDataGlobal getAllBlockenBlocks];
    allBlocksPre += blocks;
    [GameKeyValue setObject:[NSNumber numberWithInt:allBlocksPre] forKey:GameDataGlobalKEY];
    [GameKeyValue synchronize];
    GameCenter *gameCenter = [[GameCenter alloc] init];
    [gameCenter reportScore:allBlocksPre forCategory:@"1002"];
}

+(void)sendPerfectAchivement{
    GameCenter *gameCenter = [[GameCenter alloc] init];
    [gameCenter reportAchievementIdentifier:@"1004" percentComplete:100.0];
}

+(int)getAllBlockenBlocks{
    return [[GameKeyValue objectForKey:GameDataGlobalKEY] intValue];
}

#pragma mark - colorSetting

+(UIColor *)getMainScreenBackgroundColor{
    return [UIColor colorWithRed:235/255.0 green:219/255.0 blue:197/255.0 alpha:1.0];
//    return [UIColor whiteColor];
}

+(UIColor *)getLockColor{
   return [UIColor colorWithRed:145.0/255.0 green:115.0/255.0 blue:145.0/255.0 alpha:1.0];
}

+(UIColor *)getUnLockColor{
    return [UIColor colorWithRed:10/255.0 green:83/255.0 blue:84/255.0 alpha:1.0];
}

+(UIColor *)getColorInColorType:(int)blockcolorType{
    switch (blockcolorType) {
        case 0:
            return nil;
            break;
        case 1:
            return [UIColor colorWithRed:0/255.0 green:157/255.0 blue:136/255.0 alpha:1.0];;
            break;
        case 2:
            return [UIColor colorWithRed:186/255.0 green:131/255.0 blue:164/255.0 alpha:1.0];
            break;
        case 3:
            return [UIColor colorWithRed:96/255.0 green:127/255.0 blue:87/255.0 alpha:1.0];
            break;
        case 4:
            return [UIColor colorWithRed:133/255.0 green:181/255.0 blue:180/255.0 alpha:1.0];
            break;
            
        case 5:
            return [UIColor colorWithRed:253/255.0 green:102/255.0 blue:107/255.0 alpha:1.0];
            break;
        case 6://
            return [UIColor colorWithRed:0/255.0 green:101/255.0 blue:148/255.0 alpha:1.0];
            break;
        case 7:
            return [UIColor colorWithRed:200/255.0 green:103/255.0 blue:64/255.0 alpha:1.0];
            break;
        case 8:
            return [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
            break;
        case 9:
            return [UIColor colorWithRed:110/255.0 green:83/255.0 blue:84/255.0 alpha:1.0];
            break;
        case 10:
            return [UIColor colorWithRed:234/255.0 green:97/255.0 blue:156/255.0 alpha:1.0];
            break;
        case 11:
            return [UIColor colorWithRed:220/255.0 green:83/255.0 blue:44/255.0 alpha:1.0];
            break;
        case 12:
            return [UIColor colorWithRed:200/255.0 green:30/255.0 blue:84/255.0 alpha:1.0];
            break;
            
        default:
            return nil;
            break;
    }
    return nil;
}

+(UIImage *)getImageForindex:(int)imageIndex{
    return [UIImage imageNamed:[NSString stringWithFormat:@"image_star_%d",imageIndex]];
}


#pragma mark - global setting
//判断是否是第一次安装
+(BOOL)gameIsFirstTimePlay{
    BOOL isNoFirstInstall = [[GameKeyValue objectForKey:GameDataIsFirstInstall] boolValue];
    if (!isNoFirstInstall) {
        [GameKeyValue setObject:[NSNumber numberWithBool:YES] forKey:GameDataIsFirstInstall];
    }
    
    return !isNoFirstInstall;
}

+(BOOL)gameIsNoADS{
    BOOL isNOADS = [[GameKeyValue objectForKey:GameDataIsNOADS] boolValue];
    return isNOADS;
}

+(void)gameSetIsNOADS{
    [GameKeyValue setObject:[NSNumber numberWithBool:YES] forKey:GameDataIsNOADS];
}
@end
