//
//  UIViewFinishPlayAlert.h
//  CoreAnimationLearning
//
//  Created by JFChen on 15/5/27.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewControllerPlay.h"

@protocol UIViewFinishPlayAlertDelegate <NSObject>
-(void)buttonPressedExitTheGame;
-(void)buttonPressedReplayTheGame;
-(void)buttonPressedContineTheGame;
-(void)buttonPressedNextLevel;
@end

@interface UIViewFinishPlayAlert : UIView
@property(nonatomic,assign) int target;
@property(nonatomic,assign) int total;
@property(nonatomic,assign) int score;
@property(nonatomic,assign) id<UIViewFinishPlayAlertDelegate> delegate;
@property(nonatomic,assign) BOOL isStop;
@property(nonatomic,assign) int starNum;
@property(nonatomic,assign) BOOL isSuccess;
@property(nonatomic,assign) BOOL isTimesup;
@property(nonatomic,assign) int gameIndex;

-(void)showView;
-(void)beginStarImageAnimator;
@end
