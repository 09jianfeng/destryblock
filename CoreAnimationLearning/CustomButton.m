//
//  CustomButton.m
//  ParticleButton
//
//  Created by FYZH on 14-2-22.
//  Copyright (c) 2014年 Liang HaiHu. All rights reserved.
//

#import "CustomButton.h"
#import "EmitterView.h"
@implementation CustomButton
{
    CAEmitterLayer *fireEmitter; //1
    EmitterView *emitterView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    emitterView = [[EmitterView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height/2, 0, 0) color:backgroundColor];
    [self addSubview:emitterView];
    [super setBackgroundColor:backgroundColor];

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawRect:(CGRect)rect
{
    //绘制路径
    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
//    CGPathAddRoundedRect(path, NULL, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), self.frame.size.width/2, self.frame.size.height/2);
    //（path,transform,坐标x,坐标y,半径,起始弧，结束弧，是否是顺时针）；
    CGPathAddArc(path, NULL, self.frame.size.width/2, self.frame.size.height/2, self.frame.size.width/2-10, 0, 2 * M_PI, NO);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    int rand = arc4random()%300;
    animation.duration = (200 +rand)/100.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    animation.repeatCount = MAXFLOAT;
    animation.path = path;
    //注释掉路径，不在路径上跑着先
//    [emitterView.layer addAnimation:animation forKey:@"test"];
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.masksToBounds = YES;
    CGPathRelease(path);
}


@end
