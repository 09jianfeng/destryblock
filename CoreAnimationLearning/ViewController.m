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
#import "GameResultData.h"

extern NSString *playingViewExitNotification;

@interface ViewController (){
}
@end

@implementation ViewController
-(void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GameResultData getMainScreenBackgroundColor];
    
    UILabel *labelChai = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height/4 - 40)];
    labelChai.textColor = [UIColor whiteColor];
    labelChai.textAlignment = NSTextAlignmentCenter;
    labelChai.text = @"拆";
    labelChai.font = [UIFont systemFontOfSize:70];
    [self.view addSubview:labelChai];
    UILabel *labelFangKuai = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/4 - 40, self.view.frame.size.width, self.view.frame.size.height/4)];
    labelFangKuai.textAlignment = NSTextAlignmentCenter;
    labelFangKuai.textColor = [UIColor whiteColor];
    labelFangKuai.font = [UIFont systemFontOfSize:50];
    labelFangKuai.text =@"方 块";
    [self.view addSubview:labelFangKuai];
    
    
    UIButton *buttonPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    int buttonPlaysize = self.view.frame.size.width/2.0 - 20;
    int buttonPlayx = self.view.frame.size.width/2 - buttonPlaysize/2;
    int buttonPlayy = self.view.frame.size.height/2;
    buttonPlay.frame = CGRectMake(buttonPlayx, buttonPlayy - 20, buttonPlaysize, buttonPlaysize);
    buttonPlay.layer.cornerRadius = buttonPlaysize/4;
    buttonPlay.layer.masksToBounds = NO;
    buttonPlay.backgroundColor = [UIColor grayColor];
    [buttonPlay setTitle:@"Play" forState:UIControlStateNormal];
    [buttonPlay addTarget:self action:@selector(buttonPlayPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonPlay];
    
    int insertWidth = 10;
    int buttonSmallSize = (self.view.frame.size.width - insertWidth*8)/4;
    
    UIButton *buttonSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSetting.frame = CGRectMake(insertWidth, self.view.frame.size.height/2 + buttonPlaysize + insertWidth, buttonSmallSize, buttonSmallSize);
    buttonSetting.layer.cornerRadius = buttonSmallSize/4;
    buttonSetting.layer.masksToBounds = YES;
    buttonSetting.backgroundColor = [UIColor grayColor];
    [buttonSetting setTitle:@"Setting" forState:UIControlStateNormal];
    [self.view addSubview:buttonSetting];
    
    UIButton *buttonNoADS = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonNoADS.frame = CGRectMake(insertWidth*3 + buttonSmallSize, self.view.frame.size.height/2 + buttonPlaysize + insertWidth, buttonSmallSize, buttonSmallSize);
    buttonNoADS.layer.cornerRadius = buttonSmallSize/4;
    buttonNoADS.layer.masksToBounds = YES;
    buttonNoADS.backgroundColor = [UIColor grayColor];
    [buttonNoADS setTitle:@"NoADS" forState:UIControlStateNormal];
    [self.view addSubview:buttonNoADS];
    
    UIButton *buttonPaiMing = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPaiMing.frame = CGRectMake(insertWidth*5 + buttonSmallSize*2, self.view.frame.size.height/2 + buttonPlaysize + insertWidth, buttonSmallSize, buttonSmallSize);
    buttonPaiMing.layer.cornerRadius = buttonSmallSize/4;
    buttonPaiMing.layer.masksToBounds = YES;
    buttonPaiMing.backgroundColor = [UIColor grayColor];
    [buttonPaiMing setTitle:@"PaiM" forState:UIControlStateNormal];
    [self.view addSubview:buttonPaiMing];
    
    UIButton *buttonGuanka = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonGuanka.frame = CGRectMake(insertWidth*7 + buttonSmallSize*3, self.view.frame.size.height/2 + buttonPlaysize + insertWidth, buttonSmallSize, buttonSmallSize);
    buttonGuanka.layer.cornerRadius = buttonSmallSize/4;
    buttonGuanka.layer.masksToBounds = YES;
    buttonGuanka.backgroundColor = [UIColor grayColor];
    [buttonGuanka setTitle:@"Share" forState:UIControlStateNormal];
    [self.view addSubview:buttonGuanka];

}

-(void)buttonPlayPressed:(id)sender{
    LevelDialogView *levelDialog = [[LevelDialogView alloc] initWithFrame:self.view.frame];
    levelDialog.viewController = self;
    levelDialog.alpha = 0.0;
    [self.view addSubview:levelDialog];
    [UIView animateWithDuration:0.3 animations:^{
        levelDialog.alpha = 1.0;
    }];
}

@end