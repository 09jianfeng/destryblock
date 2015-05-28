//
//  UIViewFinishPlayAlert.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/5/27.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "UIViewFinishPlayAlert.h"

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
    
    UIView *board = [[UIView alloc] initWithFrame:CGRectMake(50, -400, self.frame.size.width - 50*2, 200)];
    UIImage *boardImage = [UIImage imageNamed:@"muban"];
    board.backgroundColor = [UIColor clearColor];
    board.layer.contents = (__bridge id)(boardImage.CGImage);
    
    UIView *ropeLeft = [[UIView alloc] initWithFrame:CGRectMake(20,0 - self.frame.size.height, 50, self.frame.size.height)];
    ropeLeft.backgroundColor = [UIColor clearColor];
    UIImage *ropeImage = [UIImage imageNamed:@"rope"];
    UIView *ropeRight = [[UIView alloc] initWithFrame:CGRectMake(board.frame.size.width - 30 - 50,0 - self.frame.size.height, 50, self.frame.size.height)];
    ropeRight.backgroundColor = [UIColor clearColor];
    ropeLeft.layer.contents = (__bridge id)(ropeImage.CGImage);
    ropeRight.layer.contents = (__bridge id)(ropeImage.CGImage);
    [board addSubview:ropeLeft];
    [board addSubview:ropeRight];
    
    [self.gravity addItem:board];
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:board attachedToAnchor:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [attachmentBehavior setLength:0];
    [attachmentBehavior setDamping:0.3];
    [attachmentBehavior setFrequency:3];
    [self.ani addBehavior:attachmentBehavior];
    [self addSubview:board];
}

-(void)dealloc{
    self.ani = nil;
    self.gravity = nil;
}
@end
