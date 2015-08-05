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

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)showInView:(UIView*)view{
    [super showInView:view];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    int baseViewWidth = 260;
    int baseViewHeigh = 200;
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - baseViewWidth/2, self.frame.size.height/2 - baseViewHeigh/2, baseViewWidth, baseViewHeigh)];
    baseView.backgroundColor = [GameDataGlobal getMainScreenBackgroundColor];
    baseView.layer.cornerRadius = 10.0;
    baseView.layer.masksToBounds = YES;
    [self addSubview:baseView];
    
    UIButton *buttonClose = [[UIButton alloc] initWithFrame:CGRectMake(baseView.frame.origin.x - 20, baseView.frame.origin.y - 20, 30, 30)];
    [buttonClose setImage:[UIImage imageNamed:@"hn_btn_black_close.png"] forState:UIControlStateNormal];
    [buttonClose addTarget:self action:@selector(buttonClossPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonClose];
    
    UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, baseViewWidth, baseViewHeigh/2)];
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
    UIImageView *imageViewEnergy = [[UIImageView alloc] initWithFrame:CGRectMake(imageEnergyInsertRight, baseViewHeigh/2, imageEnergyWidth, imageEnergyHeigh)];
    imageViewEnergy.image = [UIImage imageNamed:@"image_main_energy.png"];
    [baseView addSubview:imageViewEnergy];
    
    
    int labelEnergyWidth = 50;
    int labelEnergyHeigh = 50;
    int labelEnergyLabelFont = 20;
    UILabel *labelEnergy = [[UILabel alloc] initWithFrame:CGRectMake(imageViewEnergy.frame.origin.x + imageViewEnergy.frame.size.width, baseViewHeigh/2, labelEnergyWidth, labelEnergyHeigh)];
    labelEnergy.tag = 500005;
    labelEnergy.text = [NSString stringWithFormat:@"X %d",[GameDataGlobal getGameRestEnergy]];
    labelEnergy.textColor = [GameDataGlobal getColorInColorType:5];
    labelEnergy.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:labelEnergyLabelFont];
    [baseView addSubview:labelEnergy];

    
    int videoWidth = 50;
    int videoHeigh = 50;
    UIButton *buttonVideo = [[UIButton alloc] initWithFrame:CGRectMake(labelEnergy.frame.origin.x + labelEnergy.frame.size.width, baseViewHeigh/2, videoWidth, videoHeigh)];
    [buttonVideo setImage:[UIImage imageNamed:@"image_main_video.png"] forState:UIControlStateNormal];
    [baseView addSubview:buttonVideo];
}

-(void)buttonClossPressed:(id)sender{
    [self hide];
}

-(void)buttonVideoPlayPressed:(id)sender{
    
}
@end
