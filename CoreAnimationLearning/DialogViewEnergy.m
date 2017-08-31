//
//  DialogViewEnergy.m
//  chaigangkuai
//
//  Created by JFChen on 15/8/4.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "DialogViewEnergy.h"
#import "GameDataGlobal.h"

@implementation DialogViewEnergy
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationShouldRefreshEnergyLabel object:nil];
}

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)showInView:(UIView*)view{
    //场景切换音效
    [GameDataGlobal playAudioSwitch];
    
    [super showInView:view];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    int baseViewWidth = 260;
    int baseViewHeigh = 240;
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - baseViewWidth/2, -baseViewHeigh, baseViewWidth, baseViewHeigh)];
    baseView.tag = 10000;
    baseView.backgroundColor = [GameDataGlobal getMainScreenBackgroundColor];
    baseView.layer.cornerRadius = 10.0;
    baseView.layer.masksToBounds = YES;
    [self addSubview:baseView];
    [UIView animateWithDuration:0.6 delay:0.01 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         baseView.frame = CGRectMake(self.frame.size.width/2 - baseViewWidth/2, self.frame.size.height/2 - baseViewHeigh/2, baseViewWidth, baseViewHeigh);
    }
                     completion:^(BOOL finished) {
        
    }];
    
    UIButton *buttonClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [buttonClose setImage:[UIImage imageNamed:@"image_back.png"] forState:UIControlStateNormal];
    [buttonClose addTarget:self action:@selector(buttonClossPressed:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:buttonClose];
    
    UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, baseViewWidth, baseViewHeigh/2)];
    labelText.text = @"体力不够啦\n看视频补充点体力吧";
    labelText.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:24];
    labelText.textAlignment = NSTextAlignmentCenter;
    labelText.lineBreakMode = NSLineBreakByCharWrapping;
    labelText.numberOfLines = 2;
    labelText.textColor = [UIColor whiteColor];
    [baseView addSubview:labelText];
    
    int imageEnergyWidth = 50;
    int imageEnergyHeigh = 50;
    int imageEnergyInsertRight = 50;
    int imageOriginy = (baseViewHeigh/2 - imageEnergyHeigh)/2 + baseViewHeigh/2;
    UIImageView *imageViewEnergy = [[UIImageView alloc] initWithFrame:CGRectMake(imageEnergyInsertRight, imageOriginy, imageEnergyWidth, imageEnergyHeigh)];
    imageViewEnergy.image = [UIImage imageNamed:@"image_main_energy.png"];
    [baseView addSubview:imageViewEnergy];
    
    
    int labelEnergyWidth = 50;
    int labelEnergyHeigh = 50;
    int labelEnergyLabelFont = 20;
    UILabel *labelEnergy = [[UILabel alloc] initWithFrame:CGRectMake(imageViewEnergy.frame.origin.x + imageViewEnergy.frame.size.width, imageOriginy, labelEnergyWidth, labelEnergyHeigh)];
    labelEnergy.tag = 500005;
    labelEnergy.text = [NSString stringWithFormat:@"X %d",[GameDataGlobal getGameRestEnergy]];
    labelEnergy.textColor = [GameDataGlobal getColorInColorType:5];
    labelEnergy.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:labelEnergyLabelFont];
    [baseView addSubview:labelEnergy];

    
    int videoWidth = 50;
    int videoHeigh = 50;
    UIButton *buttonVideo = [[UIButton alloc] initWithFrame:CGRectMake(labelEnergy.frame.origin.x + labelEnergy.frame.size.width, imageOriginy, videoWidth, videoHeigh)];
    [buttonVideo setImage:[UIImage imageNamed:@"image_main_video.png"] forState:UIControlStateNormal];
    [buttonVideo addTarget:self action:@selector(buttonVideoPlayPressed:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:buttonVideo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLabelEnergy) name:NotificationShouldRefreshEnergyLabel object:nil];
}

-(void)buttonClossPressed:(id)sender{
    //场景切换音效
    [GameDataGlobal playAudioSwitch];
    
    UIView *baseView = [self viewWithTag:10000];
    [UIView animateWithDuration:0.3 animations:^{
        baseView.frame = CGRectMake(baseView.frame.origin.x, -baseView.frame.size.height, baseView.frame.size.width, baseView.frame.size.height);
    } completion:^(BOOL finished) {
        [self hide];
    }];
    
}

-(void)buttonVideoPlayPressed:(id)sender{
    [[GameDataGlobal shareInstance] playVideo];
    [self buttonClossPressed:nil];
}

-(void)refreshLabelEnergy{
    UILabel *labelEnergy = (UILabel *)[self viewWithTag:500005];
    labelEnergy.text = [NSString stringWithFormat:@"X %d",[GameDataGlobal getGameRestEnergy]];
}
@end
