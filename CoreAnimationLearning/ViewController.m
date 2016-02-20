//
//  ViewController.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/4/19.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewControllerPlay.h"
#import <sys/stat.h>
#import <dlfcn.h>
#import "LevelDialogView.h"
#import "SystemInfo.h"
#import "GameDataGlobal.h"
#import "GameCenter.h"
#import "WeiXinShare.h"
#import "IAPManager.h"
#import "macro.h"
#import "SpriteView2.h"
#import "GameIntroductionView.h"
#import "DialogViewEnergy.h"
#import "GDTMobBannerView.h"
#import "GDTSplashAd.h"
#import "XiaoZSinitialization.h"

@interface ViewController ()<UIAlertViewDelegate,IAPManagerDelegate,GameCenterDelegate,GDTMobBannerViewDelegate>

@property(nonatomic,assign) BOOL isUserHavedLoginGameCenter;
@property(nonatomic,retain) IAPManager *iap;
@property(nonatomic,retain) GDTMobBannerView *bannerView;//声明一个GDTMobBannerView的实例
@end

@implementation ViewController
-(void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.backgroundColor = [GameDataGlobal getMainScreenBackgroundColor];
    
    [[XiaoZSinitialization sharedInstance] playBackgroundMusic:@selector(playBackgroundMusic) target:self times:1000];
    
    //初始化gameCenter
    GameCenter *gameCenterModel = [[GameCenter alloc] init];
    gameCenterModel.delegate = self;
    [gameCenterModel authenticateLocalPlayer];
    
    
    [self addSubViews];
    
    if ([GameDataGlobal gameIsFirstTimePlay]) {
        [GameDataGlobal setGameIsNoFirstTimePlay];
        GameIntroductionView *introductionView = [[GameIntroductionView alloc] initWithFrame:self.view.bounds];
        [introductionView gameBeginIntroduction];
        introductionView.viewController = self;
        [self.view addSubview:introductionView];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLableEnergy) name:NotificationShouldRefreshEnergyLabel object:nil];
}

-(void)playBackgroundMusic{
    [GameDataGlobal playAudioMainMusic];
}

-(void)addSubViews{
    UILabel *labelChai = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height/4 - 40)];
    labelChai.textColor = [UIColor whiteColor];
    labelChai.textAlignment = NSTextAlignmentCenter;
    labelChai.text = @"拆";
    int size = 80;
    if (IsPadUIBlockGame()) {
        size = 160;
    }
    labelChai.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:size];
    [self.view addSubview:labelChai];
    [self alwaysShake:3 view:labelChai];
    
    UILabel *labelFangKuai = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/4 - 20, self.view.frame.size.width, self.view.frame.size.height/4)];
    labelFangKuai.textAlignment = NSTextAlignmentCenter;
    labelFangKuai.textColor = [UIColor whiteColor];
    labelFangKuai.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:size-20];
    labelFangKuai.text =@"方 块";
    [self.view addSubview:labelFangKuai];
    
    
    SpriteView2 *buttonPlay = [SpriteView2 buttonWithType:UIButtonTypeCustom];
    buttonPlay.tag = 500000;
    [buttonPlay beginAnimation];
    int buttonPlaysize = self.view.frame.size.height/4.0 - self.view.frame.size.height/25;
    int buttonPlayx = self.view.frame.size.width/2 - buttonPlaysize/2;
    int buttonPlayy = self.view.frame.size.height/2;
    buttonPlay.frame = CGRectMake(buttonPlayx, buttonPlayy - 20, buttonPlaysize, buttonPlaysize);
    buttonPlay.layer.cornerRadius = buttonPlaysize/4;
    buttonPlay.layer.masksToBounds = NO;
    buttonPlay.backgroundColor = [UIColor grayColor];
    [buttonPlay setImage:[UIImage imageNamed:@"image_play"] forState:UIControlStateNormal];
    [buttonPlay addTarget:self action:@selector(buttonPlayPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonPlay];
    
    UIButton *buttonSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSetting.tag = 500001;
    buttonSetting.layer.masksToBounds = YES;
    buttonSetting.backgroundColor = [GameDataGlobal getColorInColorType:2];
    [buttonSetting setImage:[UIImage imageNamed:@"image_shezhi"] forState:UIControlStateNormal];
    [buttonSetting addTarget:self action:@selector(buttonSettingPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSetting];
    
    UIButton *buttonNoADS = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonNoADS.tag = 500002;
    buttonNoADS.layer.masksToBounds = YES;
    buttonNoADS.backgroundColor = [GameDataGlobal getColorInColorType:3];
    [buttonNoADS setImage:[UIImage imageNamed:@"image_noads"] forState:UIControlStateNormal];
    [buttonNoADS addTarget:self action:@selector(buttonNoADSPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonNoADS];
    
    UIButton *buttonPaiMing = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPaiMing.tag = 500003;
    buttonPaiMing.layer.masksToBounds = YES;
    buttonPaiMing.backgroundColor = [GameDataGlobal getColorInColorType:5];
    [buttonPaiMing setImage:[UIImage imageNamed:@"image_paiming"] forState:UIControlStateNormal];
    [buttonPaiMing addTarget:self action:@selector(buttonPaiMingPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonPaiMing];
    
    
    UIButton *buttonShare = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonShare.tag = 500004;
    buttonShare.layer.masksToBounds = YES;
    buttonShare.backgroundColor = [GameDataGlobal getColorInColorType:4];
    [buttonShare setImage:[UIImage imageNamed:@"image_share"] forState:UIControlStateNormal];
    [buttonShare addTarget:self action:@selector(buttonSharePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonShare];
    
    
    BOOL isOpenVideo = [GameDataGlobal isOpenVideo];
    NSLog(@"isOpenVideo %d",isOpenVideo);
    
    int imageEnergyWidth = 30;
    int imageEnergyHeigh = 30;
    int imageEnergyInsertRight = 10;
    int imageEnergyInsertTop = 2;
    if(IsPadUIBlockGame()){
        imageEnergyHeigh *=2;
        imageEnergyWidth*=2;
        imageEnergyInsertRight*=2;
        imageEnergyInsertTop*=2;
    }
    
    UIImageView *imageViewEnergy = [[UIImageView alloc] initWithFrame:CGRectMake(imageEnergyInsertRight, imageEnergyInsertTop, imageEnergyWidth, imageEnergyHeigh)];
    imageViewEnergy.image = [UIImage imageNamed:@"image_main_energy.png"];
    if (isOpenVideo) {
        [self.view addSubview:imageViewEnergy];
    }
    
    
    int labelEnergyWidth = 50;
    int labelEnergyHeigh = 20;
    int labelEnergyInsert = 10;
    int labelEnergyLabelFont = 20;
    if (IsPadUIBlockGame()) {
        labelEnergyWidth*=2;
        labelEnergyHeigh*=2;
        labelEnergyInsert*=2;
        labelEnergyLabelFont = 40;
    }
    
    
    UILabel *labelEnergy = [[UILabel alloc] initWithFrame:CGRectMake(imageViewEnergy.frame.origin.x + imageViewEnergy.frame.size.width, labelEnergyInsert, labelEnergyWidth, labelEnergyHeigh)];
    labelEnergy.tag = 500005;
    labelEnergy.text = [NSString stringWithFormat:@"X %d",[GameDataGlobal getGameRestEnergy]];
    labelEnergy.textColor = [GameDataGlobal getColorInColorType:5];
    labelEnergy.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:labelEnergyLabelFont];
    if (isOpenVideo) {
        [self.view addSubview:labelEnergy];
    }
    
    UIButton *buttonPlayVideo = [[UIButton alloc] initWithFrame:CGRectMake(labelEnergy.frame.origin.x + labelEnergy.frame.size.width, labelEnergyInsert, labelEnergyHeigh, labelEnergyHeigh)];
    [buttonPlayVideo setImage:[UIImage imageNamed:@"image_main_video.png"] forState:UIControlStateNormal];
    [buttonPlayVideo addTarget:self action:@selector(buttonPlayVideoPressed:) forControlEvents:UIControlEventTouchUpInside];
    if (isOpenVideo) {
        [self.view addSubview:buttonPlayVideo];
    }
    
    //广点通-------------
    //banner初始化
    _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, 0,
                                                                     GDTMOB_AD_SUGGEST_SIZE_320x50.width,
                                                                     GDTMOB_AD_SUGGEST_SIZE_320x50.height)
                                                   appkey:@"1105190664"
                                              placementId:@"5000608808344035"];
    _bannerView.delegate = self; // 设置Delegate
    _bannerView.currentViewController = self; //设置当前的ViewController
    _bannerView.interval = 30; //【可选】设置刷新频率;默认30秒
    _bannerView.isGpsOn = NO; //【可选】开启GPS定位;默认关闭
    _bannerView.showCloseBtn = YES; //【可选】展示关闭按钮;默认显示
    _bannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
    [_bannerView loadAdAndShow]; //加载广告并展示
    
    //执行动画
    [self viewAnimation];
}

-(void)viewAnimation{
    [self.view addSubview:_bannerView]; //添加到当前的view中
    
    [GameDataGlobal playAudioLevel];
    int insertWidth = self.view.frame.size.width/20;
    int insertHeight = self.view.frame.size.width/30;
    if (IsPadUIBlockGame()) {
        insertWidth = self.view.frame.size.width/10;
    }
    int buttonSmallSize = (self.view.frame.size.width - insertWidth*5)/4;
    
    UIButton *buttonPlay = (UIButton*)[self.view viewWithTag:500000];
    
    UIButton *buttonSetting = (UIButton *)[self.view viewWithTag:500001];
    buttonSetting.layer.cornerRadius = buttonSmallSize/4;
    buttonSetting.frame = CGRectMake(-buttonSmallSize*2, buttonPlay.frame.origin.y + buttonPlay.frame.size.width + insertHeight+ buttonSmallSize/2, buttonSmallSize, buttonSmallSize);
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        buttonSetting.frame = CGRectMake(insertWidth, buttonPlay.frame.origin.y + buttonPlay.frame.size.width + insertHeight+ buttonSmallSize/2, buttonSmallSize, buttonSmallSize);
    } completion:^(BOOL isfinish){
        [GameDataGlobal playAudioLevel];
    }];
    
    
    UIButton *buttonNoADS = (UIButton *)[self.view viewWithTag:500002];
    buttonNoADS.layer.cornerRadius = buttonSmallSize/4;
    buttonNoADS.frame = CGRectMake(-buttonSmallSize*2, buttonPlay.frame.origin.y + buttonPlay.frame.size.width + insertHeight+ buttonSmallSize/2, buttonSmallSize, buttonSmallSize);
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        buttonNoADS.frame = CGRectMake(insertWidth*2 + buttonSmallSize, buttonPlay.frame.origin.y + buttonPlay.frame.size.width + insertHeight+ buttonSmallSize/2, buttonSmallSize, buttonSmallSize);
    } completion:^(BOOL isFinish){
        [GameDataGlobal playAudioLevel];
    }];
    
    
    UIButton *buttonPaiMing = (UIButton*)[self.view viewWithTag:500003];
    buttonPaiMing.layer.cornerRadius = buttonSmallSize/4;
    buttonPaiMing.frame = CGRectMake(self.view.frame.size.width + buttonSmallSize*2, buttonPlay.frame.origin.y + buttonPlay.frame.size.width + insertHeight+ buttonSmallSize/2, buttonSmallSize, buttonSmallSize);
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        buttonPaiMing.frame = CGRectMake(insertWidth*3 + buttonSmallSize*2, buttonPlay.frame.origin.y + buttonPlay.frame.size.width + insertHeight+ buttonSmallSize/2, buttonSmallSize, buttonSmallSize);
    } completion:^(BOOL isfinish){
    }];
    
    UIButton *buttonShare = (UIButton*)[self.view viewWithTag:500004];
    buttonShare.layer.cornerRadius = buttonSmallSize/4;
    buttonShare.frame = CGRectMake(self.view.frame.size.width + buttonSmallSize*2, buttonPlay.frame.origin.y + buttonPlay.frame.size.width + insertHeight+ buttonSmallSize/2, buttonSmallSize, buttonSmallSize);
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        buttonShare.frame = CGRectMake(insertWidth*4 + buttonSmallSize*3, buttonPlay.frame.origin.y + buttonPlay.frame.size.width + insertHeight+ buttonSmallSize/2, buttonSmallSize, buttonSmallSize);
    } completion:^(BOOL isFinish){
    }];
}

-(void)refreshLableEnergy{
    UILabel *labelEnergy = (UILabel *)[self.view viewWithTag:500005];
    labelEnergy.text = [NSString stringWithFormat:@"X%d",[GameDataGlobal getGameRestEnergy]];
}

#pragma mark -震动效果
-(void)alwaysShake:(int)timeInteval view:(UIView *)view{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self shake:view minAngle:0 angleDuration:M_PI/80 times:16 duration:0.1];
        [self alwaysShake:timeInteval view:view];
    });
}

//maxAngle最小震动幅度，angleDuration递减的角度，times震动次数，duration每次震动的时间
-(void)shake:(UIView *)view minAngle:(CGFloat)minAngle angleDuration:(CGFloat)angleDuration times:(int)times duration:(double)duration{
    if (times <= 0) {
        view.transform = CGAffineTransformIdentity;
        return;
    }
    
    CGFloat angel = minAngle + angleDuration * times/2;
    if (times%2==0) {
        angel = -angel;
    }
    
    times--;
    [UIView animateWithDuration:duration animations:^{
        view.transform = CGAffineTransformMakeRotation(angel);
    } completion:^(BOOL isfinish){
        [self shake:view minAngle:minAngle angleDuration:angleDuration times:times duration:duration];
    }];
}

#pragma mark - buttonClickEvent
-(void)buttonPlayVideoPressed:(id)sender{
    [[GameDataGlobal shareInstance] playVideo];
}

-(void)buttonPlayPressed:(id)sender{
    [GameDataGlobal playAudioIsCorrect:5];
    
    LevelDialogView *levelDialog = [[LevelDialogView alloc] initWithFrame:self.view.bounds];
    levelDialog.viewController = self;
    levelDialog.alpha = 0.0;
    levelDialog.backgroundColor = [GameDataGlobal getMainScreenBackgroundColor];
    [self.view addSubview:levelDialog];
    [UIView animateWithDuration:0.8 animations:^{
        levelDialog.alpha = 1.0;
    }];
    [_bannerView removeFromSuperview];
}

-(void)buttonSettingPressed:(id)sender{
    [GameDataGlobal playAudioIsCorrect:5];
    
    UIButton *buttonSetting = (UIButton*)sender;
    UIView *baseView = [self.view viewWithTag:30001];
    NSArray *subViews = [baseView subviews];
    
    if (baseView) {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            buttonSetting.transform = CGAffineTransformIdentity;
        } completion:^(BOOL isFinish){
            [baseView removeFromSuperview];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *subView in subViews) {
                subView.frame = CGRectMake(0, 0, 0, 0);
            }
            baseView.frame = CGRectMake(buttonSetting.frame.origin.x + buttonSetting.frame.size.width, buttonSetting.frame.origin.y+buttonSetting.frame.size.height, 0, 0);
        }];
    }
    else{
        int baseViewWidthInsert = self.view.frame.size.width/15;
        int baseViewHeightInsert = (self.view.frame.size.height - buttonSetting.frame.origin.y - buttonSetting.frame.size.height)/20;
        int baseViewWidth = self.view.frame.size.width - baseViewWidthInsert*2;
        if (IsPadUIBlockGame()) {
            baseViewWidthInsert = self.view.frame.size.width/8;
            baseViewWidth = self.view.frame.size.width*4/5 - baseViewWidthInsert*2;
        }
        int baseViewHeight = self.view.frame.size.height - buttonSetting.frame.origin.y - buttonSetting.frame.size.height - baseViewHeightInsert*2;
        if (self.view.frame.size.height < 500) {
            baseViewHeight = baseViewHeight + baseViewHeightInsert*2;
        }
        
        baseView = [[UIView alloc] init];
        baseView.tag = 30001;
        UIImage *baseViewBack = [UIImage imageNamed:@"image_baseViewDialog"];
        baseView.layer.contents = (__bridge id)(baseViewBack.CGImage);
        baseView.backgroundColor = [UIColor clearColor];
        baseView.center = buttonSetting.center;
        [self.view insertSubview:baseView belowSubview:buttonSetting];
        
        int count = 4;
        float subButtonInsert = baseViewWidth/20;
        float beishu =9.4 - self.view.frame.size.height/88;
        float subBUttonInsertTop = baseViewHeight/beishu;
        float subButtonInsertButtom = baseViewHeight/beishu;
        if (IsPadUIBlockGame()) {
            subBUttonInsertTop = baseViewHeight/3.5;
            subButtonInsertButtom = baseViewHeight/20;
        }
        float subButtonSize = self.view.frame.size.width/8;
        if (IsPadUIBlockGame()) {
            subButtonSize = self.view.frame.size.width/12;
        }
        float subButtonInsertHeade = (baseViewWidth - subButtonSize*count - subButtonInsert*5)*3/5;
        
        NSMutableArray *mutArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i++) {
            UIButton *subButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            subButton.backgroundColor = [UIColor whiteColor];
            subButton.layer.cornerRadius = subButtonSize/4;
            [baseView addSubview:subButton];
            [mutArray addObject:subButton];
        }
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            buttonSetting.transform = CGAffineTransformMakeRotation(M_PI);
            baseView.frame = CGRectMake(baseViewWidthInsert, buttonSetting.frame.size.height + buttonSetting.frame.origin.y + baseViewHeightInsert, baseViewWidth, baseViewHeight);
            for (int i = 0; i < count; i++) {
                UIImage *buttonImage = [UIImage imageNamed:[NSString stringWithFormat:@"image_setting_%d",i+1]];
                if (i == 0) {
                    if ([[GameDataGlobal shareInstance] gameVoiceClose]) {
                        buttonImage = [UIImage imageNamed:[NSString stringWithFormat:@"image_setting_1_open"]];
                    }
                }else if (i == 1){
                    if (![[GameDataGlobal shareInstance] gameMusicClose]) {
                        buttonImage = [UIImage imageNamed:[NSString stringWithFormat:@"image_setting_2_close"]];
                    }
                }
                
                UIButton *subButton = [mutArray objectAtIndex:i];
                [subButton setImage:buttonImage forState:UIControlStateNormal];
                subButton.tag = 40000+i;
                [subButton addTarget:self action:@selector(buttonPressedsubSetting:) forControlEvents:UIControlEventTouchUpInside];
                subButton.frame = CGRectMake(subButtonInsertHeade + subButtonInsert*(i+1) + subButtonSize*i, subBUttonInsertTop, subButtonSize, subButtonSize);
            }
        } completion:^(BOOL isFinish){
            
        }];
    }
}

-(void)buttonPressedsubSetting:(id)sender{
    UIButton *button = (UIButton *)sender;
    GameDataGlobal *dataGlobal = [GameDataGlobal shareInstance];
    int i = (int)button.tag - 40000;
    switch (i) {
        case 0:
        {
            [GameDataGlobal playAudioVoiceCloseOrOpen];
            if (dataGlobal.gameVoiceClose) {
                [button setImage:[UIImage imageNamed:@"image_setting_1_open"] forState:UIControlStateNormal];
            }else{
                [button setImage:[UIImage imageNamed:@"image_setting_1"] forState:UIControlStateNormal];
            }
        }
            break;
        case 1:
        {
            [GameDataGlobal playAudioMainMusic];
            if (!dataGlobal.gameMusicClose) {
                [button setImage:[UIImage imageNamed:@"image_setting_2_close"] forState:UIControlStateNormal];
            }else{
                [button setImage:[UIImage imageNamed:@"image_setting_2"] forState:UIControlStateNormal];
            }
        }
            break;
            
        case 2:
        {
            NSString *appStoreURL = [GameDataGlobal gameGetAppStoreURL];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreURL]];
        }
            break;
            
        case 3:
        {
            GameIntroductionView *introductionView = [[GameIntroductionView alloc] initWithFrame:self.view.bounds];
            [introductionView gameBeginIntroduction];
            introductionView.viewController = self;
            [self.view addSubview:introductionView];
            [self buttonSettingPressed:nil];
        }
            break;

            
        default:
            break;
    }
}

-(void)buttonPaiMingPressed:(id)sender{
    GameCenter *gameCenterModel = [[GameCenter alloc] init];
    gameCenterModel.delegate = self;
    if (_isUserHavedLoginGameCenter) {
        [gameCenterModel showGameCenter];
    }else{
        [gameCenterModel authenticateLocalPlayer];
    }
    
    [GameDataGlobal playAudioIsCorrect:5];
}

-(void)buttonSharePressed:(id)sender{
    [WeiXinShare sendMessageAndImageToWebChat:1];
    [GameDataGlobal playAudioIsCorrect:5];
}

-(void)buttonNoADSPress:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"过了第36关就能去掉游戏内广告" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [GameDataGlobal playAudioIsCorrect:5];
}

#pragma mark - gameCenterDelegate
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertVIewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
        }
            break;
        case 1:
        {
             self.iap = [[IAPManager alloc] init];
            self.iap.delegate = self;
            [self.iap buy];
        }
            break;
        case 2:
        {
            IAPManager *iap = [[IAPManager alloc] init];
            iap.delegate = self;
            [iap restore];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - iapManagerDelegate
-(void)buySuccess{
    [GameDataGlobal gameSetIsNOADS];
    HNLOGINFO(@"购买成功");
}

#pragma mark - GameCenterLoginSuccessDelegate
-(void)userLoginSuccess{
    self.isUserHavedLoginGameCenter = YES;
}


#pragma mark - 广点通banner代理
// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)bannerViewDidReceived
{
    NSLog(@"%s",__FUNCTION__);
}

// 请求广告条数据失败后调用
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)bannerViewFailToReceived:(NSError *)error
{
    NSLog(@"%s, Error:%@",__FUNCTION__,error);
}

// 应用进入后台时调用
//
// 详解:当点击下载或者地图类型广告时，会调用系统程序打开，
// 应用将被自动切换到后台
- (void)bannerViewWillLeaveApplication
{
    NSLog(@"%s",__FUNCTION__);
}

// banner条曝光回调
//
// 详解:banner条曝光时回调该方法
- (void)bannerViewWillExposure
{
    NSLog(@"%s",__FUNCTION__);
}

// banner条点击回调
//
// 详解:banner条被点击时回调该方法
- (void)bannerViewClicked
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner条被用户关闭时调用
 *  详解:当打开showCloseBtn开关时，用户有可能点击关闭按钮从而把广告条关闭
 */
- (void)bannerViewWillClose
{
    NSLog(@"%s",__FUNCTION__);
}
@end