//
//  UIViewFinishPlayAlert.h
//  CoreAnimationLearning
//
//  Created by JFChen on 15/5/27.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewControllerPlay.h"

@interface UIViewFinishPlayAlert : UIView
@property(nonatomic,assign) int target;
@property(nonatomic,assign) int total;
@property(nonatomic,assign) int score;
@property(nonatomic,assign) CollectionViewControllerPlay *collectionViewController;
@property(nonatomic,assign) BOOL isStop;

-(void)showView;
@end
