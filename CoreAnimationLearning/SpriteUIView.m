//
//  SpriteUIView.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/4/26.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "SpriteUIView.h"

@interface SpriteUIView()
@property(nonatomic, retain) NSTimer * timer;
@end

@implementation SpriteUIView
-(void)generatePushBehavior{
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self] mode:UIPushBehaviorModeInstantaneous];
    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerResponder:) userInfo:nil repeats:YES];
}

-(void)removeBehaviorWithAnimator:(UIDynamicAnimator *)animator{
    if (animator) {
        [self.pushBehavior removeItem:self];
        [self.pushBehavior removeItem:self];
        [animator removeBehavior:self.pushBehavior];
        [animator removeBehavior:self.itemBehavior];
    }
}

-(void)timerResponder:(id)sender{
    //演员初始化
    CALayer* scaleLayer = [[CALayer alloc] init];
//    scaleLayer.backgroundColor = [UIColor blueColor].CGColor;
    scaleLayer.contents = self.layer.contents;
    scaleLayer.opacity = 0.8;
    scaleLayer.frame = CGRectMake(self.frame.origin.x + self.frame.size.width/4, self.frame.origin.y, self.frame.size.width/2, self.frame.size.height/2);
    scaleLayer.cornerRadius = 10;
    [self.superview.layer addSublayer:scaleLayer];
    
    //设定剧本
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
    //自动按照原来的轨迹往回播动画
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.duration = 0.3;
    scaleAnimation.delegate = self;
    scaleAnimation.removedOnCompletion = NO;
    [scaleAnimation setValue:scaleLayer forKey:@"MyScaleLayerType"];
    //开演
    [scaleLayer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

//动画开始
-(void)animationDidStart:(CAAnimation *)anim{
    
}

//动画结束
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        CALayer *layer = [anim valueForKey:@"MyScaleLayerType"];
        if (layer) {
            [layer removeFromSuperlayer];
        }
    }
}

-(void)setTimeInvilade{
    [self.timer invalidate];
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    self.pushBehavior = nil;
    self.itemBehavior = nil;
}
@end
