//
//  SpriteUIView.h
//  CoreAnimationLearning
//
//  Created by JFChen on 15/4/26.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpriteUIView : UIView
@property(nonatomic, retain)UIPushBehavior *pushBehavior;
-(void)generatePushBehavior;
@end
