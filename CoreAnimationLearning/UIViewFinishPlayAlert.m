//
//  UIViewFinishPlayAlert.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/5/27.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "UIViewFinishPlayAlert.h"
#import "GameResultData.h"

@interface UIViewFinishPlayAlert()
@property(nonatomic,retain) UIDynamicAnimator *ani;
@property(nonatomic,retain) UIGravityBehavior *gravity;
@end

@implementation UIViewFinishPlayAlert
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.ani = [[UIDynamicAnimator alloc] init];
        self.gravity = [[UIGravityBehavior alloc] init];
        [self.ani addBehavior:self.gravity];
    }
    return self;
}


-(void)showView{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UIView *board = [[UIView alloc] initWithFrame:CGRectMake(20, -self.frame.size.height/2, self.frame.size.width - 20*2, self.frame.size.height/2)];
    board.backgroundColor = [GameResultData getMainScreenBackgroundColor];
    board.tag = 40000;
    board.layer.cornerRadius = board.frame.size.width/8;
    
    UILabel *labelTarget = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, board.frame.size.width/2, 30)];
    labelTarget.textAlignment = NSTextAlignmentCenter;
    labelTarget.text = @"Target";
    labelTarget.textColor = [UIColor blackColor];
    [board addSubview:labelTarget];
    UILabel *labelTargetNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, board.frame.size.width/2, 30)];
    labelTargetNum.textAlignment = NSTextAlignmentCenter;
    labelTargetNum.text = [NSString stringWithFormat:@"%d",self.target];
    labelTargetNum.textColor = [UIColor whiteColor];
    [board addSubview:labelTargetNum];
    
    UILabel *labelTotal = [[UILabel alloc] initWithFrame:CGRectMake(board.frame.size.width/2, 10, board.frame.size.width/2, 30)];
    labelTotal.textAlignment = NSTextAlignmentCenter;
    labelTotal.text = @"Total";
    labelTotal.textColor = [UIColor blackColor];
    [board addSubview:labelTotal];
    UILabel *labelTotalNum = [[UILabel alloc] initWithFrame:CGRectMake(board.frame.size.width/2, 40, board.frame.size.width/2, 30)];
    labelTotalNum.textAlignment = NSTextAlignmentCenter;
    labelTotalNum.text = [NSString stringWithFormat:@"%d",self.total];
    labelTotalNum.textColor = [UIColor whiteColor];
    [board addSubview:labelTotalNum];
    
    
    int buttonSize = board.frame.size.width/4;
    int buttonInsert = buttonSize*2/3;
    
    UILabel *labelScore = [[UILabel alloc] initWithFrame:CGRectMake(0, labelTargetNum.frame.size.height+labelTargetNum.frame.origin.y, board.frame.size.width, 30)];
    labelScore.textAlignment = NSTextAlignmentCenter;
    labelScore.text = @"Score";
    labelScore.textColor = [UIColor blackColor];
    [board addSubview:labelScore];
    UILabel *labelScoreNum = [[UILabel alloc] initWithFrame:CGRectMake(0, labelScore.frame.size.height + labelScore.frame.origin.y,board.frame.size.width, board.frame.size.height - labelScore.frame.size.height - labelScore.frame.origin.y - 40 - buttonSize)];
    labelScoreNum.textAlignment = NSTextAlignmentCenter;
    labelScoreNum.text = [NSString stringWithFormat:@"%d",self.score];
    labelScoreNum.textColor = [UIColor whiteColor];
    [board addSubview:labelScoreNum];
    
    
    
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(buttonInsert, board.frame.size.height - buttonSize - 40, buttonSize, buttonSize)];
    buttonBack.backgroundColor = [UIColor grayColor];
    buttonBack.layer.cornerRadius = buttonSize/2;
    [buttonBack setTitle:@"Back" forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(buttonbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [board addSubview:buttonBack];
    
    UIButton *buttonNext = [[UIButton alloc] initWithFrame:CGRectMake(buttonInsert*2 + buttonSize, board.frame.size.height - buttonSize - 40, buttonSize, buttonSize)];
    buttonNext.backgroundColor = [UIColor grayColor];
    NSString *conOrNext = @"Cont";
    if (!_isStop) {
        conOrNext = @"Next";
    }
    [buttonNext setTitle:conOrNext forState:UIControlStateNormal];
    buttonNext.layer.cornerRadius = buttonSize/2;
    [buttonNext addTarget:self action:@selector(buttonNextLevelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [board addSubview:buttonNext];
    
    
    [self.gravity addItem:board];
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:board attachedToAnchor:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [attachmentBehavior setLength:0];
    [attachmentBehavior setDamping:0.3];
    [attachmentBehavior setFrequency:3];
    [self.ani addBehavior:attachmentBehavior];
    [self addSubview:board];
    
    
    //添加粒子效果,树叶往下掉
    // 设置粒子发射的地方
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    snowEmitter.emitterPosition = CGPointMake(self.bounds.size.width / 2.0, -50);
    snowEmitter.emitterSize		= CGSizeMake(board.frame.size.width/2, 0);
    
    // Spawn points for the flakes are within on the outline of the line
    snowEmitter.emitterMode		= kCAEmitterLayerSurface;
    snowEmitter.emitterShape	= kCAEmitterLayerLine;
    
    // Configure the snowflake emitter cell
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    
    snowflake.name = @"snowflake";
    snowflake.birthRate		= 10.0;
    snowflake.lifetime		= 2.0;
    snowflake.lifetimeRange = 4;
    
    snowflake.scale = 0.05;
    snowflake.velocity		= 200;				// 粒子速度
    snowflake.velocityRange = 100;
    snowflake.yAcceleration = 200;
    snowflake.emissionLongitude = 0;
    snowflake.emissionRange = 1 * M_PI;		// 周围发射角度
    snowflake.spinRange		= 0.25 * M_PI;		// 粒子旋转角度
    
    snowflake.contents		= (id) [[UIImage imageNamed:@"leaf"] CGImage];
    snowflake.color			= [[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:1.000] CGColor];
    
    // Make the flakes seem inset in the background
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius  = 0.0;
    snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
    
    // Add everything to our backing layer below the UIContol defined in the storyboard
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
    [self.layer insertSublayer:snowEmitter atIndex:0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [snowEmitter setValue:[NSNumber numberWithFloat:0.5] forKeyPath:@"emitterCells.snowflake.birthRate"];
    });
}

#pragma mark - 按钮事件
-(void)buttonbackPressed:(id)sender{
    [self.collectionViewController exitTheGame];
}

-(void)buttonNextLevelPressed:(id)sender{
    if (self.isStop) {
        [self.ani removeAllBehaviors];
        UIView *board = [self viewWithTag:40000];
        [UIView animateWithDuration:0.3 animations:^{
            board.frame = CGRectMake(board.frame.origin.x, -self.frame.size.height, board.frame.size.width, board.frame.size.height);
        } completion:^(BOOL isFinish){
            [self removeFromSuperview];
            [self.collectionViewController continueGame];
        }];
    }else{
        [self.ani removeAllBehaviors];
        UIView *board = [self viewWithTag:40000];
        [UIView animateWithDuration:0.3 animations:^{
            board.frame = CGRectMake(board.frame.origin.x, -self.frame.size.height, board.frame.size.width, board.frame.size.height);
        } completion:^(BOOL isFinish){
            [self removeFromSuperview];
            [self.collectionViewController nextLevel];
        }];
    }
}

-(void)dealloc{
    self.ani = nil;
    self.gravity = nil;
}
@end
