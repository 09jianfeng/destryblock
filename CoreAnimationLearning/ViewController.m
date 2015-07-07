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

@interface ViewController ()<UIAlertViewDelegate,IAPManagerDelegate,GameCenterDelegate>
@property(nonatomic,assign) BOOL isUserHavedLoginGameCenter;
@end

@implementation ViewController
-(void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GameDataGlobal getMainScreenBackgroundColor];
    
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
    UILabel *labelFangKuai = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/4 - 40, self.view.frame.size.width, self.view.frame.size.height/4)];
    labelFangKuai.textAlignment = NSTextAlignmentCenter;
    labelFangKuai.textColor = [UIColor whiteColor];
    labelFangKuai.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:size-20];
    labelFangKuai.text =@"方 块";
    [self.view addSubview:labelFangKuai];
    
    
    SpriteView2 *buttonPlay = [SpriteView2 buttonWithType:UIButtonTypeCustom];
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
    
    int insertWidth = self.view.frame.size.width/20;
    int insertHeight = self.view.frame.size.width/30;
    if (IsPadUIBlockGame()) {
        insertWidth = self.view.frame.size.width/10;
    }
    int buttonSmallSize = (self.view.frame.size.width - insertWidth*5)/4;
    
    UIButton *buttonSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSetting.frame = CGRectMake(insertWidth, buttonPlay.frame.origin.y + buttonPlaysize + insertHeight, buttonSmallSize, buttonSmallSize);
    buttonSetting.layer.cornerRadius = buttonSmallSize/4;
    buttonSetting.layer.masksToBounds = YES;
    buttonSetting.backgroundColor = [GameDataGlobal getColorInColorType:2];
    [buttonSetting setImage:[UIImage imageNamed:@"image_shezhi"] forState:UIControlStateNormal];
    [buttonSetting addTarget:self action:@selector(buttonSettingPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSetting];
    
    UIButton *buttonNoADS = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonNoADS.frame = CGRectMake(insertWidth*2 + buttonSmallSize, buttonPlay.frame.origin.y + buttonPlaysize + insertHeight, buttonSmallSize, buttonSmallSize);
    buttonNoADS.layer.cornerRadius = buttonSmallSize/4;
    buttonNoADS.layer.masksToBounds = YES;
    buttonNoADS.backgroundColor = [GameDataGlobal getColorInColorType:3];
    [buttonNoADS setImage:[UIImage imageNamed:@"image_noads"] forState:UIControlStateNormal];
    [buttonNoADS addTarget:self action:@selector(buttonNoADSPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonNoADS];
    
    UIButton *buttonPaiMing = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPaiMing.frame = CGRectMake(insertWidth*3 + buttonSmallSize*2, buttonPlay.frame.origin.y + buttonPlaysize + insertHeight, buttonSmallSize, buttonSmallSize);
    buttonPaiMing.layer.cornerRadius = buttonSmallSize/4;
    buttonPaiMing.layer.masksToBounds = YES;
    buttonPaiMing.backgroundColor = [GameDataGlobal getColorInColorType:5];
    [buttonPaiMing setImage:[UIImage imageNamed:@"image_paiming"] forState:UIControlStateNormal];
    [buttonPaiMing addTarget:self action:@selector(buttonPaiMingPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonPaiMing];
    
    UIButton *buttonShare = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonShare.frame = CGRectMake(insertWidth*4 + buttonSmallSize*3, buttonPlay.frame.origin.y + buttonPlaysize + insertHeight, buttonSmallSize, buttonSmallSize);
    buttonShare.layer.cornerRadius = buttonSmallSize/4;
    buttonShare.layer.masksToBounds = YES;
    buttonShare.backgroundColor = [GameDataGlobal getColorInColorType:4];
    [buttonShare setImage:[UIImage imageNamed:@"image_share"] forState:UIControlStateNormal];
    [buttonShare addTarget:self action:@selector(buttonSharePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonShare];
    
    GameCenter *gameCenterModel = [[GameCenter alloc] init];
    gameCenterModel.delegate = self;
    [gameCenterModel authenticateLocalPlayer];
}


#pragma mark - buttonClickEvent
-(void)buttonPlayPressed:(id)sender{
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
    UIButton *buttonSetting = (UIButton*)sender;
    
    
    UIView *baseView = [self.view viewWithTag:30001];
    
    if (baseView) {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            buttonSetting.transform = CGAffineTransformIdentity;
            baseView.alpha = 0.0;
        } completion:^(BOOL isFinish){
            [baseView removeFromSuperview];
        }];
    }
    else{
        int baseViewWidthInsert = self.view.frame.size.width/20;
        int baseViewHeightInsert = (self.view.frame.size.height - buttonSetting.frame.origin.y - buttonSetting.frame.size.height)/20;
        int baseViewWidth = self.view.frame.size.width - baseViewWidthInsert*2;
        int baseViewHeight = self.view.frame.size.height - buttonSetting.frame.origin.y - buttonSetting.frame.size.height - baseViewHeightInsert*2;
        
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
                UIButton *subButton = [mutArray objectAtIndex:i];
                subButton.frame = CGRectMake(subButtonInsertHeade + subButtonInsert*(i+1) + subButtonSize*i, subBUttonInsertTop, subButtonSize, subButtonSize);
            }
        } completion:^(BOOL isFinish){
        }];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否确定用“$1”去掉游戏内广告" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"购买",@"恢复", nil];
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
            IAPManager *iap = [[IAPManager alloc] init];
            iap.delegate = self;
            [iap buy];
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
    HNLOGINFO(@"购买成功");
}

#pragma mark - GameCenterLoginSuccessDelegate
-(void)userLoginSuccess{
    self.isUserHavedLoginGameCenter = YES;
}
@end