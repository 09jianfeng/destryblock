//
//  UIViewProgress.m
//  JellyAnimation
//
//  Created by JFChen on 15/6/26.
//  Copyright (c) 2015年 HuaiNan. All rights reserved.
//

/*
 使用CAShapeLayer与UIBezierPath可以实现不在view的drawRect方法中就画出一些想要的图形
 
 步骤：
 1、新建UIBezierPath对象bezierPath
 2、新建CAShapeLayer对象caShapeLayer
 3、将bezierPath的CGPath赋值给caShapeLayer的path，即caShapeLayer.path = bezierPath.CGPath
 4、把caShapeLayer添加到某个显示该图形的layer中
 */

#import "UIViewProgress.h"
@interface UIViewProgress(){
    CAShapeLayer *_trackLayer;
    UIBezierPath *_trackPath;
    CAShapeLayer *_progressLayer;
    UIBezierPath *_progressPath;
}
@end

@implementation UIViewProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _trackLayer = [CAShapeLayer new];
        [self.layer addSublayer:_trackLayer];
        _trackLayer.fillColor = nil;
        _trackLayer.lineCap = kCALineCapRound;
        _trackLayer.frame = self.bounds;
        
        _progressLayer = [CAShapeLayer new];
        [self.layer addSublayer:_progressLayer];
        _progressLayer.fillColor = nil;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.frame = self.bounds;
        
        //默认5
        self.progressWidth = 5;
    }
    return self;
}

- (void)setTrack
{
//    _trackPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];;  圆
    _trackPath = [UIBezierPath bezierPath];
    [_trackPath moveToPoint:CGPointMake(0, 0)];
    _trackPath.lineWidth = _progressWidth;
    [_trackPath addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    _trackLayer.path = _trackPath.CGPath;
}

- (void)setProgress
{
//    _progressPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:- M_PI_2 endAngle:(M_PI * 2) * _progress - M_PI_2 clockwise:YES];  圆
    _progressPath = [UIBezierPath bezierPath];
    [_progressPath moveToPoint:CGPointMake(0, 0)];
    _progressPath.lineWidth = _progressWidth;
    [_progressPath addLineToPoint:CGPointMake(self.bounds.size.width*_progress, 0)];
    _progressLayer.path = _progressPath.CGPath;
}


- (void)setProgressWidth:(float)progressWidth
{
    _progressWidth = progressWidth;
    _trackLayer.lineWidth = _progressWidth;
    _progressLayer.lineWidth = _progressWidth;
    
    [self setTrack];
    [self setProgress];
}

- (void)setTrackColor:(UIColor *)trackColor
{
    _trackLayer.strokeColor = trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    
    [self setProgress];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    if (animated) {
        _progress = progress;
        [self setProgress];
        
        //ring animation
        CABasicAnimation *r1=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        r1.beginTime =CACurrentMediaTime();
        r1.duration=3;
        r1.removedOnCompletion=NO;
        r1.autoreverses = NO;
        r1.fillMode=kCAFillModeBoth;
        r1.fromValue=@(0);
        r1.toValue=@(1);
        r1.timingFunction=[CAMediaTimingFunction  functionWithControlPoints:0.42 : 0 :0.5 :1];
        [_progressLayer addAnimation:r1 forKey:@"r1"];
    }else{
        _progress = progress;
        [self setProgress];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

