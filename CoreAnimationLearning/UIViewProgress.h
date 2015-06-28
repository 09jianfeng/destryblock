//
//  UIViewProgress.h
//  JellyAnimation
//
//  Created by JFChen on 15/6/26.
//  Copyright (c) 2015年 HuaiNan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface UIViewProgress : UIView

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic) float progress;//0~1之间的数
@property (nonatomic) float progressWidth;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end

