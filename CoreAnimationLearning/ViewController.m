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
#import "macro.h"
#import "SpriteView2.h"
#import "GameIntroductionView.h"
#import "DialogViewEnergy.h"
#import "AboutController.h"
#import "AppDataStorage.h"


@interface ViewController ()<UIAlertViewDelegate>

@property(nonatomic,assign) BOOL isUserHavedLoginGameCenter;
@end

@implementation ViewController
-(void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.backgroundColor = [GameDataGlobal getMainScreenBackgroundColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_background.jpg"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    
    [self playBackgroundMusic];
    
    [self addSubViews];
    
//    if ([GameDataGlobal gameIsFirstTimePlay]) {
//        [GameDataGlobal setGameIsNoFirstTimePlay];
//        GameIntroductionView *introductionView = [[GameIntroductionView alloc] initWithFrame:self.view.bounds];
//        [introductionView gameBeginIntroduction];
//        introductionView.viewController = self;
//        [self.view addSubview:introductionView];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLableEnergy) name:NotificationShouldRefreshEnergyLabel object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDataStorage *dataSto = [AppDataStorage shareInstance];
    [dataSto analyseWebData];
    if ([dataSto accessable]) {
        NSString *url = [[AppDataStorage shareInstance] getURL];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

-(void)playBackgroundMusic{
    [GameDataGlobal playAudioMainMusic];
}

-(void)addSubViews{
    UILabel *labelChai = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height/4 - 40)];
    labelChai.textColor = [UIColor colorWithRed:0.8 green:0.1 blue:0.2 alpha:1.0];
    labelChai.textAlignment = NSTextAlignmentCenter;
    labelChai.text = @"拆";
    int size = 80;
    if (IsPadUIBlockGame()) {
        size = 160;
    }
    labelChai.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:size];
    [self.view addSubview:labelChai];
    [self alwaysShake:3 view:labelChai];
    
//    UILabel *labelFangKuai = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/4 - 20, self.view.frame.size.width, self.view.frame.size.height/4)];
//    labelFangKuai.textAlignment = NSTextAlignmentCenter;
//    labelFangKuai.textColor = [UIColor colorWithRed:0.8 green:0.1 blue:0.2 alpha:1.0];
//    labelFangKuai.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:size-20];
//    labelFangKuai.text =@"红 包";
//    [self.view addSubview:labelFangKuai];
    
    
    SpriteView2 *buttonPlay = [SpriteView2 buttonWithType:UIButtonTypeCustom];
    buttonPlay.tag = 500000;
    [buttonPlay beginAnimation];
    int buttonPlaysize = self.view.frame.size.height/2.5 ;
    int buttonPlayx = self.view.frame.size.width/2 - buttonPlaysize/2;
    buttonPlay.frame = CGRectMake(buttonPlayx, labelChai.frame.origin.y + labelChai.frame.size.height - 30, buttonPlaysize, buttonPlaysize * 1.2);
    buttonPlay.layer.cornerRadius = buttonPlaysize/4;
    buttonPlay.layer.masksToBounds = NO;
    [buttonPlay setImage:[UIImage imageNamed:@"hongbao_bg.jpg"] forState:UIControlStateNormal];
    [buttonPlay addTarget:self action:@selector(buttonPlayPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonPlay];
    
    UIButton *buttonSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSetting.tag = 500001;
    buttonSetting.layer.masksToBounds = YES;
    buttonSetting.backgroundColor = [UIColor redColor];
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
    buttonShare.backgroundColor = [UIColor redColor];
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
    
    //执行动画
    [self viewAnimation];
}

-(void)viewAnimation{
    
    [GameDataGlobal playAudioLevel];
    int insertWidth = self.view.frame.size.width/20;
    int insertHeight = self.view.frame.size.width/10;
    if (IsPadUIBlockGame()) {
        insertWidth = self.view.frame.size.width/10;
    }
    int buttonSmallSize = (self.view.frame.size.width - insertWidth*5)/4;
    
    UIButton *buttonPlay = (UIButton*)[self.view viewWithTag:500000];
    
    UIButton *buttonSetting = (UIButton *)[self.view viewWithTag:500001];
    buttonSetting.layer.cornerRadius = buttonSmallSize/4;
    buttonSetting.frame = CGRectMake(-buttonSmallSize*2, buttonPlay.frame.origin.y + buttonPlay.frame.size.height + insertHeight+ buttonSmallSize/2, buttonSmallSize, buttonSmallSize);
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        buttonSetting.frame = CGRectMake(insertWidth, buttonPlay.frame.origin.y + buttonPlay.frame.size.height + insertHeight+ buttonSmallSize/2, buttonSmallSize, buttonSmallSize);
    } completion:^(BOOL isfinish){
        [GameDataGlobal playAudioLevel];
    }];
    
    
    UIButton *buttonNoADS = (UIButton *)[self.view viewWithTag:500002];
    buttonNoADS.layer.cornerRadius = buttonSmallSize/4;
    buttonNoADS.frame = CGRectMake(-buttonSmallSize*2, buttonPlay.frame.origin.y + buttonPlay.frame.size.height + insertHeight+ buttonSmallSize/2, buttonSmallSize, buttonSmallSize);
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        buttonNoADS.frame = CGRectMake(insertWidth*2 + buttonSmallSize, buttonPlay.frame.origin.y + buttonPlay.frame.size.width + insertHeight+ buttonSmallSize/2, buttonSmallSize, buttonSmallSize);
    } completion:^(BOOL isFinish){
        [GameDataGlobal playAudioLevel];
    }];
    
    
    UIButton *buttonPaiMing = (UIButton*)[self.view viewWithTag:500003];
    buttonPaiMing.layer.cornerRadius = buttonSmallSize/4;
    buttonPaiMing.frame = CGRectMake(self.view.frame.size.width + buttonSmallSize*2, buttonPlay.frame.origin.y + buttonPlay.frame.size.height + insertHeight+ buttonSmallSize/2, buttonSmallSize, buttonSmallSize);
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
    
    buttonSetting.frame = buttonNoADS.frame;
    buttonShare.frame = buttonPaiMing.frame;
    buttonNoADS.hidden = YES;
    buttonPaiMing.hidden = YES;
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
//        UIImage *baseViewBack = [UIImage imageNamed:@"image_baseViewDialog"];
//        baseView.layer.contents = (__bridge id)(baseViewBack.CGImage);
        baseView.backgroundColor = [UIColor clearColor];
        baseView.center = buttonSetting.center;
        [self.view insertSubview:baseView belowSubview:buttonSetting];
        
        int count = 4;
        float subButtonInsert = baseViewWidth/20;
        float beishu =9.4 - self.view.frame.size.height/88;
        float subBUttonInsertTop = baseViewHeight/3.0;
        float subButtonSize = self.view.frame.size.width/8;
        if (IsPadUIBlockGame()) {
            subButtonSize = self.view.frame.size.width/12;
        }
        float subButtonInsertHeade = (baseViewWidth - subButtonSize*count - subButtonInsert*5)*3/5;
        
        NSMutableArray *mutArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i++) {
            UIButton *subButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            subButton.backgroundColor = [UIColor redColor];
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
//            GameIntroductionView *introductionView = [[GameIntroductionView alloc] initWithFrame:self.view.bounds];
//            [introductionView gameBeginIntroduction];
//            introductionView.viewController = self;
//            [self.view addSubview:introductionView];
//            [self buttonSettingPressed:nil];
            NSString *appStoreURL = [GameDataGlobal gameGetAppStoreURL];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreURL]];
        }
            break;

            
        default:
            break;
    }
}

-(void)buttonPaiMingPressed:(id)sender{
    [GameDataGlobal playAudioIsCorrect:5];
}

-(void)buttonSharePressed:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/zhuan-kuai-xiao-xiao-le/id1080234248?l=zh&ls=1&mt=8"]];
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
        }
            break;
        case 2:
        {
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

@end
