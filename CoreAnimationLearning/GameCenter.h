//
//  GameCenter.h
//  chaigangkuai
//
//  Created by JFChen on 15/6/9.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ViewController.h"

@protocol GameCenterDelegate <NSObject>

-(void)userLoginSuccess;

@end

@interface GameCenter : NSObject
//viewcontroller需要实现 GKGameCenterControllerDelegate，的- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController 方法
@property(nonatomic, assign) ViewController<GameCenterDelegate> *delegate;

- (void)showGameCenter;
//身份验证
- (void)authenticateLocalPlayer;

//当上传分数出错的时候,要将上传的分数存储起来,比如将SKScore存入一个NSArray中.等可以上传的时候再次尝试.
- (void)reportScore:(int64_t)score forCategory:(NSString*)category;
-(void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent;
@end
