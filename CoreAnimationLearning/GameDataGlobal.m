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
#import "IndependentVideoManager.h"
#import "DMInterstitialAdController.h"
#import "macro.h"
#import "MobClick.h"
#import "GameReachability.h"
#import "GDTMobBannerView.h"
#import "GDTMobInterstitial.h"

#define GAME_CENTER_SCORE_ID @"1002"
#define GAME_CENTER_GUANKA_ID @"1001"
#define GAME_CENTER_PERFECT_ACHIVEMENT @"1004"

//视频播放完成，成功给用户结算后
NSString *NotificationShouldRefreshEnergyLabel = @"NotificationShouldRefreshEnergyLabel";
static NSString *GameDataGlobalKEY = @"GameDataGlobalKEY";
static NSString *GameDataIsFirstInstall = @"GameDataIsFirstInstall";
static NSString *GameDataIsNOADS = @"GameDataIsNOADS";
static NSString *GameDataIsMusicClose = @"GameDataIsMusicClose";
static NSString *GameDataIsVoiceClose = @"GameDataIsVoiceClose";
static NSString *GameDataEnergyStorage = @"GameDataEnergyStorage";
static NSString *GameDataEnergyStorageDay = @"GameDataEnergyStorageDay";
static NSString *GameDataBestRecordGuanka = @"GameDataBestRecordGuanka";
static NSString *GameDataOpenVideoKey = @"GameDataOpenVideoKey";

@interface GameDataGlobal()<IndependentVideoManagerDelegate,DMInterstitialAdControllerDelegate,GDTMobInterstitialDelegate>
{
    GDTMobInterstitial *_interstitialObj;
}

@property(nonatomic, retain) AVAudioPlayer *audioplayerCorrect;
@property(nonatomic, retain) AVAudioPlayer *audioMain;
@property(nonatomic,retain) IndependentVideoManager *independvideo;
@property(nonatomic, assign) BOOL isConnectWifi;
@property(nonatomic, retain) GameReachability *gameReachabi;
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

-(id)init{
    self = [super init];
    if (self) {
        BOOL isMusicCLosed = [[GameKeyValue objectForKey:GameDataIsMusicClose] boolValue];
        self.gameMusicClose = isMusicCLosed;
        BOOL isVoiceCLose = [[GameKeyValue objectForKey:GameDataIsVoiceClose] boolValue];
        self.gameVoiceClose = isVoiceCLose;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_reachabilityChanged:)
                                                     name: GamekReachabilityChangedNotification
                                                   object: nil];
        self.gameReachabi = [GameReachability reachabilityWithHostName:@"www.baidu.com"];
        [self.gameReachabi startNotifier];
        GameNetworkStatus netWorkStatus = [self.gameReachabi currentReachabilityStatus];
        if (netWorkStatus == GameReachableViaWiFi) {
            self.isConnectWifi = YES;
        }
        
        //友盟统计
        [MobClick startWithAppkey:@"55bb39d367e58e305600131d"];
        //在线参数
        [MobClick updateOnlineConfig];
        
        
        //广点通广告设置
        _interstitialObj = [[GDTMobInterstitial alloc] initWithAppkey:@"1105190664"
                                                          placementId:@"4090402818341003"];
        _interstitialObj.delegate = self; //设置委托
        _interstitialObj.isGpsOn = NO;     //【可选】设置GPS开关
        //预加载广告
        [_interstitialObj loadAd];
        
    }
    return self;
}

- (void)_reachabilityChanged:(NSNotification *)note {
    GameReachability* curReach = [note object];
    // 基本没可能
    if(![curReach isKindOfClass: [GameReachability class]]) return;
    NSString *accessPointName= [[self _accessPointNameForStatus:[curReach currentReachabilityStatus]] copy];
    
    GameNetworkStatus status = [curReach currentReachabilityStatus];
    if (status == GameReachableViaWiFi) {
        self.isConnectWifi = YES;
    }else{
        self.isConnectWifi = NO;
    }
    
    HNLOGINFO(@"网络发生改变:%@", accessPointName);
}

- (NSString *)_accessPointNameForStatus:(GameNetworkStatus)status {
    NSString *name = nil;
    switch (status) {
        case GamekNotReachable:
            name = [NSString stringWithFormat:@"%@", @"None"];
            break;
        case GamekReachableViaWWAN:
            name = [NSString stringWithFormat:@"%@", @"GPRS|3G"];
            break;
        case GamekReachableViaWiFi:
            name = [NSString stringWithFormat:@"%@", @"WiFi"];
            break;
        default:
            name = [NSString stringWithFormat:@"%@", @"None"];
            break;
    }
    return name;
}

#pragma mark - 广告
-(BOOL)ymstate{
    return [[MobClick getConfigParams:@"umengCloseym"] boolValue];
}

-(BOOL)dmstate{
    return [[MobClick getConfigParams:@"umengClosedm"] boolValue];
}

//0无效 1打开 2关闭
-(int)videoOpen{
    return [[MobClick getConfigParams:@"umengIsOpenVideo"] intValue];
}

-(void)showdmVideo{
    //用rootViewController来播放
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    //多盟视频
    self.independvideo = [[IndependentVideoManager alloc] initWithPublisherID:@"96ZJ3tqwzex2nwTNt9" andUserID:@"userid"];
    [self.independvideo presentIndependentVideoWithViewController:rootViewController];
    self.independvideo.delegate = self;
}

// !!!:视频广告代码
-(void)playVideo{
    [self showdmVideo];
    [GameDataGlobal playAudioMainMusic];
}

-(void)showSpot{
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow]
                            rootViewController];
    int random = arc4random()%3;
    if (random) {
        return;
    }
    if (_interstitialObj.isReady) {
        HNLOGINFO(@"广点通 ready了");
        [_interstitialObj presentFromRootViewController:vc];
    }else{
        HNLOGINFO(@"广点通 还没ready");
        [_interstitialObj loadAd];
    }
}

#pragma mark - 体力值
//消耗体力值
+(BOOL)reduceGameEnergy:(int)energy{
    if (![GameDataGlobal isOpenVideo]) {
        return YES;
    }
    
    int restGame = [GameDataGlobal getGameRestEnergy];
    if (energy > restGame) {
        return NO;
    }
    
    restGame =  restGame - energy;
    [GameDataGlobal setGameEnergy:restGame];
    return YES;
}

//增加体力值
+(void)addGameEnergy:(int)energy{
    if (![GameDataGlobal isOpenVideo]) {
        return;
    }
    
    int restGame = [GameDataGlobal getGameRestEnergy];
    restGame =  restGame + energy;
    [GameDataGlobal setGameEnergy:restGame];
}

+(void)setGameEnergy:(int)energy{
    if (![GameDataGlobal isOpenVideo]) {
        return;
    }
    
    [GameKeyValue setObject:[NSNumber numberWithInt:energy] forKey:GameDataEnergyStorage];
}

//剩余体力
+(int)getGameRestEnergy{
    if (![GameDataGlobal isOpenVideo]) {
        return 1;
    }
    
    int day = [[GameKeyValue objectForKey:GameDataEnergyStorageDay] intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    int currentDate = [currentDateString intValue];
    
    if (currentDate != day) {
        [GameKeyValue setObject:[NSNumber numberWithInt:currentDate] forKey:GameDataEnergyStorageDay];
        [GameDataGlobal addGameEnergy:3];
    }
    
    int restEnergy = [[GameKeyValue objectForKey:GameDataEnergyStorage] intValue];
    return restEnergy;
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
    
    [self playAudioWithString:stringCottect];
}

+(void)playAudioVoiceCloseOrOpen{
    GameDataGlobal *dataGlobal = [GameDataGlobal shareInstance];
    dataGlobal.gameVoiceClose = !dataGlobal.gameVoiceClose;
    [GameKeyValue setObject:[NSNumber numberWithBool:dataGlobal.gameVoiceClose] forKey:GameDataIsVoiceClose];
}

+(void)closeAudioMainMusic{
    [[GameDataGlobal shareInstance] setAudioMain:nil];
    return;
}

+(void)playAudioMainMusic{
    GameDataGlobal *dataGlobal = [GameDataGlobal shareInstance];
    dataGlobal.gameMusicClose = !dataGlobal.gameMusicClose;
    [GameKeyValue setObject:[NSNumber numberWithBool:!dataGlobal.gameMusicClose] forKey:GameDataIsMusicClose];
    
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
    [self playAudioWithString:stringCottect];
}

+(void)playAudioNumAdd{
    NSString *stringCottect = [NSString stringWithFormat:@"music_num_add.mp3"];
    [self playAudioWithString:stringCottect];
}

+(void)playAudioFireworkShot{
    NSString *stringCottect = [NSString stringWithFormat:@"music_firework_shot.mp3"];
    [self playAudioWithString:stringCottect];
}

+(void)playAudioFireworkExplot{
    NSString *stringCottect = [NSString stringWithFormat:@"music_firework_explot.mp3"];
    [self playAudioWithString:stringCottect];
}

+(void)playAudioSwitch{
    NSString *stringCottect = [NSString stringWithFormat:@"music_screen_switch.mp3"];
    [self playAudioWithString:stringCottect];
}

+(void)playAudioCheer{
    NSString *stringCottect = [NSString stringWithFormat:@"music_finish_cheer.mp3"];
    [self playAudioWithString:stringCottect];
}

+(void)playAudioTimeUp{
    NSString *stringCottect = [NSString stringWithFormat:@"music_timeup.mp3"];
    [self playAudioWithString:stringCottect];
}

+(void)playAudioLevel{
    NSString *stringCottect = [NSString stringWithFormat:@"music_level.mp3"];
    [self playAudioWithString:stringCottect];
}

+(void)playAudioWithString:(NSString *)stringCottect{
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
    [gameCenter reportScore:allBlocksPre forCategory:GAME_CENTER_SCORE_ID];
}

//上报过关的关数
+(void)gameResultGuoguan:(int)guanka{
    int guankaBest = [[GameKeyValue objectForKey:GameDataBestRecordGuanka] intValue];
    if (guankaBest >= guanka) {
        return;
    }
    
    [GameKeyValue setObject:[NSNumber numberWithInt:guanka] forKey:GameDataBestRecordGuanka];
    GameCenter *gameCenter = [[GameCenter alloc] init];
    [gameCenter reportScore:guanka forCategory:GAME_CENTER_GUANKA_ID];
    [GameDataGlobal addGameEnergy:1];
}

+(void)sendPerfectAchivement{
    GameCenter *gameCenter = [[GameCenter alloc] init];
    [gameCenter reportAchievementIdentifier:GAME_CENTER_PERFECT_ACHIVEMENT percentComplete:100.0];
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
    return !isNoFirstInstall;
}

+(void)setGameIsNoFirstTimePlay{
    [GameKeyValue setObject:[NSNumber numberWithBool:YES] forKey:GameDataIsFirstInstall];
}

+(BOOL)gameIsNoADS{
    BOOL isNOADS = [[GameKeyValue objectForKey:GameDataIsNOADS] boolValue];
    return isNOADS;
}

+(void)gameSetIsNOADS{
    [GameKeyValue setObject:[NSNumber numberWithBool:YES] forKey:GameDataIsNOADS];
}

#pragma mark -多盟的视频代理
/**
 *  开始加载数据。
 *  Independent video starts to fetch info.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidStartLoad:(IndependentVideoManager *)manager{
    HNLOGINFO(@"开始加载数据");
}


/**
 *  加载完成。
 *  Fetching independent video successfully.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidFinishLoad:(IndependentVideoManager *)manager{
    HNLOGINFO(@"加载完成");
}


/**
 *  加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
 *   Failed to load independent video.
 
 *
 *  @param manager IndependentVideoManager
 *  @param error   error
 */
- (void)ivManager:(IndependentVideoManager *)manager
failedLoadWithError:(NSError *)error{
    HNLOGINFO(@"加载失败，%@",error);
}


/**
 *  被呈现出来时，回调该方法。
 *  Called when independent video will be presented.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerWillPresent:(IndependentVideoManager *)manager{
    HNLOGINFO(@"视频呈现出来");
}



/**
 *  页面关闭。
 *  Independent video closed.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidClosed:(IndependentVideoManager *)manager{
    HNLOGINFO(@"视频页面关闭");
    [GameDataGlobal playAudioMainMusic];
}


/**
 *  当视频播放完成后，回调该方法。
 *  Independent video complete play
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerCompletePlayVideo:(IndependentVideoManager *)manager{
    HNLOGINFO(@"视频播放完成");
    //播放视频，然后继续消下去
    [GameDataGlobal addGameEnergy:5];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShouldRefreshEnergyLabel object:nil];
}



/**
 *  成功获取视频积分
 *  Complete independent video.
 *
 *  @param manager IndependentVideoManager
 *  @param totalPoint
 *  @param consumedPoint
 *  @param currentPoint
 */

- (void)ivCompleteIndependentVideo:(IndependentVideoManager *)manager
                    withTotalPoint:(NSNumber *)totalPoint
                     consumedPoint:(NSNumber *)consumedPoint
                      currentPoint:(NSNumber *)currentPoint{
    HNLOGINFO(@"成功获取视频积分");
}




/**
 *  获取视频积分出错
 *  Uncomplete independent video.
 *
 *  @param manager IndependentVideoManager
 *  @param error
 */

- (void)ivManagerUncompleteIndependentVideo:(IndependentVideoManager *)manager
                                  withError:(NSError *)error{
    HNLOGINFO(@"获取视频积分出错");
}

//获取在appStore的链接
+(NSString *)gameGetAppStoreURL{
    return @"https://itunes.apple.com/us/app/chai-fang-kuai-xiao-chu-xiao/id1003713811";
}

//是否开启视频广告
+(BOOL)isOpenVideo{
    int isUmOpenVideo = [[GameDataGlobal shareInstance] videoOpen];
    if (isUmOpenVideo == 1) {
        [GameKeyValue setObject:@"1" forKey:GameDataOpenVideoKey];
        return YES;
    }else if(isUmOpenVideo == 2){
        return NO;
    }
    
    NSString *isOpenVideo = [GameKeyValue objectForKey:GameDataOpenVideoKey];
    if (isOpenVideo) {
        return YES;
    }
    
    return NO;
}



#pragma mark - 广点通代理
static NSString *INTERSTITIAL_STATE_TEXT = @"插屏状态";

/**
 *  广告预加载成功回调
 *  详解:当接收服务器返回的广告数据成功后调用该函数
 */
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Success Loaded.");
}

/**
 *  广告预加载失败回调
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Fail Loaded." );
}

/**
 *  插屏广告将要展示回调
 *  详解: 插屏广告即将展示回调该函数
 */
- (void)interstitialWillPresentScreen:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Going to present.");
}

/**
 *  插屏广告视图展示成功回调
 *  详解: 插屏广告展示成功回调该函数
 */
- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Success Presented." );
}

/**
 *  插屏广告展示结束回调
 *  详解: 插屏广告展示结束回调该函数
 */
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Finish Presented.");
    [_interstitialObj loadAd];
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)interstitialApplicationWillEnterBackground:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Application enter background.");
}

/**
 *  插屏广告曝光时回调
 *  详解: 插屏广告曝光时回调
 */
-(void)interstitialWillExposure:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Exposured");
}
/**
 *  插屏广告点击时回调
 *  详解: 插屏广告点击时回调
 */
-(void)interstitialClicked:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Clicked");
}



@end
