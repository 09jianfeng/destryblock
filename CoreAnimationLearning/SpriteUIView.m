//
//  SpriteUIView.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/4/26.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "SpriteUIView.h"

@implementation SpriteUIView
-(void)generatePushBehavior{
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self] mode:UIPushBehaviorModeInstantaneous];
}
@end
